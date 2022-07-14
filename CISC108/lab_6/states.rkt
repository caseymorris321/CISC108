#lang racket

(require json)
(require 2htdp/image)
;(require 2htdp/batch-io)
(require lang/posn)
(require racket/math)

(provide
 (struct-out loc) 
 loc->posn
 US-STATE-ABRVS
 ;get-state-outline
 draw-state
 sentiment-color
 string-downcase
 )

(define CLIENT_STORE (read-json (open-input-file "states.json")))
;(define CLIENT_STORE (string->jsexpr (read-file "states.json")))

;; RawLocs is a [NEListof (list Longitude Latitude)]

;; RawStateData is either 
;; -- a [NEListof RawLocs], or
;; -- a [NEListof [NEListof RawLocs]]

;; jsexpr->statedata : JSExpr --> RawStateData/ErrorString
(define (jsexpr->statedata s)
  (hash-ref CLIENT_STORE (string->symbol s) 
            (string-append "Requested state " s " does not exist")))

;; Latitude is North/South location, Number in [-90,90], 
;;   decimal degrees, Positive North of equator, Negative is south of equator.

;; Longitude is East/West location, Number in [-180,180], 
;;   decimal degrees, Positive East of Prime Meridian, Negative is West of the PM.

(define-struct loc (lat lon) #:transparent)
;; make-loc : Latitude Longitude --> Loc
;; Interpretation
;;  lat [Latitutde]: North/South decimal degrees, Number in [-90,90]
;;  lon [Longitude]: East/West decimal degrees, Number in [-180,180]
;; Example
(define OFFICE (make-loc 39.680556 -75.753889))
;; TEMPLATE for Loc
#; (define (fn-for-loc loc)
     ... (loc-lat loc)   ;Latitude, a Number
     ... (loc-lon loc) ) ;Longitude, a Number

;; Region is a [Listof loc] representing one connected polygon in a state.
;; StateOutline is a [Listof Region] representing all of the regions that make up a state.
;;    Some states like Hawaii and Virginia have more than one non-contiguous region.

;; raw-locs->region : RawLocs --> Region
;; convert a list of RawLoc lorl into a list of locs.

(define (raw-locs->region lorl)
  (map (λ (raw) (make-loc (second raw) (first raw))) lorl))

;; raw-state->state-outline : RawStateData --> StateOutline
;; converts raw state data rsd into a state outline, which is a list of regions
(define (raw-state->state-outline rsd)
  (map raw-locs->region rsd))

;; StateAbrv is a two letter string represeting a US state or DC
(define US-STATE-ABRVS 
  (list "AL" "AZ" "AR" "CA" "CO" "CT" "DE" "DC" "FL" "GA" "HI" "ID" "IL" 
        "IN" "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" "MO" "MT" "NE" 
        "NV" "NH" "NJ" "NM" "NY" "NC" "ND" "OH" "OK" "OR" "PA" "RI" "SC" "SD" 
        "TN" "TX" "UT" "VT" "VA" "WA" "WV" "WI" "WY" "AK"))

;; get-state-outline : StateAbrv -> StateOutline
(define (get-state-outline s)
  (local [(define raw (jsexpr->statedata s))]
    (cond [(string? raw) (error raw)]
          [(= 1 (length raw)) (raw-state->state-outline raw)]
          [else ;state has multiple regions
           (foldr (λ (raw outline) (append (raw-state->state-outline raw) outline))
                  empty
                  raw)])))

; ORIGINAL PYTHON CODE
;def albers_projection(origin, parallels, translate, scale):
;    """Return an Albers projection from geographic positions to x-y positions.
;
;    Derived from Mike Bostock's Albers javascript implementation for D3
;    http://mbostock.github.com/d3
;    http://mathworld.wolfram.com/AlbersEqual-AreaConicProjection.html
;
;    origin -- a geographic position
;    parallels -- bounding latitudes
;    translate -- x-y translation to place the projection within a larger map
;    scale -- scaling factor
;    """
;    phi1, phi2 = [radians(p) for p in parallels]
;    base_lat = radians(latitude(origin))
;    s, c = sin(phi1), cos(phi1)
;    base_lon = radians(longitude(origin))
;    n = 0.5 * (s + sin(phi2))
;    C = c*c + 2*n*s
;    p0 = sqrt(C - 2*n*sin(base_lat))/n
;
;    def project(position):
;        lat, lon = radians(latitude(position)), radians(longitude(position))
;        t = n * (lon - base_lon)
;        p = sqrt(C - 2*n*sin(lat))/n
;        x = scale * p * sin(t) + translate[0]
;        y = scale * (p * cos(t) - p0) + translate[1]
;        return (x, y)
;    return project
;
;_lower48 = albers_projection(make_position(38, -98), [29.5, 45.5], [480,250], 1000)
;_alaska = albers_projection(make_position(60, -160), [55,65], [150,440], 400)
;_hawaii = albers_projection(make_position(20, -160), [8,18], [300,450], 1000)


;; albers-projection: Loc (list Lat Lat) (list PosInt PosInt) PosInt --> (Loc-->Posn)
;;    origin -- a geographic position
;;    parallels -- bounding latitudes
;;    translate -- x-y translation to place the projection within a larger map
;;    scale -- scaling factor
;; Produces a FUNCTION that maps GPS Locations to X,Y Positions
(define (albers-projection origin parallels translate scale)
  (local [(define phi1 (degrees->radians (first parallels)))
          (define phi2 (degrees->radians (second parallels)))
          (define base-lat (degrees->radians (loc-lat origin)))
          (define s (sin phi1))
          (define c (cos phi1))
          (define base-lon (degrees->radians (loc-lon origin)))
          (define n (* 0.5 (+ s (sin phi2))))
          (define C (+ (* c c) (* 2 n s)))
          (define p0 (/ (sqrt (- C (* 2 n (sin base-lat)))) n))]
    (λ (position)
      (local [(define lat (degrees->radians (loc-lat position)))
              (define lon (degrees->radians (loc-lon position)))
              (define t (* n (- lon base-lon)))
              (define p (/ (sqrt (- C (* 2 n (sin lat)))) n))
              (define x (+ (* scale p (sin t)) (first translate)))
              (define y (+ (* scale (- (* p (cos t)) p0)) (second translate)))]
        (make-posn x y)))))

(define lower48-proj (albers-projection (make-loc 38 -98)
                                        (list 29.5 45.5)
                                        (list 480 250)
                                        1000))

(define alaska-proj (albers-projection (make-loc 60 -160)
                                       (list 55 65)
                                       (list 150 440)
                                       400))

(define hawaii-proj (albers-projection (make-loc 20 -160)
                                       (list 8 1865)
                                       (list 300 450)
                                       1000))
;; loc->posn : Loc --> Posn
;; Consumes a Loc loc (a GPS Location) and 
;; returns a Posn with x,y values suitable for drawing 
;; [via the Albers Projection, and with Alaska and Hawaii shifted]

(define (loc->posn loc)
  (cond [(< (loc-lat loc) 25) (hawaii-proj loc)]
        [(> (loc-lat loc) 51) (alaska-proj loc)]
        [else (lower48-proj loc)]))
  
;; a StateColorPair is (list StateAbrv Color)
;; where Color is any 2htdp/image color, e.g. a ColorString or (make-color...)

;; draw-state :  StateAbrv Color Image --> Image
;; Consumes a two-letter postal code state abbrev s,
;; a Color c (either a ColorSring or a (make-color ...))
;; and a background image, and produces the named state
;; solid filled with the given color, on the background
(define (draw-state state color background)
  (local [(define regions (get-state-outline state))
          (define drawable-regions 
            (map (λ (r) (map loc->posn r))
                 regions))]
    (foldr (λ (dregion image) (add-polygon (add-polygon image dregion "outline" "black") dregion "solid" color))
           background
           drawable-regions)))
    
#;(frame (foldr (λ (state image) (draw-state state (make-color 150 (random 255) (random 255)) image))
                empty-image
                US-STATE-ABRVS))
;; a Sentiment is an Number in [-4,4]
;; sentiment-color : Sentiment --> Color
;; consumes a sentiment, and produces a color (red for negative, green for positive)
;; and saturation (dark for strong, light for weak sentiments)
(define (sentiment-color n)
  (local [(define a (round (* 255 (/ (abs n) 4))))
          (define r (if (negative? n) 255 0))
          (define g (if (positive? n) 255 0))]
  (make-color r g 0 a)))

;; a Sentiment is an Number in [-4,4]
;; checked-sentiment-color : Sentiment --> Color
;; checks that the contract implied by the data definition
;; is actually obeyed.
;(check-error (checked-sentiment-color 4.01))
(define (checked-sentiment-color n)
  (if (<= -4 n 4)
      (sentiment-color n)
      (error "checked-sentiment-color: The sentiment supplied is not in the interval [-4,4]: " n)))
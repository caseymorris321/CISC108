#lang racket

; Load the internal libraries
(require 2htdp/image)

; Provide the external structs
(provide
 (struct-out gmaprq)
 (struct-out marker)
 get-static-map-tile
 gps-distance)

;; Google Static Map Tile API

(define-struct gmaprq
  (xsize ysize center zoom maptype markers) #:transparent)

(define-struct marker
  (color label lat lon) #:transparent) ;default marker size for now

(define (get-static-map-tile m)
  (cond [(> (gmaprq-xsize m) 640) (error "xsize too big" m)]
        [(> (gmaprq-xsize m) 640) (error "ysize too big" m)]
        [(not (member (gmaprq-maptype m) '("roadmap" "satellite" "hybrid" "terrain")))
         (error "maptype not one of roadmap, satellite, hybrid, terrain" m)]
        [(not (cons? (gmaprq-markers m))) (error "no marker supplied" m)]
        [else (get-tile-checked m)]))

(define (merge-marker marker string)
  (cond [(not (marker? marker)) (error "no marker supplied" marker)]
        [(not (= 1 (string-length (marker-label marker))))
         (error "marker label not one character" marker)]
        [else 
         (string-append
          "&markers="
          "color:" (marker-color marker)
          "%7Clabel:" (marker-label marker)
          "%7C" (number->string (exact->inexact (marker-lat marker)))
          "," (number->string (exact->inexact (marker-lon marker)))
          string)]))

(define (get-tile-checked m)
  (local [(define markers (gmaprq-markers m))]
    (bitmap/url
     (string-append
      "https://maps.googleapis.com/maps/api/staticmap?"
      "size=" (number->string (gmaprq-xsize m)) "x" (number->string (gmaprq-ysize m))
      "&maptype=" (gmaprq-maptype m)
      (foldl merge-marker "" markers)
      ))))


#;(define MAP2
    (bitmap/url
     "https://maps.googleapis.com/maps/api/staticmap?size=400x400&markers=color:blue%7Clabel:R%7C39.6836458,-75.7450008"))

#;(list (make-loc "Sun" "A big hot burning mass of hydrogen. Warning, do not stare." 39.683680 -75.753613 15)
        (make-loc "Mercury" "The planet closest to the Sun. Knows all of the Sun's best kept secrets." 39.683427 -75.753464 15)
        (make-loc "Venus" "Second planet from the sun. Home-planet of women." 39.683676 -75.752954 15)
        (make-loc "Earth" "Third planet from the sun. Mostly harmless." 39.683414 -75.754302 15)
        (make-loc "Mars" "Fourth planet from the sun. Home-planet of men." 39.682952 -75.752926 15)
        (make-loc "Jupiter" "Fifth planet from the sun. The largest planet of them all, it needs to go on a diet." 39.680840 -75.752655 15)
        (make-loc "Saturn" "Sixth planet from the sun. Loves wearing rings." 39.678545 -75.752391 15)
        (make-loc "Uranus" "Seventh planet from the sun. Often the source of much crude humor." 39.675273 -75.746725 15)
        (make-loc "Neptune" "Eighth planet from the sun. It's the farthest planet now that Plutos' been kicked out." 39.667019 -75.752438 15)
        (make-loc "Pluto" "Is it a planet? No one can seem to decide. So for now, let's just say that he's Mickey's loyal dog." 39.664166 -75.751086 15)
        )
#;(list (make-loc "Pencader" "An elevated Dining Hall that offers a large dining area." 39.689071 -75.757207 15)
        (make-loc "Rodney" "Looking vaguely like a house in the Shire, serves mostly freshman living in Rodney and Dickinson." 39.681446 -75.759267 15)
        (make-loc "Kent" "The most ornate dining hall, but also suffers from lack of selection. Still, it's not like Rodney or Pencader have giant chandeliers." 39.676330 -75.751220 15)
        (make-loc "Russell" "A ground level dining hall, usually packed with underclassmen." 39.677321 -75.747449 15)
                         )

;; THIS FUNCTION IS NOT VERY PRECISE!!!
;; NEED SOMEONE TO RECODE THE ALGORITHM!!!
;; gps-distance : Number Number Number Number -> Number
;; Parameters
;;  Number latA: latitude of point A
;;  Number lonA: longitude of point A
;;  Number latB: latitude of point B
;;  Number lonA: longitude of point B
;; Produces the approximate distance in meters between A and B
(define (gps-distance latA lonA latB lonB)
  (* 6378000
     (* 2
        (asin (min 1
                   (sqrt (+ (expt (sin (/ (- (deg->rad latA) (deg->rad latB)) 2)) 2)
                            (* (cos (deg->rad latA))                
                               (cos (deg->rad latB))
                               (expt (sin (/ (- (deg->rad lonA) (deg->rad lonB)) 2)) 2)))))))))

(define (deg->rad angle)
  (* angle (/ pi 180)))

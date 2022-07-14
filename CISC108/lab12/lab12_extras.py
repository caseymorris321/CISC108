"""
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

(check-within (distance (make-geoloc 90 10) (make-geoloc 90 100)) 0 0.001)
"""
import math
def deg_to_rad(angle):
    return angle * (math.pi / 180)

def gps_distance(latA, lonA, latB, lonB):
    return 6378000 *\
           2 * \
           (math.asin(min(1, \
                             math.sqrt( \
                                 math.pow(math.sin((deg_to_rad(latA) - deg_to_rad(latB)) / 2), 2) + \
                                 (math.cos(deg_to_rad(latA))* \
                                  math.cos(deg_to_rad(latB)) * \
                                  math.pow((math.sin(( deg_to_rad(lonA) - deg_to_rad(lonB)) / 2)),2))))))

assert gps_distance(2,3,4,5) == 314628.5670789445

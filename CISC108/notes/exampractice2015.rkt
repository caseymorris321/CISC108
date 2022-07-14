;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exampractice2015) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;1.
#|
Many statistical functions require computing the square of the difference between an
observed value x and the mean value μ. Design a function sqrdev that consumes both
an observed value and a mean, and computes (x - μ)2. Your solution should include
the function signature, purpose statement, unit test(s), and complete function
definition. You must also include the data definitions for any non-builtin types you
require, however examples and templates for such data definitions are not required.
Only the comments that actually define the new type(s) are required.
|#
;; sqrdev: Number Number -> Number
;; Consumes :
;;  Number x
;;  Number u
;; Produces :
;;  The square of the difference between x and u

(check-expect (sqrdev 5 2) 9)
(define (sqrdev x u)
  (sqr (- x u)))

#|
Design a function convert-to-dollars that consumes (1) a Number amount and (2) a
String currency, which is one of "euro",	"pound", or "yen". The amount represents
some amount of money in the specified currency. The function returns the equivalent
amount in dollars.
Use the following conversion rates:
• one euro = $1.28
• one pound = $1.52
• one yen = $0.0083
Your solution should include the function signature, purpose statement, unit
test(s), and complete function definition. You must also include the data definitions
for any non-builtin types you require, however examples and templates for such data
definitions are not required. Only the comments that actually define the new type(s) are
required.
|#

;2.
;; convert-to-dollars: Number String -> Number
;; Consumes:
;;   Number num the amount of money
;;   String cur represents some amount of money in the specified currency 
;; Produces:
;;   The equivalent amount of currency converted to dollars
(check-expect (convert-to-dollars 1 "euro") 1.28)
(check-expect (convert-to-dollars 1 "pound") 1.52)
(check-expect (convert-to-dollars 1 "yen") 0.0083)

(define (convert-to-dollars num cur)
  (cond
    [(string=? cur "euro") (* num 1.28)]
    [(string=? cur "pound") (* num 1.52)]
    [(string=? cur "yen") (* num 0.0083)]))

;3.
(define-struct meal [kind calories])
#|
;; meal-fun: Meal->
;; Consumes:
;;  Meal a-meal
;; Produces:
(define (meal-fun a-meal)
...(meal-kind a-meal)...
...(meal-calories a-meal)...)
|#
(define MEAL1 (make-meal "breakfast" 800))

;; A FitnessRecord is one of:
;;  - Meal
;;  - Activity

#|
;; fit-rec-fun : FitnessRecord -> String
(define (fit-rec-fun a-fit-rec)
  (cond
    [(meal? a-fit-rec) (meal-fun a-fit-rec)]
    [(activity? a-fit-rec) (activity-fun a-fit-rec)]))
|#
#|
In this problem you will design a function withhold, which consumes an Employee and
computes how much tax should be withheld from that employee's pay in one year. The
withholding amount is computed as follows:
  if the employee lives in WILMINGTON DE, it is 6.125% of his/her salary
  if the employee lives in any other city in DE: 5% of salary
  if the employee lives in any other state: 6% of salary
You will complete this in two steps.
(a) First design a function tax-rate, which consumes a PersonalData and returns
the appropriate tax rate for a person with that data. (For example, the tax rate for
someone in WILMINGTON DE would be .06125.) Include signature, purpose
statement, unit tests providing complete code coverage, and the function definition.
(b) Now design the function withhold. Include signature, purpose statement, one unit
test, and the function definition.
|#
;4.
(define-struct personal-data (name social city state))
(define-struct employee (pd salary))

(define (tax-rate PersonalData)
  (cond
    [(if (string=? (personal-data-state "DE")) (* (employee-salary .05))
    (personal-data-city "Wilmington")) (* (employee-salary .06125))]
    [else .06]))

(define (withhold employee)
  (tax-rate employee))

;2014 practice exam
;1.
(define (yell astring)
  (string-append
   astring
   "!"))

;2.
(define (bump grade)
  (cond
    [(string=? "F" grade) "D"]
    [(string=? "D" grade) "C"]
    [(string=? "C" grade) "B"]
    [(string=? "B" grade) "A"]))
    


;4.
(define-struct point (x y))
(define-struct rect (p width height))
(define POINT1 (make-point 0 0))
(define RECT1 (make-rect POINT1 10 10))
(check-expect (contains? RECT1 POINT1) #false)
(check-expect (contains? RECT1 (make-point 5 5)) #true)
(define (contains? arect apoint)
   (and
    (< (point-x (rect-p arect)) 
       (point-x apoint) 
       (+ (point-x (rect-p arect)) 
          (rect-width arect)))
    (< (point-y (rect-p arect)) 
       (point-y apoint) 
       (+ (point-y (rect-p arect)) 
          (rect-height arect)))))

(define (count-contains astring alos)
  (cond [(empty? alos) 0]
        [(cons? alos)
         (if (string=? (string-contains? #true))
             (+ (count-contains astring (rest alos)) 1)
        (count-contains astring (rest alos)))]))
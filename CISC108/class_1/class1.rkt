;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname class1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; These are my notes from CISC 108 Section 10 from Tue Aug 30, 2016
; Class #1!

(+ (* 3 2) (* -1 5))

(+ (* (/ 3 2) 15) (- 3.1415 (* 2 3)))

(define TAX-RATE .31)
(define FED-RATE .03)
(define CC-INT-RATE (* 5 FED-RATE))


(* TAX-RATE (- 20000 5000))

(* TAX-RATE (- 25000 5000))

(* TAX-RATE (- 200000 5000))


; how to write a function
;        header
(define (f x y)
; body
  (+ x y))

(define (g x y z)
 (* x (+ y (* z z z)) 2))


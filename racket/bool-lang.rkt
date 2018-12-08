#lang racket

(require (for-syntax racket syntax/parse))
(provide #%module-begin
         #%top
         #%top-interaction
         true
         false
         and
         or
         not
         #%app
         ⊃
         (rename-out [truth-table λ]))



(define-syntax (bool->lit stx)
  (syntax-parse stx
    #:literals (true false)
    [(_ true) #'(λ (x) x)]
    [(_ false) #'not]))

(define-syntax (truth-table stx)
  (syntax-parse stx
    #:literals (true false)
    [(_ (x ...) [arg ... = res] ...)
     #:with (dnf-clause-fn ...)
     #'((λ (x ...)
         (and res
              ((bool->lit arg) x)...))...)
     #'(λ (x ...)
         (or (dnf-clause-fn x ...)...))]))

(define ⊃
  (truth-table (x y)
               [false false = true]
               [true false = false]
               [false true = true]
               [true true = true]))
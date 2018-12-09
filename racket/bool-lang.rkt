#lang racket

(require (for-syntax racket syntax/parse))
(provide #%module-begin
         #%top
         #%top-interaction
         #%datum
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
    ;#:literals (true false)
    [(_ #t) #'(λ (x) x)]
    [(_ #f) #'not]))

(define-syntax (truth-table stx)
  (syntax-parse stx
    ;#:literals (true false)
    [(_ (x:id ...) [arg:boolean ... = res:boolean] ...)
     #:with (dnf-clause-fn ...)
     #'((λ (x ...)
         (and res
              ((bool->lit arg) x)...))...)
     #'(λ (x ...)
         (or (dnf-clause-fn x ...)...))]))


(define ⊃
  (truth-table (x y)
               [#f #f = #t]
               [#t #f = #f]
               [#f #t = #t]
               [#t #t = #t]))
#lang s-exp "bool-lang.rkt"

((λ (x) [#t = #f] [#f = #t]) (⊃ false true))
(⊃ true false)
;(+ 1 2)  ;error
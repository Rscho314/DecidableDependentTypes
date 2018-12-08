#lang s-exp "bool-lang.rkt"

((λ (x) [true = false] [false = true]) (⊃ false true))
((λ (x) [true = false] [false = true]) (⊃ true false))
(⊃ true false)
(⊃ true true)
(⊃ false false)
(⊃ false true)
;(+ 1 2)  ;error


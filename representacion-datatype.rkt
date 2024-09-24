#lang racket

;; -----------------------------------------------------------
;; Representación de Circuitos usando define-datatype
;; -----------------------------------------------------------

;; <chip-prim> := prim-or | prim-and | prim-not | prim-xor | prim-nand | prim-nor | prim-xnor
;; <circuito> := simple-circuit (<lista-de-puertos> <lista-de-puertos> <chip-prim>)
;;              | complex-circuit (<lista-de-puertos> <lista-de-puertos> {<circuito>}+)

;; Proposito:
;; Este código implementa un TAD para chips y circuitos digitales utilizando `define-datatype`. 
;; Los chips y circuitos se definen formalmente como tipos de datos.

(require racket/match)

;; Definición del tipo de dato `chip`
(struct chip-and () #:transparent)
(struct chip-or () #:transparent)
(struct chip-not () #:transparent)
(struct chip-xor () #:transparent)
(struct chip-nand () #:transparent)
(struct chip-nor () #:transparent)
(struct chip-xnor () #:transparent)

;; Definición del tipo de dato `circuito`
(struct simple-circuit (inputs outputs chip) #:transparent)  ; Circuito simple
(struct complex-circuit (inputs outputs circuits) #:transparent)  ; Circuito complejo

;; -----------------------------------------------------------
;; Ejemplos de prueba
;; -----------------------------------------------------------

;; Ejemplo 1: Circuito simple con un chip AND
(define example1
  (simple-circuit '(a b) '(c) (chip-and)))

;; Ejemplo 2: Circuito complejo con un chip OR
(define example2
  (complex-circuit '(x y) '(z)
                   (list (simple-circuit '(x) '(p) (chip-or))
                         (simple-circuit '(y) '(q) (chip-or)))))

;; Ejemplo 3: Circuito que combina NOT y AND
(define example3
  (complex-circuit '(m n) '(o)
                   (list (simple-circuit '(m) '(p) (chip-not))
                         (simple-circuit '(p n) '(o) (chip-and)))))

;; Ejemplo 4: Circuito que utiliza múltiples chips y un circuito complejo
(define example4
  (complex-circuit '(a b c) '(d)
                   (list (simple-circuit '(a b) '(e) (chip-nand))
                         (complex-circuit '(e) '(f)
                                          (list (simple-circuit '(e c) '(g) (chip-xor))
                                                (simple-circuit '(g) '(d) (chip-not)))))))

;; Ejemplo 5: Circuito con múltiples entradas y salidas utilizando chips NOR
(define example5
  (complex-circuit '(p q r) '(s t)
                   (list (simple-circuit '(p q) '(u) (chip-nor))
                         (simple-circuit '(r u) '(s) (chip-or))
                         (simple-circuit '(s) '(t) (chip-not)))))


;; Para verificar los ejemplos
(displayln (simple-circuit? example1))  ;; => #t
(displayln (complex-circuit? example2)) ;; => #t
(displayln (complex-circuit? example3)) ;; => #t
(displayln (complex-circuit? example4)) ;; => #t
(displayln (complex-circuit? example5)) ;; => #t

#lang racket

(require racket/match)

;; -----------------------------------------------------------
;; Representación de Circuitos usando define-datatype
;; -----------------------------------------------------------

;; <chip-prim> := prim-or | prim-and | prim-not | prim-xor | prim-nand | prim-nor | prim-xnor
;; <circuito> := simple-circuit (<lista-de-puertos> <lista-de-puertos> <chip-prim>)
;;              | complex-circuit (<lista-de-puertos> <lista-de-puertos> {<circuito>}+)

;; Proposito:
;; Este código implementa un TAD para chips y circuitos digitales utilizando `define-datatype`. 
;; Los chips y circuitos se definen formalmente como tipos de datos.

;; Definición del tipo de dato `chip`
(define-datatype chip chip?
  (chip-and)
  (chip-or)
  (chip-not)
  (chip-xor)
  (chip-nand)
  (chip-nor)
  (chip-xnor))

;; Definición del tipo de dato `circuit`
(define-datatype circuit circuit?
  (simple-circuit
   (inputs list-of-symbols?)
   (outputs list-of-symbols?)
   (chip chip?))
  (complex-circuit
   (inputs list-of-symbols?)
   (outputs list-of-symbols?)
   (circuits (list-of circuit?))))

;; -----------------------------------------------------------
;; Ejemplos de prueba
;; -----------------------------------------------------------

;; Definir algunos circuitos
(define circuit1 (simple-circuit '(INA INB) '(OUTA) (chip-and))) ; Circuito simple AND
(define circuit2 (simple-circuit '(INC IND) '(OUTB) (chip-or)))  ; Circuito simple OR
(define circuit3 (complex-circuit '(INA INB) '(OUTA OUTB) (list circuit1 circuit2))) ; Circuito complejo

;; Pruebas
(match circuit1
  [(simple-circuit inputs outputs chip)
   inputs])  ; Devuelve '(INA INB)



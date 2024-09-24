#lang racket

;; -----------------------------------------------------------
;; Representación de Circuitos usando Procedimientos
;; -----------------------------------------------------------

;; <chip-prim> := prim-or | prim-and | prim-not | prim-xor | prim-nand | prim-nor | prim-xnor
;; <circuito> := simple-circuit (<lista-de-puertos> <lista-de-puertos> <chip-prim>)
;;              | complex-circuit (<lista-de-puertos> <lista-de-puertos> {<circuito>}+)

;; Proposito:
;; Este código define la representación de chips y circuitos utilizando procedimientos (funciones) en lugar de listas.
;; Los chips se encapsulan como procedimientos que representan operaciones lógicas.

;; Definición de chips primitivos como procedimientos
(define (chip-or) 
  (lambda () 'prim-or))

(define (chip-and) 
  (lambda () 'prim-and))

(define (chip-not) 
  (lambda () 'prim-not))

(define (chip-xor) 
  (lambda () 'prim-xor))

(define (chip-nand) 
  (lambda () 'prim-nand))

(define (chip-nor) 
  (lambda () 'prim-nor))

;; Representación de un circuito simple usando procedimientos
(define (simple-circuit inputs outputs chip)
  (lambda () (list 'simple-circuit inputs outputs (chip))))

;; Representación de un circuito complejo usando procedimientos
(define (complex-circuit inputs outputs circuits)
  (lambda () (list 'complex-circuit inputs outputs circuits)))

;; Observadores para extraer partes del circuito
(define (circuit-inputs circuit)
  (cadr (circuit)))

(define (circuit-outputs circuit)
  (caddr (circuit)))

(define (circuit-chip circuit)
  (cadddr (circuit)))


;; -----------------------------------------------------------
;; Ejemplos de prueba
;; -----------------------------------------------------------

;; Ejemplo 1: XOR
(define circuit-xor (simple-circuit '(INA INB) '(OUTA) chip-xor))

;; Pruebas del Ejemplo 1
(circuit-inputs circuit-xor)  ; '(INA INB)
(circuit-outputs circuit-xor) ; '(OUTA)


;; Ejemplo 2: Circuito NAND con NOT
(define circuit-nand-not
  (complex-circuit '(INA INB) '(OUTA)
                   (list (simple-circuit '(INA INB) '(TEMP) chip-nand)
                         (simple-circuit '(TEMP) '(OUTA) chip-not))))

;; Pruebas del Ejemplo 2
(circuit-inputs circuit-nand-not) ; '(INA INB)


;; Ejemplo 3: Circuito NOR en cadena
(define circuit-nor-chain
  (complex-circuit '(INA INB) '(OUTA)
                   (list (simple-circuit '(INA INB) '(TEMP) chip-nor)
                         (simple-circuit '(TEMP) '(OUTA) chip-nor))))

;; Pruebas del Ejemplo 3
(circuit-outputs circuit-nor-chain) ; '(OUTA)


;; Ejemplo 4: Combinación de AND, XOR y OR
(define circuit-combo
  (complex-circuit '(INA INB INC IND) '(OUTA OUTB)
                   (list (simple-circuit '(INA INB) '(TEMP1) chip-xor)
                         (simple-circuit '(TEMP1 INC) '(OUTA) chip-and)
                         (simple-circuit '(INC IND) '(OUTB) chip-or))))

;; Pruebas del Ejemplo 4
(circuit-inputs circuit-combo) ; '(INA INB INC IND)
(circuit-outputs circuit-combo) ; '(OUTA OUTB)


;; Ejemplo 5: Circuito complejo con XOR y NAND
(define circuit-complex-xor-nand
  (complex-circuit '(INA INB INC) '(OUTA OUTB)
                   (list (simple-circuit '(INA INB) '(TEMP1) chip-xor)
                         (simple-circuit '(TEMP1 INC) '(OUTA) chip-nand)
                         (simple-circuit '(TEMP1) '(OUTB) chip-nand))))

;; Pruebas del Ejemplo 5
(circuit-outputs circuit-complex-xor-nand) ; '(OUTA OUTB)


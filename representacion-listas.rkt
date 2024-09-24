#lang racket

;; -----------------------------------------------------------
;; Representación de Circuitos usando Listas
;; -----------------------------------------------------------

;; <chip-prim> := prim-or | prim-and | prim-not | prim-xor | prim-nand | prim-nor | prim-xnor
;; <circuito> := simple-circuit (<lista-de-puertos> <lista-de-puertos> <chip-prim>)
;;              | complex-circuit (<lista-de-puertos> <lista-de-puertos> {<circuito>}+)

;; Proposito:
;; Este código define la representación de chips y circuitos usando listas. Los chips son los elementos primitivos
;; y los circuitos pueden ser simples o complejos.

;; Definición de chips primitivos
(define (chip-or) '(prim-or))
(define (chip-and) '(prim-and))
(define (chip-not) '(prim-not))
(define (chip-xor) '(prim-xor))
(define (chip-nand) '(prim-nand))
(define (chip-nor) '(prim-nor))
(define (chip-xnor) '(prim-xnor))

;; Representación de un circuito simple
(define (simple-circuit inputs outputs chip)
  (list 'simple-circuit inputs outputs chip))

;; Representación de un circuito complejo
(define (complex-circuit inputs outputs circuits)
  (list 'complex-circuit inputs outputs circuits))

;; Predicados para verificar el tipo de circuito
(define (simple-circuit? circuit)
  (eq? (car circuit) 'simple-circuit))

(define (complex-circuit? circuit)
  (eq? (car circuit) 'complex-circuit))

;; Observadores para obtener las partes del circuito
(define (circuit-inputs circuit)
  (cadr circuit))

(define (circuit-outputs circuit)
  (caddr circuit))

(define (circuit-chip circuit)
  (cadddr circuit))

;; -----------------------------------------------------------
;; Ejemplos de prueba
;; -----------------------------------------------------------

;; Ejemplo 1: XOR
(define circuit-xor (simple-circuit '(INA INB) '(OUTA) (chip-xor)))

;; Pruebas del Ejemplo 1
(simple-circuit? circuit-xor) ; #t
(circuit-inputs circuit-xor)  ; '(INA INB)
(circuit-outputs circuit-xor) ; '(OUTA)


;; Ejemplo 2: Circuito NAND con NOT
(define circuit-nand-not 
  (complex-circuit '(INA INB) '(OUTA OUTB) (list (simple-circuit '(INA INB) '(TEMP) (chip-nand))
                                                 (simple-circuit '(TEMP) '(OUTA) (chip-not)))))

;; Pruebas del Ejemplo 2
(complex-circuit? circuit-nand-not) ; #t
(circuit-inputs circuit-nand-not) ; '(INA INB)


;; Ejemplo 3: Mega AND con múltiples salidas
(define circuit-mega-and
  (simple-circuit '(INA INB INC) '(OUTA OUTB OUTC) (chip-and)))

;; Pruebas del Ejemplo 3
(circuit-outputs circuit-mega-and) ; '(OUTA OUTB OUTC)


;; Ejemplo 4: NOR con múltiples capas
(define circuit-nor 
  (complex-circuit '(INA INB INC) '(OUTA) 
                   (list (simple-circuit '(INA INB) '(TEMP1) (chip-nor))
                         (simple-circuit '(TEMP1 INC) '(OUTA) (chip-nor)))))

;; Pruebas del Ejemplo 4
(complex-circuit? circuit-nor) ; #t


;; Ejemplo 5: XOR y AND juntos
(define circuit-combo
  (complex-circuit '(INA INB INC IND) '(OUTA OUTB)
                   (list (simple-circuit '(INA INB) '(TEMP1) (chip-xor))
                         (simple-circuit '(TEMP1 INC) '(OUTA) (chip-and))
                         (simple-circuit '(INC IND) '(OUTB) (chip-or)))))

;; Pruebas del Ejemplo 5
(complex-circuit? circuit-combo) ; #t
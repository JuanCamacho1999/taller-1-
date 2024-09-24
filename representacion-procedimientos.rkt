;;MARTINEZ RIVERA WILSON ANDRES 2266319
;;JUAN DAVID CAMACHO CATAÑO 2266292
;;PAREDES CHAVES JUAN GABRIEL 2266183

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

(define (chip-xnor) 
  (lambda () 'prim-xnor))

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

;; Ejemplo 1: Circuito simple con XOR
(define circuit-xor (simple-circuit '(INA INB) '(OUTA) chip-xor))

;; Pruebas del Ejemplo 1
(define xor-inputs (circuit-inputs circuit-xor))  ; => '(INA INB)
(define xor-outputs (circuit-outputs circuit-xor)) ; => '(OUTA)

;; Ejemplo 2: Circuito NAND con NOT
(define circuit-nand-not
  (complex-circuit '(INA INB) '(OUTA)
                   (list (simple-circuit '(INA INB) '(TEMP) chip-nand)
                         (simple-circuit '(TEMP) '(OUTA) chip-not))))

;; Pruebas del Ejemplo 2
(define nand-not-inputs (circuit-inputs circuit-nand-not)) ; => '(INA INB)
(define nand-not-outputs (circuit-outputs circuit-nand-not)) ; => '(OUTA)

;; Ejemplo 3: Circuito NOR en cadena
(define circuit-nor-chain
  (complex-circuit '(INA INB) '(OUTA)
                   (list (simple-circuit '(INA INB) '(TEMP) chip-nor)
                         (simple-circuit '(TEMP) '(OUTA) chip-nor))))

;; Pruebas del Ejemplo 3
(define nor-chain-outputs (circuit-outputs circuit-nor-chain)) ; => '(OUTA)

;; Ejemplo 4: Combinación de AND, XOR y OR
(define circuit-combo
  (complex-circuit '(INA INB INC IND) '(OUTA OUTB)
                   (list (simple-circuit '(INA INB) '(TEMP1) chip-xor)
                         (simple-circuit '(TEMP1 INC) '(OUTA) chip-and)
                         (simple-circuit '(INC IND) '(OUTB) chip-or))))

;; Pruebas del Ejemplo 4
(define combo-inputs (circuit-inputs circuit-combo)) ; => '(INA INB INC IND)
(define combo-outputs (circuit-outputs circuit-combo)) ; => '(OUTA OUTB)

;; Ejemplo 5: Circuito complejo con XOR, NAND y AND
(define circuit-complex
  (complex-circuit '(INA INB INC IND) '(OUTA OUTB OUTC)
                   (list (simple-circuit '(INA INB) '(TEMP1) chip-xor)
                         (simple-circuit '(TEMP1 INC) '(TEMP2) chip-nand)
                         (simple-circuit '(TEMP2 IND) '(OUTA) chip-and)
                         (simple-circuit '(INC IND) '(OUTB) chip-or)
                         (simple-circuit '(INA) '(OUTC) chip-not))))

;; Pruebas del Ejemplo 5
(define complex-inputs (circuit-inputs circuit-complex)) ; => '(INA INB INC IND)
(define complex-outputs (circuit-outputs circuit-complex)) ; => '(OUTA OUTB OUTC)

;; Mostrar resultados
(define (print-example-results)
  (displayln "Ejemplo 1: Circuito XOR")
  (displayln (format "Entradas: ~a" xor-inputs))
  (displayln (format "Salidas: ~a" xor-outputs))
  
  (displayln "\nEjemplo 2: Circuito NAND con NOT")
  (displayln (format "Entradas: ~a" nand-not-inputs))
  (displayln (format "Salidas: ~a" nand-not-outputs))
  
  (displayln "\nEjemplo 3: Circuito NOR en cadena")
  (displayln (format "Salidas: ~a" nor-chain-outputs))
  
  (displayln "\nEjemplo 4: Combinación de AND, XOR y OR")
  (displayln (format "Entradas: ~a" combo-inputs))
  (displayln (format "Salidas: ~a" combo-outputs))
  
  (displayln "\nEjemplo 5: Circuito complejo con XOR, NAND y AND")
  (displayln (format "Entradas: ~a" complex-inputs))
  (displayln (format "Salidas: ~a" complex-outputs)))

(print-example-results)

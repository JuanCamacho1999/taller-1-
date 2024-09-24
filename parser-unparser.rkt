#lang racket

(require racket/match)

;; -----------------------------------------------------------
;; Parser y Unparser para Circuitos
;; -----------------------------------------------------------

;; <chip-prim> := prim-or | prim-and | prim-not | prim-xor | prim-nand | prim-nor | prim-xnor             
;; <circuito> := simple-circuit (<lista-de-puertos> <lista-de-puertos> <chip-prim>)
;;              | complex-circuit (<lista-de-puertos> <lista-de-puertos> {<circuito>}+)

;; Parser: convierte una lista en un datatype

;; Unparser: convierte un datatype en una lista

;; Definir las estructuras simple-circuit y complex-circuit
(struct simple-circuit (inputs outputs chip) #:transparent)
(struct complex-circuit (inputs outputs circuits) #:transparent)

;; Definir las estructuras para los chips lógicos
(struct chip-and () #:transparent)
(struct chip-or () #:transparent)
(struct chip-not () #:transparent)
(struct chip-xor () #:transparent)
(struct chip-nand () #:transparent)
(struct chip-nor () #:transparent)
(struct chip-xnor () #:transparent)

(define (parser lst)
  (match lst
    [(list 'simple-circuit inputs outputs chip) 
     (simple-circuit inputs outputs (parse-chip chip))]
    [(list 'complex-circuit inputs outputs circuits)
     (complex-circuit inputs outputs (map parser circuits))]))

(define (parse-chip chip)
  (match chip
    ['prim-and (chip-and)]
    ['prim-or (chip-or)]
    ['prim-not (chip-not)]
    ['prim-xor (chip-xor)]
    ['prim-nand (chip-nand)]
    ['prim-nor (chip-nor)]
    ['prim-xnor (chip-xnor)]))

(define (unparser circuit)
  (match circuit
    [(simple-circuit inputs outputs chip)
     (list 'simple-circuit inputs outputs (unparse-chip chip))]
    [(complex-circuit inputs outputs circuits)
     (list 'complex-circuit inputs outputs (map unparser circuits))]))

(define (unparse-chip chip)
  (match chip
    [(chip-and) 'prim-and]
    [(chip-or) 'prim-or]
    [(chip-not) 'prim-not]
    [(chip-xor) 'prim-xor]
    [(chip-nand) 'prim-nand]
    [(chip-nor) 'prim-nor]
    [(chip-xnor) 'prim-xnor]))

;; -----------------------------------------------------------
;; Auto-circuit: convierte automáticamente una lista en un circuito
;; -----------------------------------------------------------

(define (auto-circuit lst)
  (if (list? lst)
      (parser lst)
      lst))

;; -----------------------------------------------------------
;; Ejemplos de prueba
;; -----------------------------------------------------------

;; Ejemplo 1: Circuito simple con 'prim-and'
(define circuit1 (auto-circuit (list 'simple-circuit (list 'INA 'INB) (list 'OUTA) 'prim-and)))
(define circuit1-list (unparser circuit1))

;; Ejemplo 2: Circuito simple con 'prim-or'
(define circuit2 (auto-circuit (list 'simple-circuit (list 'INA 'INB) (list 'OUTB) 'prim-or)))
(define circuit2-list (unparser circuit2))

;; Ejemplo 3: Circuito simple con 'prim-xor'
(define circuit3 (auto-circuit (list 'simple-circuit (list 'INA 'INB) (list 'OUTC) 'prim-xor)))
(define circuit3-list (unparser circuit3))

;; Ejemplo 4: Circuito complejo con dos circuitos simples
(define circuit4 (auto-circuit
                  (list 'complex-circuit
                        (list 'INA 'INB)
                        (list 'OUTD)
                        (list (list 'simple-circuit (list 'INA) (list 'OUTA) 'prim-not)
                              (list 'simple-circuit (list 'INB) (list 'OUTB) 'prim-and)))))


(define circuit4-list (unparser circuit4))

;; Ejemplo 5: Circuito complejo con tres circuitos simples
(define circuit5 (auto-circuit
                  (list 'complex-circuit
                        (list 'INA 'INB)
                        (list 'OUTE)
                        (list (list 'simple-circuit (list 'INA) (list 'OUTA) 'prim-xor)
                              (list 'simple-circuit (list 'INB) (list 'OUTB) 'prim-or)
                              (list 'simple-circuit (list 'INA 'INB) (list 'OUTC) 'prim-nand)))))


(define circuit5-list (unparser circuit5))

;; Pruebas con identificación de ejemplos
(define (print-example-results)
  (displayln "Salida del Ejemplo 1: Circuito simple con 'prim-and'")
  (displayln circuit1-list)
  
  (displayln "Salida del Ejemplo 2: Circuito simple con 'prim-or'")
  (displayln circuit2-list)
  
  (displayln "Salida del Ejemplo 3: Circuito simple con 'prim-xor'")
  (displayln circuit3-list)
  
  (displayln "Salida del Ejemplo 4: Circuito complejo con dos circuitos simples")
  (displayln circuit4-list)
  
  (displayln "Salida del Ejemplo 5: Circuito complejo con tres circuitos simples")
  (displayln circuit5-list))

(print-example-results)

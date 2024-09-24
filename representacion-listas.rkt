;;MARTINEZ RIVERA WILSON ANDRES 2266319
;;JUAN DAVID CAMACHO CATAÑO 2266292
;;PAREDES CHAVES JUAN GABRIEL 2266183


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
;; Función para obtener las salidas de un circuito
;; -----------------------------------------------------------

(define (obtener-salidas circuit)
  (cond
    ;; Si es un circuito simple, devolvemos las salidas directamente.
    [(simple-circuit? circuit) (circuit-outputs circuit)]
    
    ;; Si es un circuito complejo, combinamos las salidas del circuito complejo con las de los subcircuitos.
    [(complex-circuit? circuit)
     (append (circuit-outputs circuit)
             (apply append (map obtener-salidas (cadddr circuit))))]))

;; -----------------------------------------------------------
;; Ejemplos de prueba
;; -----------------------------------------------------------

;; Ejemplo 1: XOR
(define circuit-xor (simple-circuit '(INA INB) '(OUTA) (chip-xor)))

;; Ejemplo 2: Circuito NAND con NOT
(define circuit-nand-not 
  (complex-circuit '(INA INB) '(OUTA OUTB) (list (simple-circuit '(INA INB) '(TEMP) (chip-nand))
                                                 (simple-circuit '(TEMP) '(OUTA) (chip-not)))))

;; Ejemplo 3: Mega AND con múltiples salidas
(define circuit-mega-and
  (simple-circuit '(INA INB INC) '(OUTA OUTB OUTC) (chip-and)))

;; Ejemplo 4: NOR con múltiples capas
(define circuit-nor 
  (complex-circuit '(INA INB INC) '(OUTA) 
                   (list (simple-circuit '(INA INB) '(TEMP1) (chip-nor))
                         (simple-circuit '(TEMP1 INC) '(OUTA) (chip-nor)))))

;; Ejemplo 5: XOR y AND juntos
(define circuit-combo
  (complex-circuit '(INA INB INC IND) '(OUTA OUTB)
                   (list (simple-circuit '(INA INB) '(TEMP1) (chip-xor))
                         (simple-circuit '(TEMP1 INC) '(OUTA) (chip-and))
                         (simple-circuit '(INC IND) '(OUTB) (chip-or)))))

;; -----------------------------------------------------------
;; Pruebas para mostrar las salidas
;; -----------------------------------------------------------

(displayln "Salidas de circuit-xor (Ejemplo 1):")
(displayln (obtener-salidas circuit-xor))

(displayln "Salidas de circuit-nand-not (Ejemplo 2):")
(displayln (obtener-salidas circuit-nand-not))

(displayln "Salidas de circuit-mega-and (Ejemplo 3):")
(displayln (obtener-salidas circuit-mega-and))

(displayln "Salidas de circuit-nor (Ejemplo 4):")
(displayln (obtener-salidas circuit-nor))

(displayln "Salidas de circuit-combo (Ejemplo 5):")
(displayln (obtener-salidas circuit-combo))

#lang racket

(require racket/match)

;; -----------------------------------------------------------
;; Parser y Unparser
;; -----------------------------------------------------------

;; Proposito:
;; Implementación de un parser y un unparser que transforman entre listas y circuitos definidos
;; con `define-datatype`.

;; Parser: De listas a TAD
(define (parser circuit-list)
  (match circuit-list
    [('simple-circuit inputs outputs chip)]
    [(simple-circuit inputs outputs (parser chip))]
    [('complex-circuit inputs outputs subcircuits)]
      [(complex-circuit inputs outputs (map parser subcircuits))]
    [('prim-or) (chip-or)]
    [('prim-and) (chip-and)]
    [('prim-not) (chip-not)]
    [('prim-xor) (chip-xor)]
    [_ (error "No se pudo parsear la lista.")]))

;; Unparser: De TAD a listas
(define (unparser circuit)
  (match circuit
    [(simple-circuit inputs outputs chip)
     `(simple-circuit ,inputs ,outputs ,(unparser chip))]
    [(complex-circuit inputs outputs subcircuits)
     `(complex-circuit ,inputs ,outputs ,@(map unparser subcircuits))]
    [(chip-or) 'prim-or]
    [(chip-and) 'prim-and]
    [(chip-not) 'prim-not]
    [(chip-xor) 'prim-xor]))

;; -----------------------------------------------------------
;; Ejemplos de prueba
;; -----------------------------------------------------------

;; Ejemplo 1: Parsear circuito simple de lista a TAD
(define parsed-circuit1 (parser '(simple-circuit (A B) (OUT) (prim-and))))
(simple-circuit? parsed-circuit1)  ; #t
(unparser parsed-circuit1)         ; '(simple-circuit (A B) (OUT) (prim-and))

;; Ejemplo 2: Parsear circuito complejo de lista a TAD
(define parsed-circuit2 (parser '(complex-circuit (A B) (OUT1 OUT2)
                                                 (simple-circuit (X Y) (OUT1) (prim-or))
                                                 (simple-circuit (Z) (OUT2) (prim-not)))))
(complex-circuit? parsed-circuit2)  ; #t
(unparser parsed-circuit2)          ; '(complex-circuit (A B) (OUT1 OUT2) ...)

;; Ejemplo 3: Parsear un circuito con múltiples subcircuitos
(define parsed-circuit3 (parser '(complex-circuit (INA INB) (OUTA)
                                                 (simple-circuit (A B) (OUT) (prim-and))
                                                 (complex-circuit (X Y) (OUTX) 
                                                                  (simple-circuit (X) (Y) (prim-not))))))
(complex-circuit? parsed-circuit3)  ; #t
(unparser parsed-circuit3)          ; '(complex-circuit (INA INB) (OUTA) ...)

;; Ejemplo 4: Unparser de circuito simple
(define circuit-simple (simple-circuit '(X Y) '(OUT) (chip-or)))
(unparser circuit-simple)           ; '(simple-circuit (X Y) (OUT) (prim-or))

;; Ejemplo 5: Unparser de circuito complejo
(define circuit-complex (complex-circuit '(A B) '(OUT1 OUT2))
                                         (list (simple-circuit '(X Y) '(OUT) (chip-and))
                                               (complex-circuit '(Z) '(OUT3)
                                                                (list (simple-circuit '(Z) '(OUT) (chip-not))))))
(unparser circuit-complex)          ; '(complex-circuit (A B) (OUT1 OUT2) ...)

#lang racket

(require racket/match)

;; -----------------------------------------------------------
;; Definición de las estructuras chip y circuit
;; -----------------------------------------------------------

;; Definición de chips
(struct chip-and () #:transparent)
(struct chip-or () #:transparent)
(struct chip-not () #:transparent)
(struct chip-xor () #:transparent)
(struct chip-nand () #:transparent)
(struct chip-nor () #:transparent)
(struct chip-xnor () #:transparent)

;; Definición de circuitos
(struct simple-circuit (inputs outputs chip) #:transparent)
(struct complex-circuit (inputs outputs circuits) #:transparent)

;; -----------------------------------------------------------
;; Parser y Unparser para Circuitos
;; -----------------------------------------------------------

;; Parser: convierte una lista en un datatype
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

;; Unparser: convierte un datatype en una lista
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
;; Ejemplos de prueba
;; -----------------------------------------------------------

;; Ejemplo 1: Circuito simple con AND
(define example1 
  (simple-circuit '(A B) '(C) (chip-and)))

;; Ejemplo 2: Circuito complejo con OR y AND
(define example2 
  (complex-circuit '(X Y) '(Z)
                   (list (simple-circuit '(X) '(P) (chip-or))
                         (simple-circuit '(Y P) '(Q) (chip-and)))))

;; Ejemplo 3: Circuito que combina NOT y NAND
(define example3 
  (complex-circuit '(M N) '(O)
                   (list (simple-circuit '(M) '(P) (chip-not))
                         (simple-circuit '(P N) '(O) (chip-nand)))))

;; Ejemplo 4: Circuito que utiliza múltiples chips en un circuito complejo
(define example4 
  (complex-circuit '(A B C) '(D)
                   (list (simple-circuit '(A B) '(E) (chip-nor))
                         (complex-circuit '(E) '(F)
                                          (list (simple-circuit '(E C) '(G) (chip-xor))
                                                (simple-circuit '(G) '(D) (chip-not)))))))

;; Ejemplo 5: Circuito que utiliza múltiples chips y un chip XOR
(define example5 
  (complex-circuit '(P Q R) '(S T)
                   (list (simple-circuit '(P Q) '(U) (chip-xnor))
                         (simple-circuit '(R U) '(S) (chip-or))
                         (simple-circuit '(S) '(T) (chip-not)))))

;; -----------------------------------------------------------
;; Ejemplos de parser y unparser
;; -----------------------------------------------------------

;; Parser: convertir una lista a un circuito
(define parsed-example1 (parser '(simple-circuit '(A B) '(C) 'prim-and)))
(define parsed-example2 (parser '(complex-circuit '(X Y) '(Z) 
                                         (list 'simple-circuit '(X) '(P) 'prim-or) 
                                         (list 'simple-circuit '(Y P) '(Q) 'prim-and))))

;; Unparser: convertir un circuito a una lista
(define unparsed-example1 (unparser example1))
(define unparsed-example2 (unparser example2))

;; Mostrar resultados
(displayln "Parsed Example 1:")
(displayln parsed-example1)  ;; Circuito simple con AND
(displayln "Unparsed Example 1:")
(displayln unparsed-example1) ;; Devuelve la lista correspondiente

(displayln "Parsed Example 2:")
(displayln parsed-example2)  ;; Circuito complejo con OR y AND
(displayln "Unparsed Example 2:")
(displayln unparsed-example2) ;; Devuelve la lista correspondiente

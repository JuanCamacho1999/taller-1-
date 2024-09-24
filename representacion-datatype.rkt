;;MARTINEZ RIVERA WILSON ANDRES 2266319
;;JUAN DAVID CAMACHO CATAÑO 2266292
;;PAREDES CHAVES JUAN GABRIEL 2266183



#lang racket
;; -----------------------------------------------------------
;; Representación de Circuitos usando define-datatype
;; -----------------------------------------------------------

;; <chip-prim> := prim-or | prim-and | prim-not | prim-xor | prim-nand | prim-nor | prim-xnor
;; <circuito> := simple-circuit (<lista-de-puertos> <lista-de-puertos> <chip-prim>)  porque este codigo imrpime #t 
;;              | complex-circuit (<lista-de-puertos> <lista-de-puertos> {<circuito>}+)

;; Proposito:
;; Este código implementa un TAD para chips y circuitos digitales utilizando define-datatype. 
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

;; -----------------------------------------------------------
;; Función para obtener las salidas de un circuito
;; -----------------------------------------------------------

(define (obtener-salidas circuito)
  (match circuito
    ;; Para un circuito simple, devolvemos sus salidas directamente.
    [(simple-circuit _ outputs _) outputs]

    ;; Para un circuito complejo, recolectamos las salidas de todos los subcircuitos y las combinamos con las salidas del circuito complejo.
    [(complex-circuit _ outputs subcircuits)
     (append outputs (apply append (map obtener-salidas subcircuits)))]))

;; -----------------------------------------------------------
;; Ejemplos de prueba para imprimir las salidas
;; -----------------------------------------------------------

(displayln "Salidas de example1:")
(displayln (obtener-salidas example1))

(displayln "Salidas de example2:")
(displayln (obtener-salidas example2))

(displayln "Salidas de example3:")
(displayln (obtener-salidas example3))

(displayln "Salidas de example4:")
(displayln (obtener-salidas example4))

(displayln "Salidas de example5:")
(displayln (obtener-salidas example5))


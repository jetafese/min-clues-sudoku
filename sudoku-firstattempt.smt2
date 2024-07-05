;; Declare variables for the Sudoku grid
;; (declare-datatype Pair ((pair (fst Int) (snd Int))))
(declare-const grid (Array Int Int))
(declare-const grid2 (Array Int Int))
(declare-const cluesr (Array Int Int))
(declare-const cluesc (Array Int Int))
(declare-const wr Int)
(declare-const wc Int)
(declare-const N Int)
(assert (= N 4))
(define-fun getIndex ((i Int) (j Int)) Int (- (+ i (* 9 j)) 9))

;; Initialize the grid with the given 16 clues
;; (assert (= (select grid 1 1) 5))   ;; Example: Set row 1, column 1 to 5
;; (assert (= (select grid 1 2) 3))   ;; Example: Set row 1, column 2 to 3
;; Continue initializing all given 16 clues...

;; Each cell contains a number between 1 and 9
(assert (forall ((i Int)) (=> (and (<= i 81) (>= i 1)) (and (<= (select grid 1) 9) (>= (select grid 1) 1)))))

(assert (forall ((i Int) (j Int))
                (=> (and (<= i 9) (>= i 1) (<= j 9) (>= j 1))
                    (and (<= (select grid (- (+ i (* 9 j)) 9)) 9) (<= i 9) (<= j 9))
                    (and (>= (select grid (- (+ i (* 9 j)) 9)) 1) (<= (select grid (- (+ i (* 9 j)) 9)) 9)))))

(assert (forall ((i Int) (j Int))
                (=> (and (<= i 9) (>= i 1) (<= j 9) (>= j 1))
                    (and (<= (select grid2 (- (+ i (* 9 j)) 9)) 9) (<= i 9) (<= j 9))
                    (and (>= (select grid2 (- (+ i (* 9 j)) 9)) 1) (<= (select grid2 (- (+ i (* 9 j)) 9)) 9)))))

;; Ensure each row contains all numbers from 1 to 9
(assert (forall ((i Int))
                (=> (and (<= i 9) (>= i 1))
                (distinct (select grid (- (+ i (* 9 1)) 9)) (select grid (- (+ i (* 9 2)) 9)) (select grid (- (+ i (* 9 3)) 9))
                          (select grid (- (+ i (* 9 4)) 9)) (select grid (- (+ i (* 9 5)) 9)) (select grid (- (+ i (* 9 6)) 9))
                          (select grid (- (+ i (* 9 7)) 9)) (select grid (- (+ i (* 9 8)) 9)) (select grid (- (+ i (* 9 9)) 9))))))

;; Ensure each column contains all numbers from 1 to 9
(assert (forall ((j Int))
                (=> (and (<= j 9) (>= j 1))
                (distinct (select grid (- (+ 1 (* 9 j)) 9)) (select grid (- (+ 2 (* 9 j)) 9)) (select grid (- (+ 3 (* 9 j)) 9))
                          (select grid (- (+ 4 (* 9 j)) 9)) (select grid (- (+ 5 (* 9 j)) 9)) (select grid (- (+ 6 (* 9 j)) 9))
                          (select grid (- (+ 7 (* 9 j)) 9)) (select grid (- (+ 8 (* 9 j)) 9)) (select grid (- (+ 9 (* 9 j)) 9))))))

;; Ensure each 3x3 subgrid contains all numbers from 1 to 9
(assert (forall ((di Int) (dj Int))
                (=> (and (<= di 3) (>= di 1) (<= dj 3) (>= dj 1))
                (distinct (select grid (getIndex (+ 1 (* di 3)) (+ 1 (* dj 3))))
                          (select grid (getIndex (+ 2 (* di 3)) (+ 1 (* dj 3))))
                          (select grid (getIndex (+ 3 (* di 3)) (+ 1 (* dj 3))))
                          (select grid (getIndex (+ 1 (* di 3)) (+ 2 (* dj 3))))
                          (select grid (getIndex (+ 2 (* di 3)) (+ 2 (* dj 3))))
                          (select grid (getIndex (+ 3 (* di 3)) (+ 2 (* dj 3))))
                          (select grid (getIndex (+ 1 (* di 3)) (+ 3 (* dj 3))))
                          (select grid (getIndex (+ 2 (* di 3)) (+ 3 (* dj 3))))
                          (select grid (getIndex (+ 3 (* di 3)) (+ 3 (* dj 3))))))))

(assert (forall ((k Int)) (=> (and (<= k N) (>= k 1) (<= 9 (select cluesr k)) (>= (select cluesr k) 1) (<= 9 (select cluesc k)) (>= (select cluesc k) 1))
                              (= (select grid (getIndex (select cluesr k) (select cluesc k))) (select grid2 (getIndex (select cluesr k) (select cluesc k)))))))

(assert (and (>= wr 1) (<= wr 9)(>= wc 1) (<= wc 9) (not (= (select grid (getIndex wr wc)) (select grid2 (getIndex wr wc))))))
(check-sat)
(get-model)

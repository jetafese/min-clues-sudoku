;; Declare variables for the Sudoku grid
(declare-datatype Pair ((pair (fst Int) (snd Int))))
(declare-const grid (Array Pair Int))
(declare-const grid2 (Array Pair Int))
(declare-const cluesr (Array Int Int))
(declare-const cluesc (Array Int Int))
(declare-const wr Int)
(declare-const wc Int)
(declare-const N Int)
(assert (= N 4))

;; Initialize the grid with the given 16 clues
;; (assert (= (select grid 1 1) 5))   ;; Example: Set row 1, column 1 to 5
;; (assert (= (select grid 1 2) 3))   ;; Example: Set row 1, column 2 to 3
;; Continue initializing all given 16 clues...

;; Each cell contains a number between 1 and 9
(assert (forall ((i Int) (j Int))
                (=> (and (<= i 9) (>= i 1) (<= j 9) (>= j 1))
                    (and (<= (select grid (pair i j)) 9) (<= i 9) (<= j 9))
                    (and (>= (select grid (pair i j)) 1) (<= (select grid (pair i j)) 9)))))

;; Ensure each row contains all numbers from 1 to 9
(assert (forall ((i Int))
                (=> (and (<= i 9) (>= i 1))
                (distinct (select grid (pair i 1)) (select grid (pair i 2)) (select grid (pair i 3))
                          (select grid (pair i 4)) (select grid (pair i 5)) (select grid (pair i 6))
                          (select grid (pair i 7)) (select grid (pair i 8)) (select grid (pair i 9))))))

;; Ensure each column contains all numbers from 1 to 9
(assert (forall ((j Int))
                (=> (and (<= j 9) (>= j 1))
                (distinct (select grid (pair 1 j)) (select grid (pair 2 j)) (select grid (pair 3 j))
                          (select grid (pair 4 j)) (select grid (pair 5 j)) (select grid (pair 6 j))
                          (select grid (pair 7 j)) (select grid (pair 8 j)) (select grid (pair 9 j))))))

;; Ensure each 3x3 subgrid contains all numbers from 1 to 9
(assert (forall ((di Int) (dj Int))
                (=> (and (<= di 3) (>= di 1) (<= dj 3) (>= dj 1))
                (distinct (select grid (pair (+ 1 (* di 3)) (+ 1 (* dj 3))))
                          (select grid (pair (+ 2 (* di 3)) (+ 1 (* dj 3))))
                          (select grid (pair (+ 3 (* di 3)) (+ 1 (* dj 3))))
                          (select grid (pair (+ 1 (* di 3)) (+ 2 (* dj 3))))
                          (select grid (pair (+ 2 (* di 3)) (+ 2 (* dj 3))))
                          (select grid (pair (+ 3 (* di 3)) (+ 2 (* dj 3))))
                          (select grid (pair (+ 1 (* di 3)) (+ 3 (* dj 3))))
                          (select grid (pair (+ 2 (* di 3)) (+ 3 (* dj 3))))
                          (select grid (pair (+ 3 (* di 3)) (+ 3 (* dj 3))))))))

(assert (forall ((k Int)) (=> (and (<= k N) (>= k 1) (<= 9 (select cluesr k)) (>= (select cluesr k) 1) (<= 9 (select cluesc k)) (>= (select cluesc k) 1))
                              (= (select grid (pair (select cluesr k) (select cluesc k))) (select grid2 (pair (select cluesr k) (select cluesc k)))))))

(assert (and (>= wr 1) (<= wr 9)(>= wc 1) (<= wc 9) (not (= (select grid (pair wr wc)) (select grid2 (pair wr wc))))))

;; ;; Check if there exists more than one solution for the Sudoku puzzle
;; (assert (not (and
;;               ;; Ensure the second grid has a different solution than the first
;;               (= (select grid2 1 1) (select grid 1 1))
;;               (= (select grid2 1 2) (select grid 1 2))
;;               ;; Continue for all cells...

;;               ;; Ensure both grids satisfy Sudoku rules
;;               (forall ((i Int) (j Int))
;;                       (=> (and (<= 1 (select grid i j) 9) (<= 1 i 9) (<= 1 j 9))
;;                           (= (select grid2 i j) (select grid i j)))))))

;; Check satisfiability (if the above condition is satisfiable, there are multiple solutions)
(check-sat)

;; If unsatisfiable, there is exactly one solution
;; (assert (not (check-sat)))
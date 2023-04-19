;; [[file:acl-chapter3.org::*Chapter 3.3: Why lisp has no pointers][Chapter 3.3: Why lisp has no pointers:1]]
(setf x '(1 2 3 4))
(setf y x)
(format t "x:  ~A, y: ~A, eql: ~A~%" x y (eql x y))

(setf x '(10 20 30))    ; y will point to the list from the first setf
(format t "x: ~A, y: ~A, eql: ~A~%" x y (eql x y))
;; Chapter 3.3: Why lisp has no pointers:1 ends here

;; [[file:acl-chapter3.org::*Chapter 3.3: Why lisp has no pointers][Chapter 3.3: Why lisp has no pointers:3]]
(setf x '(1 2 3 4))
(setf y x)
(format t "x: ~A, y: ~A, eql: ~A~%" x y (eql x y))

(setf (car x) 0         ; y gets updated as well
      (third x) 0)
(format t "x: ~A, y: ~A, eql: ~A~%" x y (eql x y))
;; Chapter 3.3: Why lisp has no pointers:3 ends here

;; [[file:acl-chapter3.org::*Compress][Compress:1]]
(defun compress (x)                                             ; (7)
  (if (consp x)
      (compress-list (car x) 1 (cdr x))
      x))

(defun compress-list (last-item last-n rest)                    ; (2)
  (if (null rest)
      (list (n-items last-item last-n))                         ; (3)
      (let ((next-item (car rest)))
        (if (= last-item next-item)                             ; (4)
            (compress-list last-item (+ last-n 1) (cdr rest))   ; (5)
            (cons (n-items last-item last-n)                    ; (6)
                  (compress-list next-item 1 (cdr rest)))))))


(defun n-items (item n)                                         ; (1)
  (if (> n 1)
      (list n item)
      item))

(compress '(1 0 0 1 1 0 1 1 1 1 0 0 1 0 1 1 0))
;; Compress:1 ends here

;; [[file:acl-chapter3.org::*Decompress][Decompress:1]]
(defun decompress (lst)
  (if (null lst)                                    ; (2)
      nil
      (let ((cur-item (car lst))                    ; (3)
            (rest (decompress (cdr lst))))
        (if (consp cur-item)                        ; (4)
            (append (apply #'expand-items cur-item) ; (5)
                    rest)
            (cons cur-item rest)))))                ; (6)

(defun expand-items (n item)                        ; (1)
  (if (zerop n)
      nil
      (cons item (expand-items (- n 1) item))))

(decompress '(10 20 (4 7) 40 (3 5) 60))
(decompress '(1 (2 0) (2 1) 0 (4 1) (2 0) 1 0 (2 1) 0))
;; Decompress:1 ends here

;; [[file:acl-chapter3.org::*Decompress][Decompress:2]]
(append (expand-items (car rest)
                      (second rest))
        rest)
;; Decompress:2 ends here

;; [[file:acl-chapter3.org::*Both combined][Both combined:1]]
(let ((test '(1 0 0 1 1 0 1 1 1 1 0 0 1 0 1 1 0)))
  (equal test
         (decompress (compress test))))
;; Both combined:1 ends here

;; [[file:acl-chapter3.org::*Expression 1][Expression 1:1]]
(a b (e d))
;; Expression 1:1 ends here

;; [[file:acl-chapter3.org::*Expression 2][Expression 2:1]]
(a (b (c (d))))
;; Expression 2:1 ends here

;; [[file:acl-chapter3.org::*Expression 3][Expression 3:1]]
(((a b) c) d)
;; Expression 3:1 ends here

;; [[file:acl-chapter3.org::*Expression 4][Expression 4:1]]
(a (b . c) . d)
;; Expression 4:1 ends here

;; [[file:acl-chapter3.org::*Exercise 2][Exercise 2:1]]
(defun remove-repeated (items lst)
  (if (null items)
      lst
      (let ((cleaned (remove (car items) lst)))
        (remove-repeated (cdr items) cleaned))))

;; (6 5 4 0 4 5 6)
(remove-repeated '(1 2 3)
                 '(6 5 4 3 2 1 0 1 2 3 4 5 6))

(defun new-union (x y)
  (append x (remove-repeated x y)))

;; (6 5 4 0 4 5 6)
(new-union '(a b c) '(b a d ))
;; Exercise 2:1 ends here

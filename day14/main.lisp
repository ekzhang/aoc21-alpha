(defun read-rules ()
  (read-line)
  (loop for line = (read-line *standard-input* nil) while line
    collect (cons (subseq line 0 2) (char line 6))))

(defun interleave (l1 l2)
  (if l2
    `(,(car l1) ,(car l2) ,@(interleave (cdr l1) (cdr l2)))
    l1))

(defun seq-pairs (seq)
  (loop for i from 0 to (- (length seq) 2)
    collect (subseq seq i (+ i 2))))

(defun polymerize (seq rules)
  (format nil "~{~a~}"
    (interleave
      (coerce seq 'list)
      (mapcar (lambda (pat) (cdr (assoc pat rules :test #'string=))) (seq-pairs seq)))))

(defun apply-n (n f x)
  (if (= n 0)
    x
    (apply-n (1- n) f (funcall f x))))

; Source: https://stackoverflow.com/a/6051358/2514396
(defun combine-counts (alist)
  (loop
     with hash = (make-hash-table :test #'equal)
     for (key . value) in alist
     do (incf (gethash key hash 0) value)
     finally (return
               (loop for key being each hash-key of hash
                  using (hash-value value)
                  collect (cons key value)))))

(defun count-unique (alist)
  (combine-counts (mapcar (lambda (key) (cons key 1)) alist)))

(defun count-pairs (seq)
  (count-unique (seq-pairs seq)))

(defun polymerize-pairs (counts rules)
  ; Note: (mapcan) is like flatMap() in functional programming languages.
  (combine-counts
    (mapcan
      (lambda (x)
        (destructuring-bind (pat . val) x
          (let ((c (cdr (assoc pat rules :test #'string=))))
            (list
              (cons (format nil "~a~a" (char pat 0) c) val)
              (cons (format nil "~a~a" c (char pat 1)) val)))))
      counts)))

(defun pairs->chars (counts seq)
  (combine-counts
    (cons
      (cons (char seq 0) 1) ; count the first character once
      (mapcar
        (lambda (x) (cons (char (car x) 1) (cdr x)))
        counts))))

(defun counts-range (counts)
  (let ((sorted-counts (sort (mapcar 'cdr counts) '<)))
    (- (car (last sorted-counts)) (car sorted-counts))))

(defun main ()
  (let* ((seq (read-line))
         (rules (read-rules)))
    ; Part 1
    (let* ((new-seq (apply-n 10 (lambda (seq) (polymerize seq rules)) seq))
           (counts (count-unique (coerce new-seq 'list))))
      ; (format t "~a~%" new-seq)
      ; (format t "~{~a~%~}" counts)
      (format t "~a~%" (counts-range counts)))
    ; Part 2
    (let* ((pairs (count-pairs seq))
           (new-pairs (apply-n 40 (lambda (x) (polymerize-pairs x rules)) pairs))
           (counts (pairs->chars new-pairs seq)))
      ; (format t "~{~a~%~}" counts)
      (format t "~a~%" (counts-range counts)))))

(main)

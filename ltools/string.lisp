(in-package #:ltools) 

(defun tokenize (str test start)
  (let ((p1 (position-if test str :start start)))
    (if p1
	(let ((p2 (position-if #'(lambda (c)
				   (not (funcall test c)))
			       str :start p1)))
	  (cons (subseq str p1 p2)
		(if p2
		    (tokenize str test p2)
		  nil)))
      nil)))


(defun tokenize-delimiter (str delim)
  (tokenize str #'(lambda (c) (if (eq c delim) nil t)) 0))




(defun constituent (c)
  (and (graphic-char-p c)
       (not (char= c #\ ))))

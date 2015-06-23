;;; functions to parse a answer from yahoo finance

(in-package #:lgrabber)




(defparameter *prefile-url-yf* "http://ichart.finance.yahoo.com/")
(defparameter *info-provider-yf* (list :type "QUOTE"
				       :provider "YAHOOF"
				       :f-build-url 'build-url-quote-yf
				       :f-process-data 'process-data-quote-yf))


;; put this in another file
(defparameter *header-quote* (list 
			    "Data" "Open" "High" "Low" "Close" "Volume"))


(defun build-partial-yf (start end)
  (concatenate 'string
	       "&a=" (write-to-string (- (date-month start) 1))
	       "&b=" (write-to-string (date-day start))
	       "&c=" (write-to-string (date-year start))
	       "&d=" (write-to-string (- (date-month end) 1))
	       "&e=" (write-to-string (date-day end))
	       "&f=" (write-to-string (date-year end))))


(defun build-url-quote-yf (info &key (bov t))
  (let ((ticker (gethash "ticker" info))
	(start (string-to-date (gethash "start" info)))
	(end (string-to-date (gethash "end" info))))

    (concatenate 'string *prefile-url-yf* 
		 "table.csv"
		 "?s=" ticker (when bov ".SA")
		 (build-partial-yf start end)
		 "&g=" "d")))
		

(defun build-url-dividend-yf (info &key (bov t))
  (let ((ticker (gethash "ticker" info)) 
        (start (string-to-date (gethash "start" info)))
        (end (string-to-date (gethash "end" info))))

		      (concatenate 'string *prefile-url-yf*
				   "x"
				   "?s=" ticker (when bov ".SA")  
				   (build-partial-yf start end)
				   "&g=" "v")))


(defun process-data-quote-yf (data request)
  (let ((call-count 0)
	(header *header-quote*))

    (let ((outfile (open (filename-request request) 
			 :direction :output 
			 :if-exists :supersede 
			 :if-does-not-exist :create)))
      (let ((temp-string ""))
	(loop for c across data do
	      (if (CHAR= c #\Newline)
		  (progn
		    (let ((qlist (tokenize-delimiter temp-string #\,)))
		      (if (= call-count 0) 
			  (setq qlist header)
			(setq qlist (butlast qlist)))
		      (write-line (format nil "~{~A~^;~}" qlist) outfile))
		    (incf call-count)
		    (setq temp-string ""))
		(setq temp-string (concatenate 'string temp-string (string c))))))
      (close outfile))
    (max (1- call-count) 0)))

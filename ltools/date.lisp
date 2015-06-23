(in-package #:ltools)

(defstruct date
  (day nil :type integer)
  (month nil :type integer)
  (year nil :type integer)) 

(defstruct (datetime (:include date))
  (hour nil :type integer)
  (minute nil :type integer)
  (second nil :type integer))


;; DD/MM/YYYY from string to date struct
(defun string-to-date (strdate)
  (let ((dlist (tokenize-delimiter strdate #\/)))
    (if (= (length dlist) 3)
       (make-date :day (parse-integer (nth 0 dlist))
		  :month (parse-integer (nth 1 dlist))
		  :year (parse-integer (nth 2 dlist)))
      nil)))


(defun datetime-to-string (dt)
  (format nil "~4,'0d/~2,'0d/~2,'0d ~2,'0d:~2,'0d:~2,'0d"
	  (datetime-year dt)
	  (datetime-month dt)
	  (datetime-day dt)
	  (datetime-hour dt)
	  (datetime-minute dt)
	  (datetime-second dt)))

(defun date-to-string (dt)
  (format nil "~4,'0d/~2,'0d/~2,'0d"
	  (date-year dt)
	  (date-month dt)
	  (date-day dt)))



(defun get-current-datetime ()
  (multiple-value-bind
   (second minute hour date month year)	;; day-of-week dst-p tz)
   (get-decoded-time)
   (make-datetime 
    :day date
    :month month
    :year year
    :second second
    :minute minute
    :hour hour)))


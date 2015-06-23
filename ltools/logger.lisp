;;; quick and dirty log functions

(in-package #:ltools) 


(defparameter *log-name* nil)
(defparameter *log-filename* nil)
(defparameter *log-outfile* nil)
(defparameter *log-stdout* t)

;;opens log file and save parameters
(defun log-init (&key name filename)
  (if *log-outfile* (log-close))
  (setq *log-name* name)
  (setq *log-filename* filename)
  (if filename
      (setq *log-outfile* (open *log-filename* 
				:direction :output 
				:if-exists :append 
				:if-does-not-exist :create))))



;;log message to log-outfile
(defun log-msg (msg)
  (let ((entry (concatenate 'string
			    (datetime-to-string (get-current-datetime)) 
			    (if *log-name* (concatenate 'string " [" *log-name* "]"))
			    " " msg)))

    (if *log-outfile*
	(progn  
	  (write-line entry *log-outfile*)
	  (force-output *log-outfile*)))

    (if *log-stdout*
	(print entry)))

  nil)



;;close logger file
(defun log-close ()
  (if *log-outfile*
      (progn
	(close *log-outfile*)
	(setq *log-outfile* nil))))




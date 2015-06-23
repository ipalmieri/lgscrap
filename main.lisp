(load "load.lisp")

(use-package :ltools)
(use-package :lgrabber)


;;(ltools:log-init :name "lgrabber" :filename "lgrabber.log")






;;(defparameter *req* (list :id "0001" 
;			  :type "QUOTE" 
;			  :provider "YAHOOF"
;			  :info (list :ticker "PETR4"
;				      :start (make-date :day 26 
;							:month 3 
;							:year 2013)
;				      :end (make-date :day 4 
;						      :month 4 
;						      :year 2013))))







(tools::db-cleanup)

(ltools:log-close)

(quit)

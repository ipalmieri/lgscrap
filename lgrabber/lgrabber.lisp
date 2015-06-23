;;; main lgrabber functions

(in-package #:lgrabber)


;; lists used by the interface
(defparameter *info-list* (list *info-provider-yf*))
(defparameter *data-dir* "./data")					     


  



;; Return filename and path to save request
(defun filename-request (req)
  "Return filename to save request data to"
  (concatenate 'string 
	       *data-dir* "/" (concatenate 'string
					   (format nil "~12,'0d" (getf req :id))
					   ".out")))


;; query information about provider of a request
(defun query-info (request)
  "Return provider info to answer a request"
  (loop for entry in *info-list* do 
	(if (and (equal (getf entry :type) (getf request :type))
		 (equal (getf entry :provider) (getf request :provider)))
	  (return-from query-info (copy-list entry))))
  nil)
	  

;; adhoc log function 
(defun log-msg-req(req-code msg)
  "Log message formatted with request id"
  (ltools:log-msg (concatenate 'string "REQ: " (write-to-string req-code) " " msg)))


;; generic func to download data, given an url
(defun download-data (target-url)
  "Generic function to download data given an url"
  (let ((response (multiple-value-list (drakma:http-request target-url))))

    (if (= (second response) 200) 
	(return-from download-data (list (first response) t))
      (ltools:log-msg (concatenate 'string 
			    "download-data(): Error getting response - "
			    (nth 6 response)))))
  (list (string "") nil))


;;build url to be used in download-data
(defun build-url (request)
  "Build url to be used in download-data()"
  (let ((bfunc (getf (query-info request) :f-build-url))
	(binfo (getf request :info)))
    (if (and bfunc binfo)
	(return-from build-url (funcall (symbol-function bfunc) binfo))
      (log-msg-req (getf request :id) "build-url() error")))
  nil)
	


;; format and save data to disk
;; return number of entries saved	
(defun process-data (data request)
  "Format and save downloaded data"
  (let ((bfunc (getf (query-info request) :f-process-data)))
    (if bfunc
	(return-from process-data (funcall (symbol-function bfunc) data request))
      (log-msg-req (getf request :id) "process-data() error")))
  nil)



;; process one given request
(defun process-request (request)
  "Process a request"
  (let ((req-id (getf request :id))
	(rcount 0))

    (log-msg-req req-id (concatenate 'string 
				     "process-request(): "
				     (getf request :sname) " "
				     (getf request :type) " "
				     (getf request :provider)))

    (let ((data (download-data (build-url request))))
      (when (second data)
	(setf rcount (process-data (first data) request))))
	    
    (log-msg-req req-id (concatenate 'string 
				     "Processed "
				     (write-to-string rcount) " "
				     "entries."))))


;; check if request was answered
(defun check-answer (request)
  t)


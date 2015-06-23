;;stack resposible for analysis of current data on database
;;auto update of missing or outdated entries

(in-package #:lgrabber)

(defparameter *update-stop* nil)
(defparameter *req-list* nil)
(defparameter *reqlist-step* 2)
(defparameter *sleep-secs* 5)




;; Main loop - run to update database
(defun lgrabber-loop ()
  "Main loop of lgrabber"

  (restart-requests)
  
  (loop while (not *update-stop*) do
	
	;; clear incomplete requests
	;; STARTED and CREATED should be cleared (freed to no user)
	;; ASNWERED should be uploaded
	;; FAILED should be cleared (freed to no user)
	;;(free-requests)
	(setf *req-list* nil)

	(sleep 5)
	
	;; push requests from db to stack
	(push-requests *reqlist-step*)
	   
	;; process the requests
	(let ((rnum (length *req-list*))) 
	  (if (> rnum 0) 
	      (pop-requests rnum)
	    (sleep *sleep-secs*)))))


;; Push new requests onto the main stack 
(defun push-requests (req-count)
  "Start and push <req-count> requests onto the stack" 
  (let ((reqlist (start-requests req-count)))
    (setf *req-list* (nconc *req-list* reqlist))
    (if (> (length reqlist) 0)
	(log-msg (concatenate 'string
			      "Pushed " (write-to-string (length reqlist))
			      " requests into stack")))))


;; Pop and (try to) answer numreq requests
(defun pop-requests (&optional (numreq 1))
  "Pop numreq requests and try to answer"
  (let ((reqlist *req-list*))
    (map nil #'process-request reqlist)
    (loop for req in reqlist do
	  (if (check-answer req)
	      (progn
		(answer-request req)
		(if (upload-reqdata req)
		    (close-request req)
		  (fail-request req)))
	    (fail-request req)))
    (log-msg (concatenate 'string
			  "Processed " (write-to-string (length reqlist))
			  " requests"))))


;; Closes the request, marking as CLOSED
(defun close-request (request)
  "Closes the request"
  (setf (getf request :status) +req-status4+)
  (update-request request)
  (log-msg-req (getf request :id) "Request closed successfully"))


;; Marks request as FAILED
(defun fail-request (request)
  "Fail the request"
  (setf (getf request :status) +req-status5+)
  (update-request request)
  (log-msg-req (getf request :id) "Request failed"))


;; Marks the request as ANSWERED and start update to DB
(defun answer-request (request)
  "Upload the answer to the DB"
  (setf (getf request :status) +req-status3+)
  (update-request request)
  (log-msg-req (getf request :id) "Request answered"))

    

;; Merges request data to database
(defun upload-reqdata (request)
  "Merges request data to database"
  t)





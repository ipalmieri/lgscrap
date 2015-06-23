;; pop request from database and execute it
;; interface with clsql

(in-package #:lgrabber)

;;(clsql:file-enable-sql-reader-syntax)

(defparameter *db-owner* "ME")
(defparameter *db-table* "requests")
(defparameter *db-name* "beat")
  
(defparameter +req-status1+ "CREATED")
(defparameter +req-status2+ "STARTED")
(defparameter +req-status3+ "ANSWERED")
(defparameter +req-status4+ "CLOSED")
(defparameter +req-status5+ "FAILED")


;; restart all unfinished requests from last session
(defun restart-requests ()
  "Restart all unfinished requests from last session"
  (let ((qset (concatenate 'string
			   "update " *db-table* " "
			   "set owner = null,"
			   "status = \'" +req-status1+ "\' "
			   ";")))
    (ltools:db-query :name *db-name* :query qset)))
    


;; get num requests from db, marking the owner and status
(defun mark-requests (&optional (num 1))
  "Get num requests from db, marking the owner and status"
  (if (> num 0)
      (progn
	(let ((qset (concatenate 'string
				 "update " *db-table* " r "
				 "set owner = \'" *db-owner* "\',"
				 "status = \'" +req-status2+ "\' "
				 "from ( "
				 "select id from " *db-table* " "
				 "where owner is null and "
				 "status =\'" +req-status1+ "\' " 
				 "order by lastchange "
				 "limit " (write-to-string num) " "
				 "for update ) sub "
				 "where r.id = sub.id;")))

 	  (ltools:db-query :name *db-name* :query qset)))))

    
;; return list of requests from database
(defun get-requests (&key owner status (limit 0))
  "Return a list of requests from database"
  (let ((qget (concatenate 'string
			   "select * from " *db-table* " "
			   "where owner=\'" owner "\' and "
			   "status=\'" status "\' "
			   "order by lastchange"
			   (if (> limit 0) (concatenate 'string 
							" limit " 
							(write-to-string limit)))
			   ";")))
    (ltools:db-query :name *db-name* :query qget)))


;; write request list back to database
(defun update-reqlist (req-list)
  "Write a list of requests back to the database."
  (loop for req in req-list do
	(update-request req)))


;; write request back to database
(defun update-request (req)
  "Write a request back to the database. Not all fields are updated."
  (let ((qset (concatenate 'string
			   "update " *db-table* " "
			   "set sname=" "\'" (getf req :sname) "\', "
			   "provider=" "\'" (getf req :provider) "\', "
			   "type=" "\'" (getf req :type) "\', "
			   "status=" "\'" (getf req :status) "\' "
			   "where id=" (write-to-string (getf req :id)) " "
			   "and owner=" "\'" *db-owner* "\'" ";")))

    (ltools:db-query :name *db-name* :query qset)))


;; unpack json info to a hash 
(defun unpack-info (infolist)
  "Unpack json info to a hash for future evaluation"
  (yason:parse infolist))


;; convert requests do plists
(defun convert-requests (req-list)
  "Convert requests from db to plists"
  (let ((ret nil))
    (loop for req in req-list do 
	  (let ((new-req (list 
			  :id (nth 0 req)
			  :sname (nth 1 req)
			  :provider (nth 2 req)
			  :type (nth 3 req)
			  :status (nth 4 req)
			  :info (unpack-info (nth 5 req)) 
			  :owner (nth 6 req))))

	    (setf ret (nconc ret (list new-req)))))
  ret))


;; Reaload all unaswered requests from database
(defun reload-requests (&optional (owner *db-owner*))
  "Reload all unaswered requests from database"
  (let ((reqlist (append (get-requests :owner owner :status +req-status1+)
			 (get-requests :owner owner :status +req-status2+))))
    (convert-requests reqlist)))


;; Reset pending requests of the owner
(defun free-requests (&optional (owner *db-owner*))
  "Free all pending requests of a given owner"
  )
  

;; Remove completed requests
(defun clear-requests ()
  "Clear failed requests of the current owner"
  )
  


;; Pop num requests and mark as being executed
(defun start-requests (&optional (num 1))
  "Get num requests to be answered. Mark new requests if available"
  (mark-requests num)
  (convert-requests (get-requests :owner *db-owner* :status +req-status2+ :limit num)))


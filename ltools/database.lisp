;; interface with mysql

(in-package #:ltools)



(defparameter *dbparam* (make-hash-table :test #'equal))

(setf (gethash "beat" *dbparam*) '("HOSTNAME" "DATABASE" "USER" "PASS"))




(defun db-get-database (name)
  "Returns database from pool"
  (let ((param (gethash name *dbparam*)))
    (if param
	(clsql:connect param :database-type :postgresql :pool t)
      (progn (log-msg (concatenate 'string "Connection not configured: " name)) nil))))


(defun db-release-database (db)
  "Releases database back to the pool"
  (clsql:disconnect :database db))
      

(defun db-cleanup ()
  "Closes all conections and stop"
  clsql:disconnect-pooled)


(defun db-query (&key name query)
  "Return query result, using database from pool"
  (let ((con (db-get-database name)) (ret nil))
    (if con
	(progn
	  (setf ret (db-process-query (clsql:query query :database con)))
	  (db-release-database con))
      (log-msg (concatenate 'string
			    "Error executing query on connection "
			    name ": " query)))
    ret))


(defun db-process-query (result)
  "Function to post-process query results, if needed"
  result)






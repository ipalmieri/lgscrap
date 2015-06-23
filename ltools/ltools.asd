(asdf:defsystem #:ltools
  :depends-on (#:clsql)
  :serial t
  :components ((:file "package")
	       (:file "date")
	       (:file "string")
	       (:file "logger"
			:depends-on ("string"
				     "date"))
		(:file "database"
			:depends-on ("logger"))))
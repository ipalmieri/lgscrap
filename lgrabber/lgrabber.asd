(asdf:defsystem #:lgrabber
  :depends-on (#:drakma #:ltools #:yason)
  :components ((:file "package")
	       (:file "provider-yahoof"
		      :depends-on ("package"))
	       (:file "lgrabber"
		      :depends-on ("package" 
				   "provider-yahoof"))
	       (:file "reqdata"
		      :depends-on ("package"))
	       (:file "lupdater"
	              :depends-on ("package"
				   "reqdata"
				   "lgrabber"))))	


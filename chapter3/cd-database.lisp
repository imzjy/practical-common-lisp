;; Global variables
(defvar *db* nil)



;; Function definition
(defun make-cd (title artist rating ripped)
	(list :title title :artist artist :rating rating :ripped ripped))

(defun add-record (cd) (push cd *db*))

(defun dump-db()
	(dolist (item *db*)
		(format t "~{~a: ~10t~a~%~}~%" item)))

(defun prompt-read (prompt)
	(format *query-io* "~a: " prompt)
	(force-output *query-io*)
	(read-line *query-io*))

(defun prompt-for-cd ()
	"Documentation for prompt-for-cd."
	(make-cd
		(prompt-read "Title")
		(prompt-read "Artist")
		(or (parse-integer (prompt-read "Rating") :junk-allowed t) 0)
		(y-or-n-p "Ripped [y/n]: ")
		))

(defun add-cds ()
	"Documentation for add-cds."
	(loop (add-record (prompt-for-cd))
		(if (not (y-or-n-p "Anohter? [y/n]: "))
			(return))))

;; save and load the cds from file
(defun save-db (filename)
	"save the *db* to a file, so we can load it later"
	(with-open-file (out filename
					:direction :output
				 	:if-exists :supersede)
		(with-standard-io-syntax
			(print *db* out))))

(defun load-db (filename)
	"load the cds from my-cd.db"
	(if (probe-file filename)
		(with-open-file (in filename)
			(with-standard-io-syntax
				(setf *db* (read in))))))

(load-db "my-cd.db")
(add-cds)
(save-db "my-cd.db")

(dump-db)
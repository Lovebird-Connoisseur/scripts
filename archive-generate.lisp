(eval-when (:compile-toplevel :load-toplevel :execute)
           (ql:quickload '(:cl-ppcre) :silent t))

;; TODO make path relative
(defconstant +article-directory+ #p"~/Projects/blog/org/en/")

;; TODO make the function operate on a variable sized list of attributes
(defun get-file-attributes (file)
  "Takes in a file and returns a list with the desired attributes, including its path."
  (let ((attributes '()))
   (with-open-file (stream file)
     (push file attributes)
     (loop for line = (read-line stream nil)
           until (equal line "") ;only reads until the first blank line
           do (cond ((search "TITLE" line) (push line attributes))
                    ((search "DATE" line) (push line attributes))
                    ((search "TAGS" line) (push line attributes))
                    (t nil))))
   attributes))

(defun generate-file-list (path filter)
  "Returns a list of all files in a given directory."
  (let ((file-list (uiop:directory-files path))
        (filter-function #'(lambda (file) (ppcre:scan filter (file-namestring file)))))
    (remove-if-not filter-function file-list)))

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

(defun sort-by* (list criteria)
  "Goes through a list of lists and orders them according to a criteria."
  (sort list #'string<= :key criteria))

(defun find-title (attributes)
  "Returns the filename from a list of attributes."
  (dolist (attribute attributes nil)
    (when (and (stringp attribute) (search "#+TITLE: " attribute))
      (return (ppcre:regex-replace "#\\+TITLE: " attribute "")))))

(defun find-date (attributes)
  "Returns the filename from a list of attributes."
  (dolist (attribute attributes nil)
    (when (and (stringp attribute) (search "#+DATE: " attribute))
      (return (ppcre:regex-replace "[a-z ]*>$" (ppcre:regex-replace ".* <" attribute "") "")))))

(defun find-tags (attributes)
  "Returns the filename from a list of attributes."
  (dolist (attribute attributes nil)
    (when (and (stringp attribute) (search "#+TAGS: " attribute))
      (return (uiop:split-string (ppcre:regex-replace "#\\+TAGS: " attribute ""))))))

(defun find-filename (attributes)
  "Returns the filename from a list of attributes."
  (dolist (attribute attributes nil)
    (when (pathnamep attribute)
      (return (file-namestring attribute)))))

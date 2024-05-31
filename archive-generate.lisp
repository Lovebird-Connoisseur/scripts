(eval-when (:compile-toplevel :load-toplevel :execute)
           (ql:quickload '(:cl-ppcre) :silent t))

;; TODO make path relative
(defconstant +article-directory+ #p"~/Projects/blog/org/en/")

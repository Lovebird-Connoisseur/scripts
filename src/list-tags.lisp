;; TODO: Improve regex expressions
;; TODO: Make this a package/system
;; TODO: Create procedures to..
;; Set tags
;; Delete Tags
;; Filter tags (date intervals, type, value, etc...)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:cl-ppcre) :silent t))

;; ISSUE: Not portable
(defun get-file-attributes (file)
  "Returns a list containing a files PATH, TAGS and NAME."
  (ppcre:register-groups-bind (path tags filename)
      ("(.*/)*(\\[.*\\])? ?(.*)$" file)
    (list path tags filename)))

(defun tagged-p (file)
  "Returns T if the file contains a tag field."
  (if (second (get-file-attributes file))
      t
      nil))

;; ISSUE: What about files with things inside square brackets that are NOT tags (ex: youtube-dl files)
;; NOTE: Tag format [TYPE1=TAG1, TYPE2=TAG2, TAG3]
;; ISSUE: Parse tag subgroups as assocs

;; NOTE: Is there a way to not match '=' but to not capture it?
(defun parse-tags (tags)
  "Given a files tags field, returns an association of (TYPE . VALUE)."
  (mapcar #'(lambda (entry)
              (ppcre:register-groups-bind (type value)
                  ("^(.*=)?(.*)$" entry)
                (cons type value)))
          (get-tags tags)))

;; TODO: Refactor
;; ISSUE: Not recursive
(defun get-tags (tags)
  "Given a files tags field, returns a list of individual tags."
  (let ((tags (subseq tags 1 (- (length tags) 1)))
        (depth 0)
        (ch nil)
        (word "")
        (result '()))
    (loop for i from 0 to (- (length tags) 1)
          do (setf ch (char tags i))
             (cond ((and (equalp ch #\,) (eql depth 0))
                    (push word result)
                    (setf word ""))
                   ((equalp ch #\[)
                    (setf depth (+ depth 1))
                    (setf word (concatenate 'string word (list ch))))
                   ((equalp ch #\])
                    (setf depth (- depth 1))
                    (setf word (concatenate 'string word (list ch))))
                   (t (setf word (concatenate 'string word (list ch))))))
    (reverse result)))

(defun main ()
  (loop for file in (cdr sb-ext:*posix-argv*)
        do (let ((path (first (get-file-attributes file)))
                 (tags (second (get-file-attributes file)))
                 (filename (third (get-file-attributes file))))
             (format t "~&Name: ~a" filename)
             (loop for tag in (get-tags tags)
                   do (format t "~&~a" tag)))))

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
  (if (ppcre:scan "^\\[.*\\] " (get-filename-full file))
      t
      nil))

;; ISSUE: What about files with things inside square brackets that are NOT tags (ex: youtube-dl files)
(defun get-filename (file)
  "Returns the name of a FILE, excluding its tags."
  (subseq (ppcre:scan-to-strings "\\] .*$" file) 2))

;; TODO: Add support for tag types
;; TODO: Add support for tag sets as tag values (i.e. AUTHOR=[AuthorA, AuthorB])
;; TODO: Make types optional?
;; NOTE: Tag format [TYPE1=TAG1, TYPE2=TAG2, TAG3]
(defun get-tags (file)
  "Returns the list of tags assossiated with FILE."
  (let ((tag-list (ppcre:scan-to-strings "^\\[.*\\]" file)))
    (ppcre:split "," (ppcre:regex-replace "\\]$" (ppcre:regex-replace "^\\[" tag-list "") ""))))

(defun get-filename-full (filepath)
  "Returns the filename"
  (ppcre:scan-to-strings "([^/]*$)" filepath))

(defun main ()
  (loop for file in (cdr sb-ext:*posix-argv*)
        do (let ((path (first (get-file-attributes file)))
                 (tags (second (get-file-attributes file)))
                 (filename (third (get-file-attributes file))))
             (format t "~&Name: ~a" filename)
             (loop for tag in (get-tags tags)
                   do (format t "~&~a" tag)))))

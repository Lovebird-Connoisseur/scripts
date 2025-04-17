;; TODO: Determining the file type by the file extension only doesn't seem very bullet proof, perhaps shell out to "file" command or an OS independent equivalent
;; TODO: Implement defaults for a category of filetypes (i.e. image -> jpeg, jpg, etc...) with specific rules allowed to overwrite it
;; TODO: Create function that file-open that does what main does, but made to be called withing CLs REPL

;; NOTE: Is this the best way to do it?
(defmacro cdr-assoc (item alist &key key test test-not)
  `(cdr (assoc ,item ,alist ,@(if key `(:key ,key)) ,@(if test `(:test ,test)) ,@(if test-not `(:test-not ,test-not)))))

(defparameter *default-programs*
  '(("image" . "feh --draw-filename --scale-down")
    ("document" . "")
    ("video" . "mpv --no-input-default-bindings")
    ("music" . "mpv --no-input-default-bindings")
    ("default" . "xdg-open")))

;; NOTE: Would it be better to convert the strings read to CLs pathnames?
(defparameter *launcher*
  ;; Images
  '(("jpeg" . "feh --draw-filename --scale-down")
    ("jpg" . "feh --draw-filename --scale-down")
    ("png" . "feh --draw-filename --scale-down")
    ("gif" . "feh --draw-filename --scale-down")
    ("webp" . "feh --draw-filename --scale-down")
    ;; Documents
    ("html" . "firefox")
    ("txt" . "emacsclient")
    ("org" . "emacsclient")
    ("pdf" . "emacsclient")
    ("epub" . "emacsclient")
    ("djvu" . "emacsclient")
    ("mhtml" . "firefox")
    ;; Video
    ("mkv" . "mpv --no-input-default-bindings")
    ("mp4" . "mpv --no-input-default-bindings")
    ("webm" . "mpv --no-input-default-bindings")
    ;; Music
    ("mp3" . "mpv --no-input-default-bindings")
    ("flac" . "mpv --no-input-default-bindings")
    ("opus" . "mpv --no-input-default-bindings")
    ("m4a" . "mpv --no-input-default-bindings")
    ("m3u" . "mpv --no-input-default-bindings")
    ("m3u8" . "mpv --no-input-default-bindings")))

(defun get-file-type (file)
  (pathname-type file))

;; ISSUE: Won't work well with strings with single quotes
(defun escape-string (string)
  (concatenate 'string "'" string "'"))

(defun main ()
  (loop for file in (cdr sb-ext:*posix-argv*)
        do (uiop:launch-program (concatenate 'string (cdr (assoc (get-file-type file) *launcher* :test #'equal)) " " (escape-string file)))))

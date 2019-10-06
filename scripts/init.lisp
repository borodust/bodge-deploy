(cl:in-package :cl-user)

(require 'asdf)
(require 'uiop)

(defvar *script-path* (directory-namestring *load-truename*))
(defvar *script-args* nil)


(defun keywordify (name)
  (uiop:intern* (uiop:standard-case-symbol-name name) :keyword))


(defun trim (name)
  (string-trim '(#\Tab #\Space) (string name)))


(defun shout (control &rest params)
  (format t "~&~A~&" (apply #'format nil control params))
  (finish-output t))


(defmacro bind-arguments (&rest params)
  (shout "Binding ~A to ~A" params *script-args*)
  (multiple-value-bind (optional keys)
      (loop for (param . rest) on params
            until (string= param '&key)
            collect param into optional-params
            finally (return (values optional-params rest)))
    (multiple-value-bind (args value-map)
        (loop with value-map = (make-hash-table)
              for (arg . rest) on *script-args* by #'cddr
              while (and arg (uiop:string-prefix-p "--" (trim arg)))
              do (setf (gethash (keywordify (subseq (trim arg) 2)) value-map) (first rest))
              finally (return (values (list* arg rest) value-map)))
      `(progn ,@(loop for opt in optional
                      for rest-args = args then (rest rest-args)
                      collect `(defparameter ,opt
                                 ,(first rest-args)))
              ,@(loop for key in keys
                      append (destructuring-bind (&optional name
                                                    default-value
                                                    provided-p)
                                 (uiop:ensure-list key)
                               (multiple-value-bind (value found-p)
                                   (gethash (keywordify name) value-map)
                                 `((defparameter ,name ,(if found-p
                                                            value
                                                            default-value))
                                   ,@(when provided-p
                                       `((defparameter ,provided-p ,found-p)))))))))))


(defun script (name &rest args)
  (let ((*script-args* args))
    (load (merge-pathnames (format nil "~A.lisp" name) *script-path*))))


(defun quit-lisp (code)
  #+sbcl
  (quit :recklessly-p t :unix-status code)
  #+ccl
  (#__exit code))


(defun command-line-script (name)
  (let ((*script-args* (uiop:command-line-arguments)))
    (unwind-protect
         (handler-case
             (load (merge-pathnames (format nil "~A.lisp" name) *script-path*))
           (serious-condition (e)
             (shout "Unexpected error: ~A" e)
             (quit-lisp -1)))
      (quit-lisp 0))))


(defun read-safely (string)
  (with-standard-io-syntax
    (let ((*read-eval* nil))
      (with-input-from-string (in string)
        (read in)))))


(defun enable-features (&rest features)
  (setf *features* (nunion *features* features :test #'string=)))


(defun disable-features (&rest features)
  (setf *features* (nset-difference *features* features :test #'string=)))


(defmacro with-features ((&rest features) &body body)
  (let ((%features (gensym "features")))
    `(let ((,%features (list ,@features)))
       (unwind-protect
            (progn
              (apply #'enable-features ,%features)
              ,@body)
         (apply #'disable-features ,%features)))))


(defun shell (&rest args)
  (flet ((quote-arg (arg)
           (cond
             ((stringp arg) (concatenate 'string "\"" arg "\""))
             ((keywordp arg) (format nil "~(~A~)" arg))
             ((pathnamep arg) (namestring arg))
             (t (string arg)))))
    (let ((command (format nil "~{~A~^ ~}" (mapcar #'quote-arg args))))
      (handler-case
          (uiop:run-program (list "sh" "-c" command)
                            :output *standard-output*
                            :error-output *standard-output*)
        (serious-condition (e)
          (shout "Failed to invoke '~A'" command)
          (error e))))))


(defun string* (control &rest args)
  (apply #'format nil control args))


(defun script-directory ()
  (directory-namestring (or *load-truename* *compile-file-truename*)))


(defun wget (url path)
  (let ((target (namestring
                 (if (uiop:directory-pathname-p path)
                     (merge-pathnames (file-namestring url) path)
                     path))))
    (ensure-directories-exist (directory-namestring target))
    (shell "wget" "-O" target "-q" url)))


(defun unzip (archive target-dir)
  (let ((target-dir (namestring (uiop:ensure-directory-pathname target-dir))))
    (ensure-directories-exist target-dir)
    (shell "cd" target-dir :&& "unzip" "-o" (namestring archive))))

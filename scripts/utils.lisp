(require 'asdf)
(require 'uiop)

(defvar *script-path* (directory-namestring *load-truename*))


(defmacro bind-arguments (&body body)
  `(progn
     ,@(let ((bindings (loop for arg in body
                          collect (cons arg (gensym)))))
         (append
          (loop for (var) in bindings
             collect `(defvar ,var nil))
          `((destructuring-bind (,@(mapcar #'cdr bindings))
                (uiop:command-line-arguments)
              (setf ,@(loop for (var . value) in bindings
                         append (list var value)))))))))


(defun script (name)
  (load (merge-pathnames (format nil "~A.lisp" name) *script-path*)))


(defun exit (&optional (code 0))
  #+ccl
  (ccl:quit code)
  #+sbcl
  (sb-ext:quit :unix-status code))

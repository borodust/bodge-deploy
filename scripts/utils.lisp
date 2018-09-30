(require 'asdf)
(require 'uiop)

(defvar *script-path* (directory-namestring *load-truename*))


(defmacro bind-arguments (&body body)
  (let ((rest (gensym)))
    `(progn
       ,@(let ((bindings (loop for arg in body
                               collect (cons arg (gensym)))))
           (append
            (loop for (var) in bindings
                  collect `(defvar ,var nil))
            `((destructuring-bind (&optional ,@(mapcar #'cdr bindings) &rest ,rest)
                  (uiop:command-line-arguments)
                (declare (ignore ,rest))
                (setf ,@(loop for (var . value) in bindings
                              append (list var value))))))))))


(defun script (name)
  (load (merge-pathnames (format nil "~A.lisp" name) *script-path*)))

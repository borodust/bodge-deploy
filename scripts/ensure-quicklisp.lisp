(bind-arguments
  *quicklisp-file*)


;;;
;;; SCRIPT
;;;
(unless (find-package :quicklisp)
  (if (probe-file "~/quicklisp/setup.lisp")
      (progn
        (shout "Setting up quicklisp")
        (load "~/quicklisp/setup.lisp"))
      (progn
        (shout "Loading quicklisp from ~A" *quicklisp-file*)
        (load *quicklisp-file*)
        (script "install-quicklisp"))))

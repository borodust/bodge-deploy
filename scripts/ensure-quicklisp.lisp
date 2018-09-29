(bind-arguments
  *quicklisp-file*)


;;;
;;; SCRIPT
;;;
(unless (find-package :quicklisp)
  (if (probe-file "~/quicklisp/setup.lisp")
      (load "~/quicklisp/setup.lisp")
      (progn
        (load *quicklisp-file*)
        (script "install-quicklisp"))))

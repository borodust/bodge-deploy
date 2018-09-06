(bind-arguments
  *quicklisp-file*)


;;;
;;; SCRIPT
;;;

(if (probe-file "~/quicklisp/setup.lisp")
    (load "~/quicklisp/setup.lisp")
    (progn
      (load *quicklisp-file*)
      (script "install-quicklisp")))

(script "install-dist")

(load (merge-pathnames "utils.lisp" (directory-namestring *load-truename*)))
(load "~/quicklisp/setup.lisp")

(bind-arguments
  *system-name*
  *package-name*
  *main-class-name*
  *project-directory*
  *build-directory*)

(push (uiop:ensure-directory-pathname *project-directory*) ql:*local-project-directories*)

(ql:quickload `(:trivial-gamekit/distribution ,*system-name*))
(gamekit.distribution:deliver *system-name*
                              (uiop:find-standard-case-symbol *main-class-name* *package-name*)
                              :build-directory *build-directory*
                              :lisp (first (uiop:raw-command-line-arguments)))

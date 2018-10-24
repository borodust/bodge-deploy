(script "ensure-quicklisp")
(script "install-testing-dist")

(bind-arguments
  *system-name*
  *package-name*
  *main-class-name*
  *project-directory*
  *build-directory*
  *use-gl2*)

(push (uiop:ensure-directory-pathname *project-directory*) ql:*local-project-directories*)

(when *use-gl2*
  (pushnew :bodge-gl2 *features*))

(ql:quickload `(:trivial-gamekit/distribution ,*system-name*))
(gamekit.distribution:deliver *system-name*
                              (uiop:find-standard-case-symbol *main-class-name* *package-name*)
                              :build-directory *build-directory*
                              :lisp (first (uiop:raw-command-line-arguments)))

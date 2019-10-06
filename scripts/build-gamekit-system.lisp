(script "ensure-quicklisp")

(bind-arguments system-name
                main-class-package-name
                main-class-name
                project-directory
                build-directory
                &key mode)

(push (uiop:ensure-directory-pathname project-directory) ql:*local-project-directories*)

(when (and (uiop:emptyp mode) (string= (string-downcase mode) "gl2"))
  (shout "Using OpenGL2")
  (pushnew :bodge-gl2 *features*))

(shout "Quickloading ~A" system-name)
(ql:quickload `(,system-name :trivial-gamekit/distribution))
(shout "Building ~A" system-name)
(gamekit.distribution:deliver system-name
                              (uiop:find-standard-case-symbol main-class-name
                                                              main-class-package-name)
                              :build-directory build-directory
                              :lisp (first (uiop:raw-command-line-arguments)))

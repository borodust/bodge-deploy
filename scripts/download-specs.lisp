(bind-arguments name repository-url spec-directory version &key (lib-postfix ""))


(when (uiop:emptyp version)
  (error "Version is not provided"))


(defparameter *extension-map* '(("linux" . "so")
                                ("windows" . "dll")
                                ("osx" . "dylib")))


(defparameter *arch-list* '("x86_64" "i686"))
(defparameter *spec-url-template* "~A/releases/download/~A/~A-~A-~A-~A-spec.zip")
(defparameter *lib-name-template* "lib~A.~A~A")


(defun format-lib-name (extension)
  (format nil *lib-name-template* name extension lib-postfix))


(defun format-spec-url (arch os extension)
  (format nil *spec-url-template*
          repository-url
          version
          (format-lib-name extension)
          arch
          os
          version))


(loop for arch in *arch-list*
      do (loop for (os . extension) in *extension-map*
               for url = (format-spec-url arch os extension)
               do (uiop:with-temporary-file (:pathname name)
                    (shout "Inflating ~A into ~A" url spec-directory)
                    (wget url name)
                    (unzip name spec-directory))))

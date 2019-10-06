(bind-arguments name repository-url target-dir version &key (lib-postfix ""))


(when (uiop:emptyp version)
  (error "Version is not provided"))


(defparameter *extension-map* '(("linux" . "so")
                                ("windows" . "dll")
                                ("osx" . "dylib")))


(defparameter *arch-map* '(("x86_64" . "x86_64/")
                           ("i686" . "x86/")))

(defparameter *url-template* "~A/releases/download/~A/~A-~A-~A-~A")
(defparameter *lib-name-template* "lib~A.~A~A")


(defun format-lib-name (extension)
  (format nil *lib-name-template* name extension lib-postfix))


(defun format-url (arch os extension)
  (format nil *url-template*
          repository-url
          version
          (format-lib-name extension)
          arch
          os
          version))


(loop for (arch . arch-dir) in *arch-map*
      do (loop for (os . extension) in *extension-map*
               for url = (format-url arch os extension)
               for target = (merge-pathnames (format-lib-name extension)
                                             (merge-pathnames arch-dir target-dir))
               do (uiop:with-temporary-file (:pathname name)
                    (shout "Downloading ~A into ~A" url target)
                    (wget url target))))

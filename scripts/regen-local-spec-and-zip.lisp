(script "ensure-quicklisp")
(script "install-testing-dist")

(bind-arguments build-directory system-name target &key (arch "x86_64"))

(push (uiop:ensure-directory-pathname build-directory) ql:*local-project-directories*)

(shout "Loading c2ffi and claw")
(ql:quickload '(:c2ffi-blob :claw))

(defun regen-local-spec (system-name target &optional arch)
  (with-features (:claw-trace-c2ffi
                  :claw-rebuild-spec
                  :claw-local-only
                  :spit-c2ffi-errors)
    (claw.util:with-local-cpu ((or arch "x86_64"))
      (uiop:with-temporary-file (:pathname pathname)
        (let* ((directory (string* "~A.dir/" pathname)))
          (unwind-protect
               (progn
                 (ensure-directories-exist directory)
                 (ensure-directories-exist (directory-namestring target))
                 (claw.spec:with-overriden-spec-path (directory)
                   (ql:quickload system-name :verbose t))
                 (shell "cd" directory
                        :&& "zip" "-r" target "."))
            (uiop:delete-directory-tree (truename directory) :validate t)))))))

(shout "Starting spec regen for ~A with arch ~A into ~A" system-name arch target)
(regen-local-spec system-name target arch)

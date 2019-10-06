(bind-arguments *system-name*)
(script "ensure-quicklisp")

(ql:quickload '(:c2ffi-blob :claw))

(with-features (:claw-trace-c2ffi
                :claw-rebuild-spec
                :claw-local-only
                :spit-c2ffi-errors)
  (ql:quickload *system-name* :verbose t))

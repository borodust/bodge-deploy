(bind-arguments *system-name* *local-only* *target-arch*)
(script "ensure-quicklisp")

(ql:quickload :claw)

(let ((claw::*local-cpu* *target-arch*)
      (claw::*trace-c2ffi* t)
      (claw::*local-only* (read-safely *local-only*))
      (claw::*rebuild-spec* t)
      (claw::*spit-c2ffi-errors* t))
  (ql:quickload *system-name* :verbose t))

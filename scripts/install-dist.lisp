(script "ensure-quicklisp")

(shout "Installing stable dist")
(ql-dist:install-dist "http://bodge.borodust.org/dist/org.borodust.bodge.txt"
                      :prompt nil :replace nil)
(ql:update-all-dists :prompt nil)

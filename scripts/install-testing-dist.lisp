(script "ensure-quicklisp")

(shout "Installing testing dist")
(ql-dist:install-dist "http://bodge.borodust.org/dist/org.borodust.bodge.testing.txt"
                      :prompt nil :replace nil)
(ql:update-all-dists :prompt nil)

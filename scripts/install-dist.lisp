(script "ensure-quicklisp")

(ql-dist:install-dist "http://bodge.borodust.org/dist/org.borodust.bodge.txt"
                      :prompt nil :replace t)
(ql:update-all-dists :prompt nil)

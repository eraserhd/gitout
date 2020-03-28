(import :std/misc/process
        :std/sugar)
(export reachable?)

(def (reachable? from to)
  (try
    (string=? (run-process ["git" "merge-base" to from])
              (run-process ["git" "rev-parse" "--verify" to]))
    (catch _
      #f)))

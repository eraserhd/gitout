(import :std/test
        "git")

(def git-test
  (test-suite "test git"
    (test-case "test reachable?"
      (check (reachable? "f85885b" "072f706") => #t)
      (check (reachable? "072f706" "f85885b") => #f))))

(run-tests! git-test)
(test-report-summary!)

(case (test-result)
  ((OK) (exit 0))
  (else (exit 1)))

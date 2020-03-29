#!/usr/bin/env gxi

(import :std/misc/process
        :std/misc/string
        :std/test)

(def (t command
        remote: remote)
  (run-process ["rm" "-rf" "origin/" "repo/"])
  (run-process ["tar" "-xzf" "fixtures.tar.gz"])
  (match remote
    ([name url] (run-process ["git" "remote" "set-url" name url]
                             directory: "repo")))
  (string-trim-eol (run-process command)))

(def browse-link-tests
  (test-suite "testing git-browse-link"
    (test-case "translates git@github.com origins into github browse links"
      (check (t ["git" "browse-link" "repo/dir/file.txt"]
                remote: ["origin" "git@github.com:foo/bar.git"])
             => "https://github.com/foo/bar/blob/ce1ced46695def162cadf35f7f02df67cd215c60/dir/file.txt"))
    (test-case "translates https://github.com origins into github browse links"
      (check (t ["git" "browse-link" "repo/dir/file.txt"]
                remote: ["origin" "https://github.com/foo/bar.git"])
             => "https://github.com/foo/bar/blob/ce1ced46695def162cadf35f7f02df67cd215c60/dir/file.txt"))
    (test-case "translates git@github.com origins without .git suffix into github browse links"
      (check (t ["git" "browse-link" "repo/dir/file.txt"]
                remote: ["origin" "git@github.com:foo/bar"])
             => "https://github.com/foo/bar/blob/ce1ced46695def162cadf35f7f02df67cd215c60/dir/file.txt"))
    (test-case "translates https://github.com origins without .git suffix into github browse links"
      (check (t ["git" "browse-link" "repo/dir/file.txt"]
                remote: ["origin" "https://github.com/foo/bar"])
             => "https://github.com/foo/bar/blob/ce1ced46695def162cadf35f7f02df67cd215c60/dir/file.txt"))
    (test-case "adds line anchor for a single line when position is on a single line"
      (check (t ["git" "browse-link" "repo/dir/file.txt" "3.4,3.6"]
                remote: ["origin" "https://github.com/foo/bar"])
             => "https://github.com/foo/bar/blob/ce1ced46695def162cadf35f7f02df67cd215c60/dir/file.txt#L3"))
    (test-case "adds line anchor for multiple lines when position spans multiple lines"
      (check (t ["git" "browse-link" "repo/dir/file.txt" "3.4,7.6"]
                remote: ["origin" "https://github.com/foo/bar"])
             => "https://github.com/foo/bar/blob/ce1ced46695def162cadf35f7f02df67cd215c60/dir/file.txt#L3-L7"))))

(run-tests! browse-link-tests)
(test-report-summary!)

(case (test-result)
  ((OK) (exit 0))
  (else (exit 1)))

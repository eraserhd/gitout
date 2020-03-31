#!/usr/bin/env gxi

(import :std/build-script)

(defbuild-script
  '((static-exe: "git-browse-link")
    (static-exe: "github-open-pull-requests" "-ld-options" "-lz -lyaml")
    (static-exe: "github-search" "-ld-options" "-lz -lyaml")))

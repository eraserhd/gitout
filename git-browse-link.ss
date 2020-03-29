(import :std/format
        :std/misc/ports
        :std/misc/process
        :std/misc/string
        :std/pregexp)
(export main)

(def (reachable? from to)
  (string=? (run-process ["git" "merge-base" from to])
            (run-process ["git" "rev-parse" "--verify" from])))

(def (remote-branches remote)
  (run-process ["git" "for-each-ref" "--format=%(refname)"
                (string-append "refs/remotes/" remote)]
               coprocess: read-all-as-lines))

(def (reachable-from-remote? head remote)
  (call/cc (lambda (cont)
             (for-each (lambda (branch)
                         (if (reachable? head branch)
                           (cont #t)))
                       (remote-branches remote))
             #f)))

(def (remotes)
  (run-process ["git" "remote"] coprocess: read-all-as-lines))

(def (best-remote head)
  (call/cc (lambda (cont)
             (for-each (lambda (remote)
                         (if (reachable-from-remote? head remote)
                           (cont remote)))
                       ["upstream" "origin" (remotes) ...])
             #f)))
(def (head)
  (string-trim-eol (run-process ["git" "rev-parse" "HEAD"])))

(def (origin-url)
  (alet* ((head   (head))
          (remote (best-remote head)))
    (string-trim-eol (run-process ["git" "remote" "get-url" remote]))))

(def (make-browse-url-prefix origin-url)
  (def github (match <> ([_ owner repo] (format "https://github.com/~a/~a/blob" owner repo))))
  (cond
    ((pregexp-match "^git@github\\.com:([^/]*)/([^/]*?)(?:\\.git)?$" origin-url)     => github)
    ((pregexp-match "^https://github\\.com/([^/]*)/([^/]*?)(?:\\.git)?$" origin-url) => github)
    (else
     origin-url)))

(def (make-position-anchor position)
  (match (pregexp-match "^(\\d+)\\.\\d+,(\\d+)\\." position)
    ([_ (apply string->number line1) (apply string->number line2)]
     (cond
       ((=  line1 line2) (format "#L~a" line1))
       ((<= line1 line2) (format "#L~a-L~a" line1 line2))
       (else             (format "#L~a-L~a" line2 line1))))
    (#f "")))

(def (full-path-within-repo filename)
  (string-trim-eol (run-process ["git" "ls-files" "--full-name" filename])))

(def (make-git-browse-link filename position)
  (let ((origin (origin-url)))
    (when (not origin)
      (printf "git-browse-link: cannot find a remote with commit ~a~n" (head))
      (exit 3))
    (format "~a/~a/~a~a"
            (make-browse-url-prefix origin)
            (head)
            (full-path-within-repo filename)
            (make-position-anchor position))))

(def (main filename (position ""))
  (let ((working-dir (path-expand (or (path-directory filename) ".")))
        (basename    (path-strip-directory filename)))
    (when (not (file-exists? filename))
      (printf "git-browse-link: ~a: No such file or directory~n" filename)
      (exit 1))
    (when (eq? 'directory (file-type filename))
      (printf "git-browse-link: ~a is a directory~n" filename)
      (exit 1))
    (parameterize ((current-directory working-dir))
      (displayln (make-git-browse-link basename position)))))

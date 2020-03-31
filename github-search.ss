(import :clojerbil/core
        :std/net/request
        :std/net/uri
        :std/sugar
        :gerbil/gambit/hash
        "github")
(export main)

(def (query-url args)
  (string-append "https://api.github.com/search/code?q="
                  (-> args
                    (string-join " ")
                    (string-append " in:file org:2uinc")
                    (uri-encode))))

(def (main . args)
  (let-hash (hub-config)
    (let* ((request (http-get (query-url args)
                              headers: `(("Authorization" . ,(string-append "bearer " .oauth_token)))))
           (data    (request-json request)))
      (when (table-ref data 'incomplete_results)
        (displayln " ** INCOMPLETE RESULTS **"))
      (for-each (lambda (item)
                  (displayln (table-ref item 'html_url)))
                (table-ref data 'items)))))
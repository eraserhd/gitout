(import :clojerbil/core
        :std/net/request
        :std/net/uri
        :std/sugar)
(export main)

(def (query-url args)
  (string-append "https://api.github.com/search/code?q="
                  (-> args
                    (string-join " ")
                    (string-append " in:file org:2uinc")
                    (uri-encode))))

(def (main . args)
  (let ((request (http-get (query-url args))))
    (displayln (request-text request))))

(import :clojerbil/core
        :std/net/request
        :std/sugar
        :std/text/json
        "github")
(export main)

(define (query username)
  (string-append
   "query {
      user(login: \"" username "\") {
        pullRequests(first: 100, states: OPEN) {
          nodes {
            url
            title
          }
        }
      }
    }"))

(define (post-data username)
  (json-object->string (hash (query (query username)))))

(define (main)
  (let-hash (hub-config)
    (let* ((request (http-post
                     "https://api.github.com/graphql"
                     headers: `(("Authorization" . ,(string-append "bearer " .oauth_token)))
                     data: (post-data .user)))
           (nodes (-> request
                      request-json
                      (hash-ref 'data)
                      (hash-ref 'user)
                      (hash-ref 'pullRequests)
                      (hash-ref 'nodes))))
      (for-each (lambda (node)
                  (display (hash-ref node 'url))
                  (display " ")
                  (display (hash-ref node 'title))
                  (newline))
                nodes))))

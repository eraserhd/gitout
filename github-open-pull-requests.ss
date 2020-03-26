(import :std/net/request
        :std/sugar
        :std/text/json
        :gerbil/gambit/hash)
(export main)

(define-syntax ->
  (syntax-rules ()
    ((_ expr)                          expr)
    ((_ expr (head args ...) rest ...) (-> (head expr args ...) rest ...))
    ((_ expr symbol rest ...)          (-> (symbol expr) rest ...))))

(define (user-config)
  (let ((table (make-table)))
    (table-set! table 'username "eraserhd")
    (table-set! table 'token (getenv "GITHUB_TOKEN"))
    table))

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
  (let ((table (make-table)))
    (table-set! table 'query (query username))
    (json-object->string table)))

(define (main)
  (let-hash (user-config)
    (let* ((request (http-post
                     "https://api.github.com/graphql"
                     headers: `(("Authorization" . ,(string-append "bearer " .token)))
                     data: (post-data .username)))
           (nodes (-> request
                      request-json
                      (table-ref 'data)
                      (table-ref 'user)
                      (table-ref 'pullRequests)
                      (table-ref 'nodes))))
      (for-each (lambda (node)
                  (display (table-ref node 'url))
                  (display " ")
                  (display (table-ref node 'title))
                  (newline))
                nodes))))

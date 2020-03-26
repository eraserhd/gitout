(import :std/net/request
        :std/sugar
        :std/text/json
        :std/text/yaml
        :gerbil/gambit/hash)
(export main)

(define-syntax ->
  (syntax-rules ()
    ((_ expr)                          expr)
    ((_ expr (head args ...) rest ...) (-> (head expr args ...) rest ...))
    ((_ expr symbol rest ...)          (-> (symbol expr) rest ...))))

(define (hub-config-filename)
  (string-append (getenv "XDG_CONFIG_HOME" "~/.config") "/hub"))

(define (hub-config)
  (let ((config     (-> (yaml-load (hub-config-filename))
                        car
                        (table-ref "github.com")
                        car))
        (symbolized (make-table)))
    (table-for-each (lambda (key value)
                      (table-set! symbolized (string->symbol key) value))
                    config)
    symbolized))

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
  (let-hash (hub-config)
    (let* ((request (http-post
                     "https://api.github.com/graphql"
                     headers: `(("Authorization" . ,(string-append "bearer " .oauth_token)))
                     data: (post-data .user)))
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

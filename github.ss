(import :clojerbil/core
        :std/text/yaml
        :gerbil/gambit/hash)
(export hub-config)

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


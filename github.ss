(import :clojerbil/core
        :std/text/yaml
        :gerbil/gambit/hash)
(export hub-config)

(def (hub-config-filename)
  (string-append (getenv "XDG_CONFIG_HOME" "~/.config") "/hub"))

(def (hub-config)
  (let ((config     (-> (yaml-load (hub-config-filename))
                        car
                        (hash-ref "github.com")
                        car))
        (symbolized (make-hash-table)))
    (table-for-each (lambda (key value)
                      (hash-put! symbolized (string->symbol key) value))
                    config)
    symbolized))


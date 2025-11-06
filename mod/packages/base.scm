(define-module (mod packages base)
  #:use-module (gnu packages base))

(define-public enIN-glibc-locales
  (make-glibc-utf8-locales
   glibc
   #:locales (list "en_IN")
   #:name "glibc-enIN-utf8-locales"))

(define-module (mod services kde)
  #:use-modules (guix gexp)
  #:export (kdeconnect-service))

(define kdeconnect-service (simple-service 'kdeconnect-user-service
					   user-processes-service-type
					   (list "kdeconnectd")))

(define-module (mod services kde)
  #:use-module (gnu packages kde)
  #:use-module (gnu services shepherd)
  #:use-module (guix gexp)
  #:export (kdeconnect-service))

(define kdeconnect-shepherd-service
  (shepherd-service
   (provision '(kdeconnect-daemon))
   (requirement '(dbus))
   (documentation "KDEConnect daemon")
   (start #~(make-forkexec-constructor
	     (list #$(file-append kdeconnect "/bin/kdeconnectd"))
	     #:log-file "/var/log/kdeconnectd.log"))
   (stop #~(make-kill-destructor))
   (respawn? #t)))

(define kdeconnect-service
  (service shepherd-root-service-type
	   (list kdeconnect-shepherd-service)))

(define-module (mod services acpi)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages base)
  #:use-module (gnu packages linux)
  #:use-module (guix build utils)
  #:use-module (guix gexp)
  #:export (acpid-powerbtn-service-type))

(define acpid-shepherd-service
  (shepherd-service
   (provision '(acpid))
   (documentation "Run acpid as a daemon")
   (start #~(make-forkexec-constructor
	     (list #$(file-append acpid "/sbin/acpid")
		   "-f"
		   "-c" "/etc/acpi/events")))
   (stop #~(make-kill-destructor))
   (respawn? #t)))

(define acpid-service-type
  (service-type
   (name 'acpid)
   (extensions
    (list (service-extension shepherd-root-service-type
			     (const (list acpid-service-service)))))
   (default-value #f)))

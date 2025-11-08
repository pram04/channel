(define-module (mod services acpi)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages base)
  #:use-module (gnu packages linux)
  #:use-module (guix build utils)
  #:use-module (guix gexp)
  #:export (acpid-powerbtn-service-type))

(define powerbtn-event-file
  (plain-file
   "powerbtn-event"
   "event=button/power
action=/etc/acpi/powerbtn.sh \"%e\"\n"))

(define powerbtn-script-file
  (plain-file
   "powerbtn.sh"
   "#!/bin/sh
/sbin/shutdown -h now \"Power button pressed\"\n"))

(define acpid-powerbtn-service-type
  (service-type
   (name 'acpid-powerbtn)
   (extensions
    (list
     (service-extension shepherd-root-service-type
			(const (list shepherd-service
				     (provision '(acpid))
				     (documentation "Run acpid, handle power button")
				     (start #~(make-forkexec-constructor
					       (list #$(file-append acpid "/sbin/acpid")
						     "-f"
						     "-c" "/etc/acpi/events")))
				     (stop #~(make-kill-destructor))
				     (respawn? #t))))
     (service-extension etc-service-type
			(const (list
				`("acpi/events/powerbtn" ,powerbtn-event-file)
				`("acpi/powerbtn.sh" ,powerbtn-script-file))))))
   (default-value #f)))

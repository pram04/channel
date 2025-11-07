(use-modules (guix build utils)
 (gnu services base)
             (gnu services shepherd)
             (gnu packages base)
	     (guix gexp))

(define powerbtn-script
  (file-union
   "powerbtn-script"
   `(("powerbtn.sh"
      ,(plain-file
        "powerbtn.sh"
        "#!/bin/sh
herd power-off
")))))

(define powerbtn-event
  (file-union
   "powerbtn-event"
   `(("events/powerbtn"
      ,(plain-file
        "powerbtn"
        "event=button/power
action=/etc/acpi/powerbtn.sh
")))))

(define acpid-powerbtn-service
  (shepherd-service
   (auto-start? #t)
   (documentation "ACPI power button handler")
   (start #~(make-forkexec-constructor
            (list (string-append #$acpid-bin "/bin/acpid") "-f")))))

(define acpid-service
  (simple-service 'acpid-powerbtn
                  shepherd-root-service-type
                  (list acpid-powerbtn-service)))

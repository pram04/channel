(use-modules (guix build utils)
 (gnu services base)
             (gnu services shepherd)
             (gnu packages base)
	     (guix gexp))

(define powerbtn-script
  (plain-file
   "powerbtn.sh"
   "#!/bin/sh
    herd power-off
   "))

(define acpid-service-type
  (service-type
   (name 'acpid)
   (extensions
    (list
     (service-extension
      shepherd-service-type
      (lambda (service)
        (let ((powerbtn-file (service-file service "powerbtn.sh")))
          (list
           `(directory #t "/etc/acpi/events")
           `(file #t ,(service-file service "powerbtn.sh"))
           `(file #t ,(service-file service "events/powerbtn"))
           `(exec (string-append acpid "/bin/acpid" " -f"))
           )))))))
   (description "ACPI daemon for power button and ACPI event handling."))

(define acpid-service
  (service acpid-service-type
           (files
            (list
             (cons "powerbtn.sh" powerbtn-script)
             (cons "events/powerbtn"
                   (plain-file
                    "powerbtn"
                    "event=button/power\naction=/etc/acpi/powerbtn.sh\n"))))))

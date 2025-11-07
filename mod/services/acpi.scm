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

(define acpi-files
  (append powerbtn-script powerbtn-event)) 

;; Define the acpid Shepherd service using file-union for files/directories
(define acpid-service-type
  (service-type
   (name 'acpid)
   (extensions
    (list
     (service-extension shepherd-service-type
       (lambda (service)
         (list
          ;; Deploy all files from acpi-files as /etc/acpi and subdirectories
          `(directory #t "/etc/acpi" ,acpi-files)
          ;; Run acpid daemon in foreground with Shepherd supervision
          `(exec (string-append (assoc-ref %outputs "out") "/bin/acpid -f")))))))
   (description "ACPI daemon for power button handling.")))

(define acpid-service
  (service acpid-service-type))

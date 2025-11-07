(use-modules (guix build utils)
 (gnu services base)
             (gnu services shepherd)
             (gnu packages base)
	     (guix gexp))

;; (define powerbtn-script
;;   (file-union
;;    "powerbtn-script"
;;    `(("powerbtn.sh"
;;       ,(plain-file
;;         "powerbtn.sh"
;;         "#!/bin/sh
;; herd power-off
;; ")))))

;; (define powerbtn-event
;;   (file-union
;;    "powerbtn-event"
;;    `(("events/powerbtn"
;;       ,(plain-file
;;         "powerbtn"
;;         "event=button/power
;; action=/etc/acpi/powerbtn.sh
;; ")))))


(define powerbtn-event
  (plain-file "powerbtn"
              "event=button/power
action=/etc/acpi/powerbtn.sh"))

;; Define the power button handler script
(define powerbtn-script
  (plain-file "powerbtn.sh"
              "#!/bin/sh
herd power-off
"))

;; Combine files into a list for deployment
(define acpi-files
  (list (cons "events/powerbtn" powerbtn-event)
        (cons "powerbtn.sh" powerbtn-script)))

;; Define the Shepherd service for running acpid
(define acpid-service
  (service
   (service-type
    (name 'acpid-powerbtn)
    (extensions
     (list
      ;; Deploy files under /etc/acpi
      (service-extension shepherd-root-service-type
        (lambda (service)
          (list `(directory #t "/etc/acpi" ,acpi-files)
                ;; Run acpid in foreground for Shepherd supervision
                `(exec (string-append (assoc-ref %outputs "out") "/bin/acpid -f"))))))
     (description "ACPI daemon with power button shutdown handling.")))))
  

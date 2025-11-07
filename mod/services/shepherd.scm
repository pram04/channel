(define-module (mod services shepherd)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guix gexp)
  #:use-module (ice-9 match)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-1)
  #:export (shepherd-wheel-shutdown-service))

(define (user-in-wheel-group? peer)
  ;; Extract the UID, then look up groups for membership in "wheel".
  (let* ((uid (car peer))
         (getgid-output 
          (call-with-input-pipe
           (string-append "id -Gn " (number->string uid))
           (lambda (port)
             (string-trim-both (read-line port))))))
    (member "wheel" (string-split getgid-output #\space))))

(define shutdown-action
  (shepherd-action
   (name 'shutdown)
   (documentation "Shutdown the system if user is in the wheel group.")
   (procedure
    #~(lambda (running . args)
        (let* ((peer (car (shepherd-call 'getpeercred))))
          (if (user-in-wheel-group? peer)
              (begin
                ;; Initiate shutdown
                (system* "shutdown" "-h" "now")
                #t)
              (begin
                (format #t "Permission denied: not in 'wheel' group.~%")
                #f)))))))

(define shepherd-wheel-shutdown-service
  (simple-service 'wheel-shutdown shepherd-root-service-type (list (shepherd-service
								    (provision '(custom-shutdown))
								    (documentation "Shutdown for wheel members")
								    (requirement '())
								    (actions (list shutdown-action))))))

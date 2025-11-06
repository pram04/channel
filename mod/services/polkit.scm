(define-module (mod services polkit)
  #:use-module (gnu services)
  #:use-module (gnu services desktop)
  #:use-module (guix gexp)
  #:export (polkit-shutdown-service))

(define polkit-shutdown
  (file-union
   "polkit-shutdown"
   `(("share/polkit-1/rules.d/10-shutdown.rules"
      ,(plain-file
	"10-shutdown.rules"
	"
polkit.addRule(function(action, subject) {
    if ((action.id == \"org.freedesktop.login1.power-off\" ||
         action.id == \"org.freedesktop.login1.reboot\") &&
        subject.isInGroup(\"wheel\")) {
        return polkit.Result.YES;
    }
});
")))))

(define polkit-shutdown-service
  (simple-service 'polkit-shutdown polkit-service-type (list polkit-shutdown)))

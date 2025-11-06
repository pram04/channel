(define-module (mod services linux)
  #:use-module (gnu packages linux)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:export (linux/cxi3i716gkm))

(define-public linux/cxi3i716gkm
  (package (inherit (customize-linux
		     #:linux linux-lts
		     #:defconfig (local-file "defconfig")))
	   (name "linux-cxi3i716gkm")))

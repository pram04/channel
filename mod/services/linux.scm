(define-module (mod services linux)
  #:use-module (guix gexp)
  #:export (linux/cxi3i716gkm))

(define-public linux/cxi3i716gkm
  (package (inherit (customize-linux
		     #:linux linux-lts
		     #:defconfig (local-file "defconfig")))
	   (name "linux-cxi3i716gkm")))

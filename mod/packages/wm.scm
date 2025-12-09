(define-module (mod packages wm)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg))

(define-public dwl-mod
  (package
   (inherit dwl)
    (name "dwl-mod")
    (arguments
     (list #:tests? #f ;no tests
	   #:make-flags
	   #~(list (string-append "CC=" #$(cc-for-target))
		   (string-append "PREFIX=" #$output))
      #:phases
      #~(modify-phases %standard-phases
	  (delete 'configure)
	  (add-before 'build 'changes
	    (lambda _
	      (let ((config-mk "config.mk")
		    (config-def-h "config.def.h"))
		(invoke "sed" "-i" "s/^#XWAYLAND/XWAYLAND/" config-mk)
		(invoke "sed" "-i" "s/^#XLIBS/XLIBS/" config-mk)
		(invoke "sed" "-i" "s/^#define MODKEY WLR_MODIFIER_ALT/#define MODKEY WLR_MODIFIER_LOGO/" config-def-h)
		(format #t "Modified config.mk and config.def.h:~%\n")
		(system* "tail" "-10" config-mk)
		(system* "grep" "#define MODKEY" config-def-h))
	      #t)))))
    (native-inputs (list pkg-config wayland-protocols))
    (inputs (list libinput libxcb wayland wlroots-0.18 libxkbcommon xcb-util-wm xorg-server-xwayland))
    (description
     "The following modifications were made to the dwl.
1) The MODKEY has been changed from WLR_MODIFIER_ALT to WLR_MODIFIER_LOGO
2) Enabled XWayland")))

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
    (name "dwl-mod")
    (version "0.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
	      (url "https://codeberg.org/dwl/dwl")
	      (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
	(base32
	 "0404awsx8v9fyk7p2bg3p937sc56ixf8ay465xgvjcnv78hh4apd"))))
    (build-system gnu-build-system)
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
    (home-page "https://codeberg.org/dwl/dwl")
    (synopsis "Dynamic window manager for Wayland modified")
    (description
     "The following modifications were made to the dwl. The MODKEY has been changed from WLR_MODIFIER_ALT
to WLR_MODIFIER_LOGO coz the former was needed for emacs. Enabled XWayland coz, many still breaks
with wayland. The original description follows.
@command{dwl} is a compact, hackable compositor for Wayland based on
wlroots.  It is intended to fill the same space in the Wayland world that dwm
does in X11, primarily in terms of philosophy, and secondarily in terms of
functionality.  Like dwm, dwl is easy to understand and hack on, due to a
limited size and a few external dependencies.  It is configurable via
@file{config.h}.")
    ;; LICENSE       LICENSE.dwm   LICENSE.tinywl
    (license (list license:gpl3+ license:expat license:cc0))))

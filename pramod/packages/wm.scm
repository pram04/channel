(define-module (packages wm)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages wm))
  
(define-public dwl
  (package
    (name "dwl")
    (version "0.7esc")
    (source (local-file "/home/mod/src/dwl" #:recursive? #t))
    (build-system gnu-build-system)
    (arguments
     (list #:tests? #f                  ; no tests
           #:make-flags
           #~(list
              #$(string-append "CC=" (cc-for-target))
                (string-append "PREFIX=" #$output))
           #:phases
           #~(modify-phases %standard-phases
               (delete 'configure))))   ; no configure
    (native-inputs
     (list pkg-config))
    (inputs
     (list wlroots))
    (home-page "https://codeberg.org/dwl/dwl")
    (synopsis "Dynamic window manager for Wayland")
    (description
     "@command{dwl} is a compact, hackable compositor for Wayland based on
wlroots.  It is intended to fill the same space in the Wayland world that dwm
does in X11, primarily in terms of philosophy, and secondarily in terms of
functionality.  Like dwm, dwl is easy to understand and hack on, due to a
limited size and a few external dependencies.  It is configurable via
@file{config.h}.")
    ;;             LICENSE       LICENSE.dwm   LICENSE.tinywl
    (license (list license:gpl3+ license:expat license:cc0))))

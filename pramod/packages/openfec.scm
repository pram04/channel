(use-modules (guix packages)
	     (gnu packages glib)
	     (gnu packages wget)
	     (gnu packages networking)
	     (gnu packages curl)
	     (gnu packages tls)
	     (gnu packages pkg-config)
	     (gnu packages cmake)
	     (gnu packages perl)
	     (gnu packages python)
	     (guix git-download)
	     (guix build-system cmake)
	     (guix gexp)
	     ((guix licenses) #:prefix license:))

(define-public openfec
  (package
   (name "openfec")
   (version "v1.4.2.12")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/roc-streaming/openfec/")
                  (commit version)))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "18f9ja3riyxlwz09p0mqc2j64wn69lbwrqg5kchd27crl0pggqr8"))))
   (build-system cmake-build-system)
   (arguments
    (list
     #:configure-flags
     #~(list "-DDEBUG:STRING=OFF")))
   (native-inputs
    (list `(,glib "bin")
          pkg-config
	  perl
	  python
	  wget
	  curl))
   (inputs (list ))
   (home-page "https://openfec.inrialpes.fr/")
   (synopsis "Unofficial openFEC fork with various bug fixes")
   (description
    "FEC - Forward Erasure Correction. AL-FEC - Appliation Level FEC. UL-FEC - Upper Layers FEC. OpenFEC - IPR-free, open AL-FEC codes")
   (license license:cecill))
  )

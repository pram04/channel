(define-module (packages web-browsers)
  #:use-module (guix build-system qt)
  #:use-module (guix download)
  #;use-module (guix gexp)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages kde-systemtools)
  #:use-module (gnu packages qt))

(define-public privacybrowser
  (package
   (name "privacybrowser")
   (version "0.8")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
	   "https://download.stoutner.com/privacybrowser-pc/privacybrowser-"
	   version ".tar.xz"))
     (sha256
      (base32
       "1c9lkp51lficq7n04zzs1c6k97nhxh3zl3384qfqkw6xyws1ah58"))))
   (build-system qt-build-system)
   (arguments (list #:tests? #f #:configure-flags #~(list "-DBUILD_TESTING=OFF")))
   (native-inputs (list extra-cmake-modules))
   (inputs (list breeze-icons
		 kcrash
		 kdbusaddons
		 khelpcenter
		 ki18n
		 kio
		 knotifications
		 kxmlgui
		 qtsvg
		 qtwebengine))
   (home-page "https://www.stoutner.com/privacy-browser-pc/")
   (synopsis "Web browser that respects your privacy")
   (description
    "Privacy Browser is a web browser based on Qt WebEngine with a focus on privacy and security. Features like JavaScript and cookies are disabled by default but are easy to automatically enable on-the-fly or by domain.")
   (license gpl3+)))

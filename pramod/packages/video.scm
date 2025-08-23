(define-module (packages video)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages javascript)
  #:use-module (gnu packages video)
  #:use-module (rnrs lists))

(define-public mpv-js
  (package
   (inherit mpv)
   (version (string-append (package-version mpv) "-js"))
   (arguments
    (substitute-keyword-arguments (package-arguments mpv)
				  ((#:configure-flags flags)
				   #~(append
				      (filter (lambda (f) (or (string=? f "-Dcdda=enabled")
							      (string=? f "-Ddvdnav=enabled")))
					      #$flags)
				      '("-Dcdda=disabled" "-Ddvdnav=disabled" "-Dalsa=enabled" "-Degl-wayland=enabled" "-Djavascript=enabled" "-Dpipewire=enabled" "-Dstrip=true" "-Dvaapi=enabled" "-Dvaapi-wayland=enabled" "-Dvulkan=enabled" "-Dwayland=enabled" "-Dcplugins=disabled" "-Ddrm=disabled" "-Ddvbin=disabled" "-Degl-drm=disabled" "-Diconv=disabled" "-Djack=disabled" "-Dlibarchive=disabled" "-Dlibbluray=disabled" "-Dmanpage-build=disabled" "-Dpulse=disabled" "-Dsdl2=disabled" "-Dsdl2-gamepad=disabled" "-Dsndio=disabled" "-Dx11=disabled" "-Dxv=disabled" "-Dzimg=disabled" "-Dzlib=disabled")))))
   (native-inputs
    (modify-inputs (package-native-inputs mpv)
		   (delete "perl" "python-docutils")))
   (inputs
    (modify-inputs (package-inputs mpv)
		   (prepend mujs)))))
;;		   (append `(("mujs" ,mujs)))))))
mpv-js

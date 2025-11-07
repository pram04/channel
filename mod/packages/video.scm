(define-module (mod packages video)
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
        #~(append (filter (lambda (f)
                            (or (string=? f "-Dcdda=enabled")
                                (string=? f "-Ddvdnav=enabled")))
                          #$flags)
                  ;; "-Dbuildtype=release"
                  '("-Dalsa=enabled" "-Dcaca=disabled"
                    "-Dcdda=disabled"
                    "-Dcplugins=disabled"
                    "-Ddrm=disabled"
                    "-Ddvbin=disabled"
                    "-Ddvdnav=disabled"
                    "-Degl-drm=disabled"
                    "-Degl-wayland=enabled"
                    "-Diconv=disabled"
                    "-Djack=disabled"
                    "-Djavascript=enabled"
                    "-Dlibarchive=disabled"
                    "-Dlibbluray=disabled"
                    "-Dmanpage-build=disabled"
                    "-Dpipewire=enabled"
                    "-Dpulse=disabled"
                    "-Dsdl2=disabled"
                    "-Dsdl2-gamepad=disabled"
                    "-Dsixel=disabled"
                    "-Dsndio=disabled"
                    "-Dstrip=true"
                    "-Dvaapi=enabled"
                    "-Dvaapi-wayland=enabled"
                    "-Dvulkan=enabled"
                    "-Dwayland=enabled"
                    "-Dx11=disabled"
                    "-Dxv=disabled"
                    "-Dzimg=disabled"
                    "-Dzlib=disabled")))))
    (native-inputs (modify-inputs (package-native-inputs mpv)
                     (delete "perl" "python-docutils")))
    (inputs (modify-inputs (package-inputs mpv)
              (prepend mujs)))))
mpv-js

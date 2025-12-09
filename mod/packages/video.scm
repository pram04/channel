(define-module (mod packages video)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages javascript)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages video)
  #:use-module (gnu packages xdisorg)
  #:use-module (rnrs lists))

(define-public mpv-mod
  (package
   (inherit mpv)
   (name "mpv-mod")
   (arguments
    (substitute-keyword-arguments (package-arguments mpv)
				  ((#:configure-flags flags)
				   #~(append '("-Doptimization=3"
					       "-Ddebug=false"
					       "-Db_lto=true"
					       
					       "-Ddmabuf-wayland=enabled"
					       "-Ddrm=enabled"
					       "-Degl=enabled"
					       "-Degl-wayland=enabled"
					       "-Djavascript=enabled"
					       "-Dlua=lua-5.2"					       
					       "-Dpipewire=enabled"
					       "-Dstrip=true"
					       "-Dvaapi=enabled"
					       "-Dvaapi-wayland=enabled"
					       "-Dvulkan=enabled"
					       "-Dwayland=enabled"
					       
					       "-Dalsa=disabled"
					       "-Dcaca=disabled"
					       "-Dcdda=disabled"
					       "-Ddvbin=disabled"
					       "-Ddvdnav=disabled"
					       "-Degl-drm=disabled"
					       "-Dgbm=disabled"
					       "-Diconv=disabled"
					       "-Djack=disabled"
					       "-Dlibarchive=disabled"
					       "-Dlibbluray=disabled"
					       "-Dmanpage-build=disabled"
					       "-Dpulse=disabled"
					       "-Dsdl2=disabled"
					       "-Dsdl2-gamepad=disabled"
					       "-Dsixel=disabled"
					       "-Dsndio=disabled"
					       "-Dvdpau=disabled"					       
					       "-Dvdpau-gl-x11=disabled"
					       "-Dx11=disabled"
					       "-Dxv=disabled")))))
   (native-inputs (modify-inputs (package-native-inputs mpv)
				 (delete "perl" "python-docutils")))
   (inputs (modify-inputs (package-inputs mpv)
			  (prepend lua-5.2 mujs)))
   (description "mpv with some modification. js enabled")))

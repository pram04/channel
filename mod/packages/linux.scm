(define-module (mod packages linux)
  #:use-module (guix packages)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages avahi)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages libunwind)
  #:use-module (gnu packages libusb)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages popt)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages ragel)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages video)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xiph)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system scons)
  #:use-module (guix build utils)
  #:use-module (guix gexp)
  #:use-module ((guix licenses)
                #:prefix license:))

;; (define clearlinux-patches
;;   (origin
;;    (method git-fetch)
;;    (uri (git-reference
;; 	 (url "https://git.staropensource.de/StarOpenSource/Linux-Tachyon.git"
;; (define-public 

(define-public openfec
  (package
    (name "openfec")
    (version "v1.4.2.12")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/roc-streaming/openfec/")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "18f9ja3riyxlwz09p0mqc2j64wn69lbwrqg5kchd27crl0pggqr8"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "-DDEBUG:STRING=OFF")
      #:tests? #f))
    (native-inputs (list curl
                         `(,glib "bin")
                         pkg-config
                         perl
                         python
                         wget))
    (inputs (list))
    (home-page "https://openfec.inrialpes.fr/")
    (synopsis "Unofficial openFEC fork with various bug fixes")
    (description
     "FEC - Forward Erasure Correction. AL-FEC - Appliation Level FEC. UL-FEC - Upper Layers FEC. OpenFEC - IPR-free, open AL-FEC codes")
    (license license:cecill)))

(define-public pipewire-mod
  (package
   (inherit pipewire)
   (name "pipewire-mod")
   (arguments
    (list
     #:configure-flags
     #~(list (string-append "-Dudevrulesdir="
			    #$output "/lib/udev/rules.d")
	     "-Dman=disabled"
             "-Dlibpulse=disabled"
             "-Dpipewire-jack=disabled"
             "-Djack=disabled"
             "-Dgstreamer=disabled"
             "-Dexamples=disabled"
             "-Dtests=disabled"
             "-Dflatpak=disabled"
             "-Drlimits-install=false"
             "-Dsession-managers=[]"
             "-Dsysconfdir=/etc"
             "-Dsystemd=disabled"
             "-Ddocs=disabled"
             "-Droc=enabled")))
   (inputs (modify-inputs (package-inputs pipewire)
			  (prepend libuv libva openfec roc-toolkit speexdsp)))
   (description
    "Following changes were done to pipewire
1) disabled pulse, jack, gstreamer, examples, tests, flatpak, docs
2) enabled roc")))

(define-public roc-toolkit
  (package
    (name "roc-toolkit")
    (version "v0.4.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/roc-streaming/roc-toolkit.git")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1w74a6dfpjfizc502c2j58dhsrjyira0pbcas7hd9p9lmw7any77"))))
    (build-system scons-build-system)
    (arguments
     (list
      #:scons-flags
      #~(list "-Q"
              (string-append "--prefix="
                             (assoc-ref %outputs "out")))
      #:tests? #f))
    (native-inputs (list cmake
                         curl
                         `(,glib "bin")
                         ;; nss-certs
                         pkg-config
                         wget))
    (inputs (list gengetopt
                  intltool
                  libtool
                  libsndfile
                  libunwind
                  libuv
                  openfec
                  openssl
                  pulseaudio
                  python
                  ragel
                  sox
                  speexdsp))
    (home-page "https://roc-streaming.org/")
    (synopsis
     "Roc Toolkit implements real-time audio streaming over the network")
    (description
     "Basically, it is a network transport, highly specialized for the real-time streaming. You write the steam to the one end and read it from another end, and Roc handles all the complexities of delivering data in time and with no loss. Encoding, decoding, maintaining latency, adjusting clocks, restoring losses - all this happens transparently under the hood.
The project is conceived as a swiss army knife for real-time streaming. It is designed to support a variety of network protocols, encodings, FEC schemes, and related features. Users can build custom configurations dedicated for specific use cases, while balancing quality, robustness, bandwidth, and compatibility.")
    (license license:mpl2.0)))

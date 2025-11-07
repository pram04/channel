(define-module (mod packages machine-learning)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages machine-learning)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages vulkan)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages))

(define-public oneapi-dpcpp
  (package
    (name "oneapi-dpcpp")
    (version "2025.2.1.7")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/04c5fd98-57e6-4a4b-be4d-e84de3aea45a/intel-dpcpp-cpp-compiler-"
             version "_offline.sh"))
       (sha256
        (base32 "0xh3lp2h1pd9wzngrp5b3gcnrjr6klcji66ip6vbm2b22zigk3h2"))))
    ;; (file-name (string-append "oneapi-dpcpp-installer-" version "_offline.sh"))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils)
                                (ice-9 rdelim))
                   (let* ((glibc (assoc-ref %build-inputs "glibc"))
                          (gcc (assoc-ref %build-inputs "gcc"))
                          (ncurses (assoc-ref %build-inputs "ncurses"))
                          (patchelf (assoc-ref %build-inputs "patchelf"))
                          ;; (libstdc++ (string-append (assoc-ref %build-inputs "gcc") "/lib/libstdc++.so.6"))
                          ;; (linker (string-append glibc "/lib/ld-linux-x86-64.so.2"))
                          ;; (rpath (string-join (list (string-append gcc "/lib")
                          ;; (string-append ncurses "/lib")) ":"))
                          (source-file (assoc-ref %build-inputs "source"))
                          (install-dir (string-append %output
                                                      "/opt/intel/oneapi")))
                     (setenv "PATH"
                             (string-join (list (string-append patchelf "/bin"))
                                          ":"))
                     (setenv "TERM" "dumb")
                     (copy-file source-file s-copy-file)
                     (chmod s-copy-file #o755)
                     (invoke s-copy-file "-a" "-s" "--install-dir"
                             "temp-install")
                     (mkdir-p (dirname install-dir))
                     (rename-file "temp-install" install-dir)
                     (for-each (lambda (file)
                                 (when (elf? file)
                                   (format #t "Patching ELF file: ~a\n" file)
                                   (patchelf file
                                             #:set-interpreter linker)
                                   (patchelf file
                                             #:set-rpath rpath)))
                               (find-files install-dir))) #t)))
    (inputs (list gcc-toolchain glibc ncurses))
    (propagated-inputs (list patchelf))
    (home-page
     "https://www.intel.com/content/www/us/en/developer/tools/oneapi/doc-compiler.html")
    (synopsis "Intel oneAPI DPC++/C++ Compiler")
    (description
     "The Intel oneAPI DPC++/C++ Compiler is a standards-based C++ compiler that supports C++20 and SYCL. It provides features for CPU and accelerator programming. This package contains the pre-compiled binaries provided by Intel")
    (license #f)))

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
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

(define-public oneapi-dpcpp
  (package
   (name "oneapi-dpcpp")
   (version "2025.2.1.7")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/04c5fd98-57e6-4a4b-be4d-e84de3aea45a/intel-dpcpp-cpp-compiler-" version "_offline.sh"))
     (sha256 (base32 "0xh3lp2h1pd9wzngrp5b3gcnrjr6klcji66ip6vbm2b22zigk3h2"))))
;;   (file-name (string-append "oneapi-dpcpp-installer-" version "_offline.sh"))
   (build-system trivial-build-system)
   (arguments
    `(#:modules ((guix build utils))
      #:builder
      (begin
	(use-modules (guix build utils)
		     (ice-9 rdelim))
	  (let* ((glibc (assoc-ref %build-inputs "glibc"))
		 (gcc (assoc-ref %build-inputs "gcc"))
		 (ncurses (assoc-ref %build-inputs "ncurses"))
		 (patchelf (assoc-ref %build-inputs "patchelf"))
;;		 (libstdc++ (string-append (assoc-ref %build-inputs "gcc") "/lib/libstdc++.so.6"))
;;		 (linker (string-append glibc "/lib/ld-linux-x86-64.so.2"))
;;		 (rpath (string-join (list (string-append gcc "/lib")
;;					   (string-append ncurses "/lib")) ":"))
		 (source-file (assoc-ref %build-inputs "source"))
		 (install-dir (string-append %output "/opt/intel/oneapi")))
	    (setenv "PATH" (string-join (list (string-append patchelf "/bin")) ":"))
	    (setenv "TERM" "dumb")
	    (copy-file source-file s-copy-file)
	  (chmod s-copy-file #o755)
	  (invoke s-copy-file "-a" "-s" "--install-dir" "temp-install")
	  (mkdir-p (dirname install-dir))
	  (rename-file "temp-install" install-dir)
	    (for-each
	     (lambda (file)
	       (when (elf? file)
		 (format #t "Patching ELF file: ~a\n" file)
		 (patchelf file #:set-interpreter linker)
		 (patchelf file #:set-rpath rpath)))
	     (find-files install-dir)))
	#t)))
   (inputs (list gcc-toolchain glibc ncurses))
   (propagated-inputs (list patchelf))
   (home-page "https://www.intel.com/content/www/us/en/developer/tools/oneapi/doc-compiler.html")
   (synopsis "Intel oneAPI DPC++/C++ Compiler")
   (description "The Intel oneAPI DPC++/C++ Compiler is a standards-based C++ compiler that supports C++20 and SYCL. It provides features for CPU and accelerator programming. This package contains the pre-compiled binaries provided by Intel")
   (license #f)))
   
;; (define-public oneapi-dpcpp
;;   (package
;;    (name "oneapi-dpcpp")
;;    (version "2025.2")
;;    (source
;;     (origin
;;      (method url-fetch)
;;      (uri "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/04c5fd98-57e6-4a4b-be4d-e84de3aea45a/intel-dpcpp-cpp-compiler-2025.2.1.7_offline.sh")
;;      (sha256 (base32 "0xh3lp2h1pd9wzngrp5b3gcnrjr6klcji66ip6vbm2b22zigk3h2"))))
;;    (build-system trivial-build-system)
;;    (arguments
;;     `(#:modules ((guix build utils))
;;       #:builder
;;       (begin
;; 	(use-modules (guix build utils))
;; 	(let* ((out (assoc-ref %outputs "out"))
;; 	       (storefile (assoc-ref %build-inputs "source"))
;; 	       (coreutils (assoc-ref %build-inputs "coreutils"))
;; 	       (bash (assoc-ref %build-inputs "bash"))
;; 	       (gawk (assoc-ref %build-inputs "gawk"))
;; 	       (ncurses (assoc-ref %build-inputs "ncurses"))
;; 	       (tar (assoc-ref %build-inputs "tar"))
;; 	       (gzip (assoc-ref %build-inputs "gzip"))
;; 	       (installer (string-append (getcwd) "/" "installer.sh"))
;; 	       (target-dir (string-append out "/opt/intel/oneapi")))
;; 	  (setenv "PATH" (string-join (list (string-append coreutils "/bin")
;; 					    (string-append gawk "/bin")
;; 					    (string-append ncurses "/bin")
;; 					    (string-append tar "/bin")
;; 					    (string-append gzip "/bin")
;; 					    (string-append bash "/bin")) ":"))
;; 	  (setenv "TERM" "dumb")
;; 	  (format #t "term is ~a~%" (getenv "TERM"))
;; 	  (format #t "path is ~a~%" (getenv "PATH"))
;; 	  (mkdir-p target-dir)
;; 	  (copy-file storefile installer)
;; 	  ;;(patch-shebang "installer.sh")
;; 	  (chmod installer #o755)
;; 	  ;;(invoke (string-append coreutils "/bin/ls") "-lh" installer)
;; 	  ;;(invoke (string-append bash "/bin/sh") installer))))
;; 	  (invoke (string-append bash "/bin/sh") installer "-a" "-s" "--eula" "accept" "--install-dir" target-dir)))))
;;    (native-inputs `(("coreutils" ,coreutils) ("ncurses" ,ncurses) ("tar" ,tar) ("gawk" ,gawk) ("gzip" ,gzip) ("gcc-toolchain" ,gcc-toolchain) ("bash" ,bash)))
;;    (home-page "https://www.intel.com/content/www/us/en/developer/tools/oneapi/doc-compiler.html")
;;    (synopsis "Intel oneAPI DPC++/C++ Compiler")
;;    (description "The Intel oneAPI DPC++/C++ Compiler is a standards-based C++ compiler that supports C++20 and SYCL. It provides features for CPU and accelerator programming.")
;;    (license #f)))
;; oneapi-dpcpp

;; (define-public llama-cpp-sycl
;;   (let ((tag "b6522"))
;;     (package
;;       (name "llama-cpp-sycl")
;;       (version (string-append "0.0.0-" tag))
;;       (source
;;        (origin
;;          (method git-fetch)
;;          (uri (git-reference
;;                (url "https://github.com/ggml-org/llama.cpp")
;;                (commit tag)))
;;          (file-name (git-file-name name tag))
;;          (sha256
;;           (base32 "0qncvff8q3n6h9yljjrbm0m3l4m1zry68iqra8fr5ca1isi24p9b"))))
;;       (build-system cmake-build-system)
;;       (arguments
;;        (list
;;         #:configure-flags
;;         #~(list "-DCMAKE_C_COMPILER=cl"
;; 		"-DCMAKE_CXX_COMPILER=icx"
;; 		"-DGGML_SYCL=ON"
;; 		"-DCMAKE_BUILD_TYPE=Release"
;; 	   #$(string-append "-DGGML_BUILD_NUMBER=" tag)
;;                 "-DBUILD_SHARED_LIBS=ON"
;;                 "-DGGML_VULKAN=OFF"
;;                 "-DLLAMA_CURL=ON"
;;                 "-DGGML_BLAS=ON"
;;                 "-DGGML_BLAS_VENDOR=OpenBLAS"
;;                 (string-append "-DBLAS_INCLUDE_DIRS="
;;                                #$(this-package-input "openblas")
;;                                "/include")
;;                 (string-append "-DBLAS_LIBRARIES="
;;                                #$(this-package-input "openblas")
;;                                "/lib/libopenblas.so")

;;                 "-DGGML_NATIVE=OFF" ;no '-march=native'
;;                 "-DGGML_FMA=OFF"    ;and no '-mfma', etc.
;;                 "-DGGML_AVX2=ON"
;;                 "-DGGML_AVX512=OFF"
;;                 "-DGGML_AVX512_VBMI=OFF"
;;                 "-DGGML_AVX512_VNNI=OFF")

;;         #:modules '((ice-9 textual-ports)
;;                     (guix build utils)
;;                     ((guix build python-build-system) #:prefix python:)
;;                     (guix build cmake-build-system))
;;         #:imported-modules `(,@%cmake-build-system-modules
;;                              (guix build python-build-system))
;;         #:phases
;;         #~(modify-phases %standard-phases
;; 			 (add-before 'configure 'set-intel-oneapi-compiler
;; 				     (lambda _
;; 				       (setenv "PATH" (string-append "/home/mod/intel/oneapi/compiler/2025.2/bin:" (getenv "PATH")))
;; 				       (setenv "CC" "/home/mod/intel/oneapi/compiler/2025.2/bin/icx")
;; 				       (setenv "CXX" "/home/mod/intel/oneapi/compiler/2025.2/bin/icpx")))
;;             (add-after 'unpack 'patch-paths
;;               (lambda* (#:key inputs #:allow-other-keys)
;;                 (substitute* (format #f "~a~a"
;;                                      "ggml/src/ggml-vulkan/vulkan-shaders/"
;;                                      "vulkan-shaders-gen.cpp")
;;                   (("\"/bin/sh\"")
;;                    (string-append "\"" (search-input-file inputs "/bin/sh")
;;                                   "\"")))))
;;             (add-after 'unpack 'fix-tests
;;               (lambda _
;;                 ;; test-thread-safety downloads ML model from network,
;;                 ;; cannot run in Guix build environment
;;                 (substitute* '("tests/CMakeLists.txt")
;;                   (("llama_build_and_test\\(test-thread-safety.cpp.*")
;;                    "")
;;                   ;; error while handling argument "-m": expected value for
;;                   ;; argument
;;                   (("llama_build_and_test\\(test-arg-parser.cpp.*")
;;                    ""))
;;                 ;; test-eval-callback downloads ML model from network, cannot
;;                 ;; run in Guix build environment
;;                 (substitute* '("examples/eval-callback/CMakeLists.txt")
;;                   (("COMMAND llama-eval-callback")
;;                    "COMMAND true llama-eval-callback"))
;;                 ;; Help it find the test files it needs
;;                 (substitute* "tests/test-chat.cpp"
;;                   (("\"\\.\\./\"") "\"../source/\""))))
;;             (add-after 'install 'wrap-python-scripts
;;               (assoc-ref python:%standard-phases 'wrap))
;;             (add-after 'install 'remove-tests
;;               (lambda* (#:key outputs #:allow-other-keys)
;;                 (for-each delete-file (find-files
;;                                        (string-append (assoc-ref outputs "out")
;;                                                       "/bin")
;;                                        "^test-")))))))
;;       (inputs
;;        (list curl glslang python-gguf python-minimal openblas spirv-headers
;;              spirv-tools vulkan-headers vulkan-loader))
;;       (native-inputs
;;        (list bash-minimal pkg-config shaderc))
;;       (propagated-inputs
;;        (list python-numpy python-pytorch python-sentencepiece))
;;       (properties '((tunable? . #true))) ;use AVX512, FMA, etc. when available
;;       (home-page "https://github.com/ggml-org/llama.cpp")
;;       (synopsis "Port of Facebook's LLaMA model in C/C++")
;;       (description "This package provides a port to Facebook's LLaMA collection
;; of foundation language models.  It requires models parameters to be downloaded
;; independently to be able to run a LLaMA model.")
;;       (license license:expat))))

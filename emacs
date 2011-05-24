(require 'org-install)
;; (set-face-attribute 'default nil :font "Inconsolata 14")

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl"  'org-store-link)
(global-set-key "\C-ca"  'org-agenda)
(global-set-key "\C-cb"  'org-iswitchb)
(global-font-lock-mode 1)
(add-hook 'org-mode-hook 'turn-on-font-lock)

(setq x-select-enable-clipboard t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;emacs configurations

(custom-set-variables '(inhibit-startup-screen t))
;; current buffer name in title bar
(setq frame-title-format "%b")
(show-paren-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; clojure-mode
; taken from http://riddell.us/ClojureSwankLeiningenWithEmacsOnLinux.html
(add-to-list 'load-path "~/opt/clojure-mode")
(require 'clojure-mode)
;
;
(add-to-list 'load-path "~/.emacs.d/plugins/")
(require 'paredit)
;
;;; slime
(eval-after-load "slime" 
  '(progn (slime-setup '(slime-repl))
     (defun paredit-mode-enable () (paredit-mode 1))
     (add-hook 'slime-mode-hook 'paredit-mode-enable)
     (add-hook 'slime-repl-mode-hook 'paredit-mode-enable)
     (setq slime-protocol-version 'ignore)))

(add-to-list 'load-path "~/opt/slime")
(require 'slime)
(slime-setup)
;
(define-key global-map (kbd "<f12>") 'slime-selector)
(def-slime-selector-method ?j
   "most recently visited clojure-mode buffer."
     (slime-recently-visited-buffer 'clojure-mode))
;
;;;; This was installed by package-install.el.
;;;; This provides support for the package system and
;;;; interfacing with ELPA, the package archive.
;;;; Move this code earlier if you want to reference
;;;; packages in your .emacs.
;(when
;    (load
;     (expand-file-name "~/.emacs.d/elpa/package.el"))
;  (package-initialize))
;
; Paredit-mode settings
 (autoload 'paredit-mode "paredit"
      "Minor mode for pseudo-structurally editing Lisp code." t)
    (add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
    (add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
    (add-hook 'clojure-mode-hook             (lambda () (paredit-mode +1)))
    (add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))

;; hacking slime
;;; (setq inferior-lisp-program "/usr/bin/sbcl") ; your Lisp system
;;; (setq slime-lisp-implementations
;;;       '((sbcl ("/usr/bin/sbcl" "--core" "/home/trybeingarun/Softwares/sbcl.core-with-swank")
;;; 	       :init (lambda (port-file _)
;;; 		       (format "(swank:start-server %S)\n" port-file)))))
;;; (add-to-list 'load-path "~/Softwares/slime-2010-11-09/") ; your SLIME directory
;;; (require 'slime-autoloads)
;;; (slime-setup)
;
;; key configurations
(global-set-key "\C-cs" 'slime-selector)
;
;;; Rail for emacs;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; copied from http://appsintheopen.com/articles/1-setting-up-emacs-for-rails-development
;
;;; Load CEDET.
;;; This is required by ECB which will be loaded later.
;;; See cedet/common/cedet.info for configuration details.
(load-file "/home/trybeingarun/.emacs.d/plugins/cedet-1.0/common/cedet.el")
;
;;; Enable EDE (Project Management) features
(global-ede-mode 1)
;
;;; * This enables the database and idle reparse engines
(semantic-load-enable-minimum-features)
;
;;; * This enables some tools useful for coding, such as summary mode
;;;   imenu support, and the semantic navigator
(semantic-load-enable-code-helpers)
;
;
;; ECB
(add-to-list 'load-path "/home/trybeingarun/.emacs.d/plugins/ecb-2.40")
(load-file "/home/trybeingarun/.emacs.d/plugins/ecb-2.40/ecb.el")
;
;(custom-set-variables
;;; custom-set-variables was added by Custom.
;;; If you edit it by hand, you could mess it up, so be careful.
;;; Your init file should contain only one such instance.
;;; If there is more than one, they won't work right.
'(ecb-layout-name "left14")
'(ecb-layout-window-sizes (quote (("left14" (0.2564102564102564 . 0.6949152542372882) (0.2564102564102564 . 0.23728813559322035)))))
'(ecb-options-version "2.40")
;
'(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
;
'(ecb-tip-of-the-day nil)
'(ecb-tree-buffer-style (quote ascii-guides))
;
;
;
;; For ruby mode
(add-hook 'ruby-mode-hook
	  (lambda()
	    (add-hook 'local-write-file-hooks
		      '(lambda()
			 (save-excursion
			   (untabify (point-min) (point-max))
			   (delete-trailing-whitespace)
			   )))
	    (set (make-local-variable 'indent-tabs-mode) 'nil)
	    (set (make-local-variable 'tab-width) 2)
	    (imenu-add-to-menubar "IMENU")
	    (define-key ruby-mode-map "\C-m" 'newline-and-indent) ;Not sure if this line is 100% right!
	    (require 'ruby-electric)
	    (ruby-electric-mode t)
	    ))
;
; Install mode-compile to give friendlier compiling support!
(autoload 'mode-compile "mode-compile"
"Command to compile current buffer file based on the major mode" t)
(global-set-key (kbd "C-c c") 'mode-compile)
(autoload 'mode-compile-kill "mode-compile"
"Command to kill a compilation launched by `mode-compile'" t)
(global-set-key (kbd "C-c k") 'mode-compile-kill)

;; Rinari
(add-to-list 'load-path "~/.emacs.d/plugins/rinari/")
(require 'rinari)
(add-hook 'ruby-mode-hook
          (lambda ()
            (defadvice ruby-mode-set-encoding
                       (around ruby-mode-set-encoding-disable activate) nil)))

;; MuMaMo-Mode for rhtml files
(load "~/.emacs.d/plugins/nxhtml/autostart")
(require 'nxhtml-mode)
(add-to-list 'load-path "~/.emacs.d/plugins/nxhtml/util/")
(require 'mumamo-fun)
(setq mumamo-chunk-coloring 5)
(add-to-list 'auto-mode-alist '("\\.rhtml\\'" . eruby-html-mumamo))
(add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . eruby-html-mumamo))
(add-to-list 'auto-mode-alist '("\\.js\\.erb\\'" . eruby-javascript-mumamo))
(add-to-list 'auto-mode-alist '("\\.js\\.rjs\\'" . eruby-javascript-mumamo))

;; Interactively Do Things
(require 'ido)
(ido-mode t)

(add-to-list 'load-path "~/.emacs.d/plugins/magit-1.0.0/")
(require 'magit)
(global-set-key "\C-xg"  'magit-status)
;(require 'egg)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Haskell support
;;(load "~/.emacs.d/plugins/haskell-mode-2.8.0/haskell-site-file")
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'show-paren-mode)
;;(setq haskell-program-name "/usr/bin/ghci")
;;(require 'inf-haskell)


;;; YASNIPPET & zencoding
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet-0.6.1c/")
(require 'yasnippet) ;; not yasnippet-bundle

(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-0.6.1c/snippets/")
(add-to-list 'load-path "~/.emacs.d/plugins/zencoding-mode/")
(require 'zencoding-mode)
(global-set-key "\C-x\C-n" 'zencoding-expand-line)

;; autocomplete.el
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/ac-dict")
(ac-config-default)

;;ibuffer
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)
(setq ibuffer-default-sorting-mode 'major-mode)

;; Window navigation
;; (global-set-key [M-left] 'windmove-left)          ; move to left windnow
;; (global-set-key [M-right] 'windmove-right)        ; move to right window
;; (global-set-key [M-up] 'windmove-up)              ; move to upper window
;; (global-set-key [M-down] 'windmove-down)          ; move to downer window

(add-hook 'javascript-mode 'moz-minor-mode)

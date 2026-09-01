(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)

;; font:
(set-face-attribute 'default nil :family "Iosevka Slab" :height 120)

;; Ligatures:
(use-package ligature
  :ensure t
  :config
  (ligature-set-ligatures
   't
   '("->" "<-" "=>" "==" "===" "!=" "!==" "<=" ">=" "<>" "&&" "||"
     "++" "--" "**" "::" ":::" ":=" "..." ".." "|>" "<|" "<<" ">>"
     "/*" "*/" "//" "///" "/**" "<!--" "-->" "www" "??" "?." "|||"
     "<=>" "<->" "<--" "-->" "<==" "==>" "=/=" "/=" "^=" "#!" "&="))
  (global-ligature-mode t))

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
;; electric-pair mode is what automatically makes closing brackets etc
(electric-pair-mode 1)

;;disable arrow keys
(use-package guru-mode
  :ensure t
  :config
  (guru-global-mode +1))

;;theme
(use-package zenburn-theme
  :config (load-theme 'zenburn t))

;;terminal
(use-package vterm :ensure t)

;;the default compile command suggestion
(setq-default compile-command "cmake --build build")

(setq treesit-language-source-alist
      '((python "https://github.com/tree-sitter/tree-sitter-python")
	(c "https://github.com/tree-sitter/tree-sitter-c")
	(cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.22.0")))

(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)
	(c-mode . c-ts-mode)
	(c++-mode . c++-ts-mode)))

(use-package eglot
  :ensure nil
  :hook ((python-ts-mode c-ts-mode c++-ts-mode) . eglot-ensure))

(use-package orderless
  :init (setq completion-styles '(orderless basic)))

(use-package corfu
  :init
  (setq corfu-auto nil)
  (global-corfu-mode))

;; Emacs creates this
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(corfu guru-mode ligature orderless vertico vterm zenburn-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package vertico
  :init (vertico-mode))

;; my custom commands:

;;doesnt support switching from h -> c
(defun toggle-header ()
  (interactive)
  (let ((ext (file-name-extension (buffer-file-name)))
	(base (file-name-sans-extension (buffer-file-name))))
    (cond ((string= ext "h") (find-file (concat base ".cpp")))
	  ((string= ext "cpp") (find-file (concat base ".h")))
	  ((string= ext "c") (find-file (concat base ".h")))
	   (t (message "no counterpart")))))

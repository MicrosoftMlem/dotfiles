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
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
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
;; ../ bc it will be run from src dir usually
(setq-default compile-command "../run.sh")

(setq treesit-language-source-alist
      '((python "https://github.com/tree-sitter/tree-sitter-python")
	(c "https://github.com/tree-sitter/tree-sitter-c" "v0.21.4")
	(cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.22.0")
	(c-sharp "https://github.com/tree-sitter/tree-sitter-c-sharp" "v0.23.5")))
;;	(tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
;;	(typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")))

(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'"   . c++-ts-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'"   . c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'"  . python-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cs\\'"  . csharp-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))

(use-package eglot
  :ensure nil
  :hook ((python-ts-mode c-ts-mode c++-ts-mode) . eglot-ensure))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((csharp-mode csharp-ts-mode) . ("OmniSharp" "-lsp"))))

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
 '(package-selected-packages nil))
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

;; seperate from the shell function to make it easy
(defun cmk (dir)
  "Create DIR if needed, copy CMake template, make src/ and include/."
  (interactive (list (read-directory-name "Project directory: ")))
  (let ((dir (file-name-as-directory (expand-file-name dir))))
    (make-directory dir t)
    (copy-file "~/.config/cmake-template/CMakeLists.txt" dir)
    (make-directory (concat dir "src") t)
    (make-directory (concat dir "include") t)
    (dired dir)))

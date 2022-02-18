;;; init.el --- Summary

;;; Commentary:

;;; Code:

(setq-default mode-line-format nil
	      electric-indent-inhibit t)
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(setq backup-directory-alist `(("." . "~/.emacs.d/backups/"))
      user-full-name "Javier de Marco"
      user-mail-address "javierdemarcoo@gmail.com"
      visible-bell t
      delete-by-moving-to-trash t
      uniquify-buffer-name-style 'post-forward-angle-brackets
      undo-limit 80000000
      auto-save-default t
      scroll-margin 2
      display-line-numbers-type 'relative
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t
      read-process-output-max #x10000
      idle-update-delay 1.0
      inhibit-startup-screen t
      inhibit-startup-echo-area-message t
      frame-title-format '("Emacs - %b")
      icon-title-format frame-title-format
      show-trailing-whitespace t
      scroll-step 1
      scroll-margin 0
      scroll-conservatively 100000
      auto-window-vscroll nil
      user-banners-dir (concat user-emacs-directory (convert-standard-filename "banners/"))
      scroll-preserve-screen-position t)
(when (display-graphic-p)
  (setq mouse-wheel-scroll-amount '(1 ((shift) . hscroll))
        mouse-wheel-scroll-amount-horizontal 1
        mouse-wheel-progressive-speed nil))
(add-hook 'before-save-hook #'delete-trailing-whitespace nil t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode 1)
(set-fringe-mode 2)
(menu-bar-mode 1)
(column-number-mode)
(global-display-line-numbers-mode)
(add-to-list 'default-frame-alist
             '(font . "Monoid NF-10"))
(defmacro with-system (type &rest body)
  "Evaluate BODY if `system-type' equals TYPE."
  (declare (indent defun))
  `(when (eq system-type ',type)
     ,@body))
(defun eee-open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))
(defun install-banners ()
  "Copy all files under under banners directory to dashboard banners directory"
  (when (boundp 'dashboard-banners-directory)
    (copy-directory user-banners-dir dashboard-banners-directory nil nil t)))
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(eval-and-compile
  (setq use-package-always-ensure t))
(use-package general)
(use-package benchmark-init
  :config
  (add-hook 'after-init-hook 'benchmark-init/deactivate))
(use-package kaolin-themes
  :config
  (load-theme 'kaolin-ocean t)
  (kaolin-treemacs-theme))
(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t
	auto-package-update-hide-results t)
  (auto-package-update-maybe))
(use-package savehist
  :init
  (savehist-mode))
(use-package page-break-lines
  :init
  (global-page-break-lines-mode))
(use-package all-the-icons
  :if (display-graphic-p))
(use-package all-the-icons-completion
  :config (all-the-icons-completion-mode))
(use-package projectile
  :bind
  ("M-p" . projectile-command-map)
  :hook
  (after-init . projectile-mode)
  :init
  (setq projectile-mode-line-prefix ""
        projectile-sort-order 'recentf
        projectile-use-git-grep t))
(use-package dashboard
  :config
  (setq dashboard-center-content t
	dashboard-banner-logo-title ""
	dashboard-startup-banner 'aux
	dashboard-set-heading-icons t
	dashboard-set-file-icons t
	dashboard-set-navigator t
	dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5))
	dashboard-navigator-buttons
	`(;; line1
	  ((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
	    "Homepage"
	    "Browse homepage"
	    (lambda (&rest _) (browse-url "https://github.com/javierdemarco/eee")))
	   ;;("?" "" "?/h" #'show-help nil "<" ">"))
	   (,(all-the-icons-octicon "gear" :height 1.1 :v-adjust 0.0)
	    "Settings"
	    "Open Configuration File"
	    (lambda (&rest _) (eee-open-init-file))))))
  (dashboard-setup-startup-hook))
(use-package helpful
  :bind
  :config
  (setq counsel-describe-function-function #'helpful-callable)
  (setq counsel-describe-variable-function #'helpful-variable))
(use-package good-scroll
  :hook (after-init . good-scroll-mode)
  :bind (([remap next] . good-scroll-up-full-screen)
         ([remap prior] . good-scroll-down-full-screen)))
(use-package iscroll
  :hook (image-mode . iscroll-mode))
(use-package workgroups2
  :bind
  ("C-c z c" . wg-create-workgroup)
  ("C-c z o" . wg-open-workgroup)
  ("C-c z k" . wg-kill-workgroup))
(use-package amx
  :init (amx-mode))
(use-package vertico
  :config
  (setq vertico-cycle t)
  :init  (vertico-mode))
(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))
(use-package marginalia
  :init
  (marginalia-mode)
  :hook (add-hook 'marginalia-mode-hook #'all-the-icons-completion-marginalia-setup))
(use-package embark
  :bind
  (("C-." . embark-act) 
   ("M-." . embark-dwim)        
   ("C-h B" . embark-bindings)) 
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))
(use-package consult
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x r b" . consult-bookmark)
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ("<help> a" . consult-apropos))
  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI. You may want to also
  ;; enable `consult-preview-at-point-mode` in Embark Collect buffers.
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)
  :config
  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-recent-file consult--source-project-recent-file consult--source-bookmark
   :preview-key (kbd "M-."))
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-root-function #'projectile-project-root))
(use-package embark-consult
  :after (embark consult)
  :demand t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)))
(use-package symbol-overlay)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package highlight-thing
  :init
  (global-highlight-thing-mode))
(use-package beacon
  :hook (prog-mode . beacon-mode))
(use-package evil
  :config
  (evil-mode 1)
  :init (setq evil-want-keybinding nil))
(use-package goto-chg)
(use-package evil-collection
  :after evil
  :config (evil-collection-init))
(use-package treemacs
  :commands (treemacs-follow-mode
             treemacs-filewatch-mode
             treemacs-fringe-indicator-mode
             treemacs-git-mode)
  :custom-face
  (cfrs-border-color ((t (:background ,(face-foreground 'font-lock-comment-face nil t)))))
  :bind (([f8]        . treemacs)
         ("M-0"       . treemacs-select-window)
         ("C-x 1"     . treemacs-delete-other-windows) 
         :map treemacs-mode-map
         ([mouse-1]   . treemacs-single-click-expand-action))
  :config
  (setq treemacs-collapse-dirs           (if treemacs-python-executable 3 0)
        treemacs-missing-project-action  'remove
        treemacs-sorting                 'alphabetic-asc
        treemacs-follow-after-init       t
        treemacs-width                   30)
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (pcase (cons (not (null (executable-find "git")))
	       (not (null (executable-find "python3"))))
    (`(t . t)
     (treemacs-git-mode 'deferred))
    (`(t . _)
     (treemacs-git-mode 'simple))))
(use-package treemacs-projectile
  :after projectile
  :bind (:map projectile-command-map
	      ("h" . treemacs-projectile)))
(use-package treemacs-magit
  :after magit
  :commands treemacs-magit--schedule-update
  :hook ((magit-post-commit
          git-commit-post-finish
          magit-post-stage
          magit-post-unstage)
         . treemacs-magit--schedule-update))
(use-package treemacs-evil
  :after treemacs)
(use-package treemacs-icons-dired
  :after treemacs
  :config (treemacs-icons-dired-mode))
(use-package treemacs-all-the-icons
  :after treemacs)
(use-package multiple-cursors
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this))
(use-package hungry-delete
  :hook (prog-mode . hungry-delete-mode))
(use-package evil-nerd-commenter
  :after evil
  :config
  (setq evil-undo-system 'undo-fu)
  (evilnc-default-hotkeys))
(use-package undo-fu
  :config
  (define-key evil-normal-state-map "u" 'undo-fu-only-undo)
  (define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo))
(use-package smartparens
  :hook (prog-mode . smartparens-mode))
(use-package which-key
  :config
  (which-key-mode))
(use-package tree-sitter
  :hook (prog-mode . tree-sitter-mode)
  (prog-mode . tree-sitter-hl-mode))
(use-package tree-sitter-langs
  :after tree-sitter)
(use-package format-all
  :hook (prog-mode . format-all-mode))
(use-package indent-guide
  :hook (prog-mode . indent-guide-mode))
(use-package magit
  :commands magit-status)
(use-package flycheck
  :hook (after-init . global-flycheck-mode))
(use-package consult-flycheck
  :after consult)
(use-package git-gutter
  :hook (after-init . global-git-gutter-mode))
;;(use-package vterm)
(use-package restart-emacs)
(use-package company
  :hook (after-init-hook . global-company-mode))
(use-package company-quickhelp
  :after company
  :hook (global-company-mode . company-quickhelp-mode))
(use-package company-box
  :hook (company-mode . company-box-mode))
(use-package lsp-mode
  :config
  (setq lsp-keymap-prefix "C-c l"
	gc-cons-threshold 100000000
	read-process-output-max (* 1024 1024)
	lsp-idle-delay 0.500
	lsp-log-io nil
	lsp-completion-provider :capf
	lsp-prefer-flymake nil)
  :hook ((prog-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)
(use-package lsp-ui 
  :after lsp-mode
  :commands lsp-ui-mode)
(use-package lsp-treemacs
  :after lsp-mode
  :commands lsp-treemacs-errors-list)
(use-package yasnippet
  :hook (prog-mode . yas-global-mode))
(use-package yasnippet-snippets
  :after yasnippet)
(use-package dap-mode
  :hook
  (lsp-mode . dap-auto-configure-mode))
;; (use-package dap-python
;;   :after dap-mode)
(use-package all-the-icons-ibuffer
  :init
  (all-the-icons-ibuffer-mode 1))
(use-package ibuffer-projectile
  :functions all-the-icons-octicon ibuffer-do-sort-by-alphabetic
  :hook ((ibuffer . (lambda ()
		      (ibuffer-projectile-set-filter-groups)
		      (unless (eq ibuffer-sorting-mode 'alphabetic)
                        (ibuffer-do-sort-by-alphabetic)))))
  :config
  (setq ibuffer-projectile-prefix
        (concat
         (all-the-icons-octicon "file-directory"
                                :face ibuffer-filter-group-name-face
                                :v-adjust 0.0
                                :height 1.0)
         " "
         "Project: ")))
(use-package paren
  :ensure nil
  :hook (after-init . show-paren-mode)
  :init (setq show-paren-when-point-inside-paren t
	      show-paren-when-point-in-periphery t))
(defvar awesome-tab-path "~/.emacs.d/elisp/awesome-tab"
  "Path to awesome tab package.")
(defvar awesome-tray-path "~/.emacs.d/elisp/awesome-tray"
  "Path to awesome tray package.")
(defmacro with-system (type &rest body)
  "Evaluate BODY if `system-type' equals TYPE."
  (declare (indent defun))
  `(when (eq system-type ',type)
     ,@body))
(with-system ms-dos
  (setq awesome-tab-path "C:/Users/jmarco/AppData/Roaming/.emacs.d/elisp/awesome-tab")
  (setq awesome-tray-path "C:/Users/jmarco/AppData/Roaming/.emacs.d/elisp/awesome-tray"))
(use-package awesome-tab
  :load-path awesome-tab-path
  :config
  (awesome-tab-mode t)
  (setq awesome-tab-height 90
	awesome-tab-show-tab-index t))
(use-package awesome-tray
  :load-path awesome-tray-path
  :config
  (setq awesome-tray-file-path-show-filename t
	awesome-tray-file-path-full-dirname-levels 0
	awesome-tray-file-path-truncate-dirname-levels 3
	awesome-tray-file-path-truncated-name-length 3)
  (awesome-tray-mode t))
(general-define-key
 :keymaps '(normal insert emacs)
 :prefix "C-q"
 :prefix-command 'eee-consult-search-prefix-command
 :prefix-map 'eee-consult-search-prefix-map
 "s" 'consult-line
 "d" 'consult-find
 "D" 'consult-locate
 "g" 'consult-grep
 "G" 'consult-git-grep
 "r" 'consult-ripgrep
 "l" 'consult-line
 "L" 'consult-line-multi
 "m" 'consult-multi-occur
 "k" 'consult-keep-lines
 "u" 'consult-focus-lines)
(general-define-key
 :keymaps '(normal insert emacs)
 :prefix "M-s"
 :prefix-command 'eee-symbol-overlay-prefix-command
 :prefix-map 'eee-symbol-overlay-prefix-map
 "i" 'symbol-overlay-put
 "n" 'symbol-overlay-jump-next
 "p" 'symbol-overlay-jump-prev
 "w" 'symbol-overlay-save-symbol
 "t" 'symbol-overlay-toggle-in-scope
 "e" 'symbol-overlay-echo-mark
 "d" 'symbol-overlay-jump-to-definition
 "s" 'symbol-overlay-isearch-literally
 "q" 'symbol-overlay-query-replace
 "r" 'symbol-overlay-rename)
(general-define-key
 :keymaps '(normal insert emacs)
 :prefix "C-x t"
 :prefix-command 'eee-treemacs-prefix-command
 :prefix-map 'eee-treemacs-prefix-map
 "1"  'treemacs-delete-other-windows
 "t"   'treemacs
 "b"   'treemacs-bookmark
 "C-t" 'treemacs-find-file
 "M-t" 'treemacs-find-tag)
(general-define-key
 :keymaps '(normal insert emacs)
 :prefix "M-g"
 :prefix-command 'eee-consult-goto-prefix-command
 :prefix-map 'eee-consult-goto-prefix-map
 "e" 'consult-compile-error
 "f" 'consult-flycheck
 "g" 'consult-goto-line
 "M-g" 'consult-goto-line
 "o" 'consult-outline
 "m" 'consult-mark
 "k" 'consult-global-mark
 "i" 'consult-imenu
 "I" 'consult-imenu-multi)
(general-define-key
 :keymaps '(normal insert emacs)
 :prefix "<help>"
 :prefix-command 'eee-help-prefix-command
 :prefix-map 'eee-help-prefix-map
 " f" 'helpful-callable
 " v"  'helpful-variable
 "k" 'helpful-key
 "C-d" 'helpful-at-point
 "F" 'helpful-function
 "C" 'helpful-command)
(use-package scala-mode
  :interpreter
  ("scala" . scala-mode))
(use-package lsp-metals
  :custom
  ;; Metals claims to support range formatting by default but it supports range
  ;; formatting of multiline strings only. You might want to disable it so that
  ;; emacs can use indentation provided by scala-mode.
  (lsp-metals-server-args '("-J-Dmetals.allow-multiline-string-formatting=off"))
  :hook (scala-mode . lsp))
(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(awesome-tray-active-modules
   '("circe" "evil" "location" "file-path" "mode-name" "git" "buffer-read-only")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cfrs-border-color ((t (:background "#545c5e")))))

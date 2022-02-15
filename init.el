;;; init.el --- Summary

;;; Commentary:

;;; Code:

(setq user-full-name "Javier de Marco")
(setq user-mail-address "javierdemarcoo@gmail.com")
(setq-default mode-line-format nil
	      electric-indent-inhibit t)
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(setq backup-directory-alist `(("." . "~/.emacs.d/backups/"))
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
      scroll-preserve-screen-position t
      )
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
(defconst eee-logo-art " _______  _______  _______ 
(  ____ \\(  ____ \\(  ____ \
| (    \\/| (    \\/| (    \\/
| (__    | (__    | (__    
|  __)   |  __)   |  __)   
| (      | (      | (      
| (____/\\| (____/\\| (____/\
(_______/(_______/(_______/
                           ")
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
(use-package benchmark-init
  :config
  (add-hook 'after-init-hook 'benchmark-init/deactivate))
(use-package kaolin-themes
  :config
  (load-theme 'kaolin-aurora t)
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
  ("C-c p" . projectile-command-map)
  :hook
  (after-init . projectile-mode)
  :init
  (setq projectile-mode-line-prefix ""
        projectile-sort-order 'recentf
        projectile-use-git-grep t))
(use-package dashboard
  :config
  (setq dashboard-center-content t
	;;TODO: Generate ascci art or logo and insert to dashboard
	dashboard-startup-banner 'eee-logo-art
	dashboard-banner-logo-title "Welcome to EEE"
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
  ("C-h f" . helpful-callable)
  ("C-h v" . helpful-variable)
  ("C-h k" . helpful-key)
  ("C-c C-d" . helpful-at-point)
  ("C-h F" . helpful-function)
  ("C-h C" . helpful-command)
  :config
  (setq counsel-describe-function-function #'helpful-callable)
  (setq counsel-describe-variable-function #'helpful-variable)
  )
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
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
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
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flycheck)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi))           ;; needed by consult-line to detect isearch

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI. You may want to also
  ;; enable `consult-preview-at-point-mode` in Embark Collect buffers.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Optionally replace `completing-read-multiple' with an enhanced version.
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
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

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; Optionally configure a function which returns the project root directory.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (project-roots)
  (setq consult-project-root-function
        (lambda ()
          (when-let (project (project-current))
            (car (project-roots project)))))
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-root-function #'projectile-project-root)
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-root-function #'vc-root-dir)
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-root-function (lambda () (locate-dominating-file "." ".git")))
  )
(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))
;; (use-package centaur-tabs
;;   :init
;;   (centaur-tabs-mode t)
;;   (setq centaur-tabs-style "rounded"
;; 	centaur-tabs-height 18
;; 	centaur-tabs-set-icons t
;; 	centaur-tabs-set-bar 'under
;; 	centaur-tabs-set-modified-marker t
;; 	centaur-tabs-cycle-scope 'tabs
;; 	uniquify-separator "/"
;; 	uniquify-buffer-name-style 'forward)
;;   :hook
;;   (dired-mode . centaur-tabs-local-mode)
;;   (dashboard-mode . centaur-tabs-local-mode)
;;   (term-mode . centaur-tabs-local-mode)
;;   (helpful-mode . centaur-tabs-local-mode)
;;   :bind
;;   ("C-<prior>" . centaur-tabs-backward)
;;   ("C-<next>" . centaur-tabs-forward))
(use-package anzu
  :init (global-anzu-mode 1))
(use-package symbol-overlay
  :bind
  ("M-s i" . symbol-overlay-put)
  ("M-s n" . symbol-overlay-jump-next)
  ("M-s p" . symbol-overlay-jump-prev)
  ("M-s w" . symbol-overlay-save-symbol)
  ("M-s t" . symbol-overlay-toggle-in-scope)
  ("M-s e" . symbol-overlay-echo-mark)
  ("M-s d" . symbol-overlay-jump-to-definition)
  ("M-s s" . symbol-overlay-isearch-literally)
  ("M-s q" . symbol-overlay-query-replace)
  ("M-s r" . symbol-overlay-rename))
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
         ("C-x t 1"   . treemacs-delete-other-windows)
         ("C-x t t"   . treemacs)
         ("C-x t b"   . treemacs-bookmark)
         ("C-x t C-t" . treemacs-find-file)
         ("C-x t M-t" . treemacs-find-tag)
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
  (evilnc-default-hotkeys))
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
(use-package git-gutter
  :hook (after-init . global-git-gutter-mode))
;;(use-package vterm)
(use-package restart-emacs)
;; (use-package doom-modeline
;;   :hook (after-init . doom-modeline-mode)
;;   :config
;;   (setq doom-modeline-height 14
;; 	doom-modeline-buffer-encoding nil
;; 	doom-modeline-gnus nil
;; 	doom-modeline-irc nil
;; 	doom-modeline-buffer-file-name-style 'truncate-except-project
;; 	))
(use-package company
  :hook (after-init-hook . global-company-mode))
(use-package company-quickhelp
  :after company
  :hook (global-company-mode . company-quickhelp-mode))
(use-package company-box
  :hook (company-mode . company-box-mode))
(use-package lsp-mode
  :config
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (prog-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)
;; optionally
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
  (awesome-tray-mode t)
  )

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
 '(cfrs-border-color ((t (:background "#454459")))))

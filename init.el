;; .emacs.d/init.el


;; ===================================

;; MELPA Package Support

;; ===================================

;; Enables basic packaging support

(require 'package)
                                        ;(require 'use-package)

;; Adds the Melpa archive to the list of available repositories
;;(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "http://mirrors.163.com/elpa/gnu/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))
;;(add-to-list 'package-archives
;;             '("melpa" . "http://melpa.org/packages/") t)

;; Initializes the package infrastructure
(package-initialize)

(defvar my-packages
  '(
    better-defaults
    use-package
    auto-complete
    geiser
    rainbow-delimiters
    racket-mode
    fira-code-mode
    smartparens
    all-the-icons
    flycheck
    doom-themes
    ))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (print (format "Installing %s" p))
    (package-install p)))

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;;(add-hook 'cider-repl-mode-hook #'smartpens-strict-mode)
(add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)

;; ============================
;; Customization
;; ============================

(load-theme 'spacemacs-dark t)


(windmove-default-keybindings)
;(setq user-emacs-directory (file-truename "~.emacs.d/"))
(setq inhibit-startup-message t)

(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(top . 80))
(add-to-list 'default-frame-alist '(left . 140))

(global-linum-mode t)

(add-hook 'racket-mode-hook
          (lambda ()
            (define-key racket-mode-map
              (kbd "<C-return>") 'racket-send-last-sexp)))


(setq ring-bell-function 'ignore)

(setq paredit-mode 't)

;; ===============
;; ========= Ivy

(use-package ivy
  :config
  (ivy-mode t))
(setq ivy-initial-inputs-alist nil)

(use-package counsel
  :bind (("M-x" . counsel-M-x)))

(use-package prescient)
(use-package ivy-prescient
  :config
  (ivy-prescient-mode t))

(use-package swiper
  :bind (("M-s" . counsel-grep-or-swiper)))

(use-package ivy-hydra)

(use-package major-mode-hydra
  :bind
  ("C-M-SPC" . major-mode-hydra)
  :config
  (major-mode-hydra-define org-mode
    ()
    ("Tools"
     (("l" org-lint "lint")))))

(use-package which-key
  :config
  (add-hook 'after-init-hook 'which-key-mode))

;; =====================
;; === Appearance, Coding, Navigation and selection

(setq prettify-symbols-mode 't)

(use-package smartparens
  :config
  (add-hook 'prog-mode-hook 'smartparens-mode))

(use-package rainbow-mode
  :config
  (setq rainbow-x-colors nil)
  (add-hook 'prog-mode-hook 'rainbow-mode))

(add-hook 'prog-mode-hook 'electric-pair-mode)

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package git-gutter
  :config
  (global-git-gutter-mode 't))

(use-package undo-tree
  :defer 5
  :config
  (global-undo-tree-mode 1))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(require 'flycheck)
(global-flycheck-mode)

(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))
(setq centaur-tabs-style "wave")

(require 'dashboard)
(dashboard-setup-startup-hook)
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)


(indent-guide-global-mode)
;;(set-face-background 'indent-guide-face "dimgray")


;; ===============
;; Languages and LSP

(setq lsp-keymap-prefix "C-c l")

(use-package lsp-mode
  :ensure t
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :custom (lsp-enable-on-type-formatting nil)
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python3" . python-mode))

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (setq elpy-rpc-python-command "python3")
  (setq python-shell-interpreter "python3")
  (setq python-shell-interpreter-args "-i")
  :bind (:map elpy-mode-map
	      ("M-." . elpy-goto-definition)
	      ("M-," . pop-tag-mark)))

;; (use-package pip-requirements
;;   :ensure t
;;   :config
;;   (add-hook 'pip-requirements-mode-hook #'pip-requirements-auto-complete-setup))

;; (use-package py-autopep8
;;   :ensure t)

;; ===========
;; FONTS


(when (window-system)
  (set-frame-font "Fira Code 11"))
(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
               (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               (91 . ".\\(?:]\\)")
               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
               (123 . ".\\(?:-\\)")
               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))



;; ===========
;; == NOT FONTS


(ac-config-default)
(global-auto-complete-mode t)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; =======================
;; Org Mode
;; =======================


(let* ((normal-gc-cons-threshold (* 20 1024 1024))
       (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
	    (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))


(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(use-package yasnippet
  :defer 5
  :diminish yas-minor-mode
  :config (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

(add-hook 'prog-mode-hook #'yas-minor-mode)
(add-hook 'org-mode-hook #'yas-minor-mode)

(defvar rag--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; load directory for configuration files for emacs
(add-to-list 'load-path (concat user-emacs-directory "setup-files/"))

;; set home and emacs directories
(defvar user-home-directory (concat (getenv "HOME") "/"))
(setq user-emacs-directory (concat user-home-directory ".emacs.d/"))

;;(load (locate-user-emacs-file "ob-racket.el") nil :nomessage)
;;(add-to-list 'load-path "~/emacs-ob-racket/")
(add-to-list 'load-path (concat user-emacs-directory  "\\ob-racket.el"))


;;(add-to-list 'org-src-lang-modes '("racket" . geiser))
;;(setq org-babel-racket-command "C:\\Program Files\\Racket\\Racket.exe")

(add-hook 'org-mode-hook #'racket-mode)
(use-package org
  :ensure t

  :mode (("\\.org\\'" . org-mode))

  :bind (("C-c l" . org-store-link)
	 ("C-c c" . org-capture)
	 ("C-c a" . org-agenda))

  :config
  (org-babel-do-load-languages 'org-babel-load-languages '((shell . t)
							   (python . t)
							   (emacs-lisp . t)
                                                           (racket . t)
                                                           (clojure . t)
                                                           (ipython . t)))

  (set-register ?l `(cons 'file ,(concat org-directory "/links.org")))

  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

  (setq org-feed-alist
	'(("Slashdot"
	   "http://rss.slashdot.org/Slashdot/slashdot"
	   (concat org-directory "/feeds.org")
	   "Slashdot Entries")))
  )


(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "C:Users/aresf/Code/orgmode/work.org"
                             "C:Users/aresf/Code/orgmode/monozukuri.org"
                             "C:Users/aresf/Code/orgmode/tutorial.org"
                             ))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook
            (lambda () (org-bullets-mode t))))
(setq org-hide-leading-stars t)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(add-hook 'org-mode-hook 'org-indent-mode)

(setq org-startup-indented 'f)
(setq org-directory "~/org")
(setq org-special-ctrl-a/e 't)
(define-key global-map "\C-cc" 'org-capture)
(setq org-confirm-babel-evaluate nil)
(setq org-src-fontify-natively 't)
(setq org-src-tab-acts-natively 't)
;(setq ob-async-org-babel-execute-src-block)
(setq org-src-window-setup 'current-window)

(let*
    ((base-font-color     (face-foreground 'default nil 'default))
     (headline           `(:foreground ,base-font-color)))

  (custom-theme-set-faces 'user
                          `(org-level-8 ((t (,@headline))))
                          `(org-level-7 ((t (,@headline))))
                          `(org-level-6 ((t (,@headline))))
                          `(org-level-5 ((t (,@headline))))
                          `(org-level-4 ((t (,@headline))))
                          `(org-level-3 ((t (,@headline :height 1.3))))
                          `(org-level-2 ((t (,@headline :height 1.3))))
                          `(org-level-1 ((t (,@headline :height 1.3 ))))
                          `(org-document-title ((t (,@headline :height 1))))))

(add-hook 'org-mode-hook
          (lambda () (setq-local auto-composition-mode nil)))

(use-package org-brain :ensure t
  :config
  (bind-key "C-c b" 'org-brain-prefix-map org-mode-map)
  (setq org-id-track-globally t)
  (setq org-id-locations-file "~/.emacs.d/.org-id-locations")
  (add-hook 'before-save-hook #'org-brain-ensure-ids-in-buffer)
  (setq org-brain-visualize-default-choices 'all)
  ;;  (setq org-brain-title-max-length 12)
  (setq org-brain-include-file-entries nil
        org-brain-file-entries-use-title nil))

;; Allows you to edit entries directly from org-brain-visualize
(use-package polymode
  :config
  (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))


;; =========================
;; Package requirements
;; =========================

(require 'better-defaults)
(require 'smartparens)
(require 'all-the-icons)
;;(require 'neotree)
(require 'doom-themes)
(require 'flycheck-clj-kondo)
;;(global-set-key [f8] 'neotree-toggle)
(require 'geiser)
;;(setq geiser-active-implementations '(mit))

(defun geiser-save ()
  (interactive)
  (geiser-repl-write-input-rign)
  )


;; =========================
;; Path
;; ========================
;; (setenv "PATH" (concat (getenv "PATH")


;; ==========================
;; Not sure how this got here
;; -------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful. ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(better-defaults cider spacemacs-theme)))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )

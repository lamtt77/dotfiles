;;; init.el -*- lexical-binding: t; -*-
(setq startup-time-tic (current-time))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4a8d4375d90a7051115db94ed40e9abb2c0766e80e228ecad60e06b3b397acab" "d6603a129c32b716b3d3541fc0b6bfe83d0e07f1954ee64517aa62c9405a3441" "711efe8b1233f2cf52f338fd7f15ce11c836d0b6240a18fffffc2cbd5bfe61b0" "9efb2d10bfb38fe7cd4586afb3e644d082cbcdb7435f3d1e8dd9413cbe5e61fc" "b89ae2d35d2e18e4286c8be8aaecb41022c1a306070f64a66fd114310ade88aa" "a06658a45f043cd95549d6845454ad1c1d6e24a99271676ae56157619952394a" "e1d09f1b2afc2fed6feb1d672be5ec6ae61f84e058cb757689edb669be926896" "123a8dabd1a0eff6e0c48a03dc6fb2c5e03ebc7062ba531543dfbce587e86f2a" "939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a" "aded61687237d1dff6325edb492bde536f40b048eab7246c61d5c6643c696b7f" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; from doom-emacs core.el, should be here or early-init.el?
(defconst EMACS27+   (> emacs-major-version 26))
(defconst EMACS28+   (> emacs-major-version 27))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))

;; I use `dwm` terminal which has different default font size
(if IS-LINUX (setq my-font (font-spec :family "Liberation Mono" :size 10.5)))

;; === apply some (not all) doom performance tuning tips, startup time 3.6s -> 2.3s after tuned (reduced ~36%)
;; gccemacs startup time also being at ~2.4s, so not improving if already using straight??
;; will % increase if adding more packages? Currently last package is avy
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)

;; replaced by gcmh package
;; (defun doom-defer-garbage-collection-h ()
;;   (setq gc-cons-threshold most-positive-fixnum))

;; (defun doom-restore-garbage-collection-h ()
;;   ;; Defer it so that commands launched immediately after will enjoy the benefits.
;;   (run-at-time
;;    1 nil (lambda () (setq gc-cons-threshold 16777216)))) ; 16mb

;; (add-hook 'minibuffer-setup-hook #'doom-defer-garbage-collection-h)
;; (add-hook 'minibuffer-exit-hook #'doom-restore-garbage-collection-h)
;; ===

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; only need if package-selected-packages is in-use, but leave it here so that we could use package-list-packages
;; ref: https://github.crookster.org/switching-to-straight.el-from-emacs-26-builtin-package.el/
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(setq straight-use-package-by-default t)
(straight-use-package 'use-package)

(use-package benchmark-init
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(fset 'yes-or-no-p 'y-or-n-p)
(column-number-mode t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)			; Use F10 or Fn-F10 for emacs context menu

(put 'downcase-region 'disabled nil)
(setq truncate-lines t) 		; nowrap equivalent, why only work if run manually with C-x C-e?

;; from https://sam217pa.github.io/2016/09/02/how-to-build-your-own-spacemacs/
;; for more ref: https://github.com/abo-abo/oremacs/blob/github/init.el
(setq delete-old-versions -1 )		; delete excess backup versions silently
(setq version-control t )		; use version control
(setq vc-make-backup-files t )		; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ) ; which directory to put backups file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ) ;transform backups file name

(setq ring-bell-function 'ignore )	; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8 )	; use utf-8 by default
(setq coding-system-for-write 'utf-8 )
(setq sentence-end-double-space nil)	; sentence SHOULD end with only a point.
(setq default-fill-column 80)		; toggle wrapping text at the 80th character
(setq initial-scratch-message "Welcome in Emacs") ; print a default message in the empty scratch buffer opened at startup
(setq inhibit-startup-screen t )	; inhibit useless and old-school startup screen

;; performance tuning: garbage collection hack
(use-package gcmh
  :config
  (gcmh-mode 1))

(use-package doom-themes
  :config (load-theme 'doom-gruvbox-light t))

(use-package which-key
  :config
  (which-key-mode))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil 
  :config
  (evil-collection-init)
  ;; Use visual line motions even outside of visual-line-mode buffers, from emacs-from-scratch
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; TODO
;; (use-package evil-commentary)

(use-package magit)

;; (use-package evil-magit
;;   :after magit)

;; Persistent undo-fu, will that be more reliable than undo-tree? is it still needed with gccemacs 28?
(use-package undo-fu
  :after evil 
  :config
  (define-key evil-normal-state-map "u" 'undo-fu-only-undo)
  (define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo))

(use-package undo-fu-session
  :config
  (global-undo-fu-session-mode)
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")))

;; Persistent-undo lost when close-then-open emacs!
;; (use-package undo-tree			
;;   :init
;;   (global-undo-tree-mode)
;;   (evil-set-undo-system 'undo-tree))	; fixed undo-tree not loaded issue in evil-mode

;; company globally??
(use-package company
  :config
  (company-mode 1)
  (add-hook 'after-init-hook 'global-company-mode))

;; turn on flycheck-mode on demand, global-flycheck-mode is a bit too much, do I still need flycheck if used lsp-mode?
(use-package flycheck)

;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
;; (setq lsp-keymap-prefix "s-l")
(setq lsp-keymap-prefix "C-c l")

(use-package lsp-mode
  :hook (;; if you want which-key integration
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

; expand the marked region in semantic increments (negative prefix to reduce region)
(use-package expand-region
  :config
  ;; (global-set-key (kbd "C--") 'er/contract-region)
  (global-set-key (kbd "C-=") 'er/expand-region))

; deletes all the whitespace when you hit backspace or delete
(use-package hungry-delete
  :config
  (global-hungry-delete-mode))

;;(use-package auctex)
;;(use-package ox-report)    ; got issue in MacOS
(use-package gnuplot)
(use-package org-roam)

(setq org-agenda-files "~/org-lam/lam-arch-notes.org")
(setq org-directory "/home/lam/org-lam/")
(setq org-default-notes-file (concat org-directory "capture.org"))

(use-package org-pdftools
  :after org
  :defer nil				; will trigger error without this line, reason?
  :custom
  (pdf-tools-install))

;; not working yet
;; (setq image-use-external-converter t)

(use-package org-download
  :after org
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "images")
  (org-download-heading-lvl nil)
  (org-download-timestamp "%Y%m%d-%H%M%S_")
  (org-image-actual-width 600)
  ;; (org-download-screenshot-method "/usr/bin/scrot %s")
  ;; Drag-and-drop to `dired`
  (add-hook 'dired-mode-hook 'org-download-enable)
  :bind
  ("C-M-y" . org-download-screenshot)
  ("C-M-p" . org-download-clipboard)
  :config)

;; is this still need if using counsel?
(use-package deadgrep
  :config
  (global-set-key (kbd "<f5>") #'deadgrep))

;; counsel includes 3 packages: counsel, swiper and ivy
(use-package counsel
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  ;; (setq search-default-mode #'char-fold-to-regexp)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c c") 'counsel-compile)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c L") 'counsel-git-log)
  (global-set-key (kbd "C-c k") 'counsel-rg)
  (global-set-key (kbd "C-c m") 'counsel-linux-app)
  (global-set-key (kbd "C-c n") 'counsel-fzf)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

(use-package avy
  :config
  (setq avy-case-fold-search nil)       ;; case sensitive makes selection easier
  (bind-key "C-;"    'avy-goto-char-2)  ;; I use this most frequently
  (bind-key "C-'"    'avy-goto-line)    ;; Consistent with ivy-avy
  (bind-key "M-g c"  'avy-goto-char)
  (bind-key "M-g e"  'avy-goto-word-0)  ;; lots of candidates
  (bind-key "M-g g"  'avy-goto-line)    ;; digits behave like goto-line
  (bind-key "M-g w"  'avy-goto-word-1)  ;; first character of the word
  (bind-key "M-g ("  'avy-goto-open-paren)
  (bind-key "M-g )"  'avy-goto-close-paren)
  (bind-key "M-g P"  'avy-pop-mar))

;; === doom performance tuning tips
(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold 16777216 ; 16mb
          gc-cons-percentage 0.1)))
;; ===

(setq startup-time-toc (current-time))
(setq startup-time-seconds
      (time-to-seconds (time-subtract startup-time-toc startup-time-tic)))

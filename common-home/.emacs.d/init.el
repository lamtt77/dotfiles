(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages 'nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "CYRE" :slant normal :weight normal :height 120 :width normal)))))

;; '(package-selected-packages
;;   '(org-roam gnuplot auctex ox-report)))

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

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
;;  (package-initialize)                ; only need if package-selected-packages is in-use

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(fset 'yes-or-no-p 'y-or-n-p)
(column-number-mode t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)			; Use F10 or Fn-F10 for emacs context menu

;; from https://sam217pa.github.io/2016/09/02/how-to-build-your-own-spacemacs/
(setq delete-old-versions -1 )		; delete excess backup versions silently
(setq version-control t )		; use version control
(setq vc-make-backup-files t )		; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ) ; which directory to put backups file
(setq vc-follow-symlinks t )				       ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ) ;transform backups file name
(setq ring-bell-function 'ignore )	; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8 )	; use utf-8 by default
(setq coding-system-for-write 'utf-8 )
(setq sentence-end-double-space nil)	; sentence SHOULD end with only a point.
(setq default-fill-column 80)		; toggle wrapping text at the 80th character
(setq initial-scratch-message "Welcome in Emacs") ; print a default message in the empty scratch buffer opened at startup
(setq inhibit-startup-screen t )	; inhibit useless and old-school startup screen

;;(straight-use-package 'auctex)

(use-package gruvbox-theme
  :config (load-theme 'gruvbox-light-medium t))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (evil-mode 1))

(use-package evil-collection
  :after evil 
  :defer nil
  :config
  (evil-collection-init))

(use-package which-key
  :config
  (which-key-mode))

(use-package undo-tree			
  :init
  (global-undo-tree-mode)
  (evil-set-undo-system 'undo-tree))	; fixed undo-tree not loaded issue in evil-mode

; expand the marked region in semantic increments (negative prefix to reduce region)
(use-package expand-region
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

; deletes all the whitespace when you hit backspace or delete
(use-package hungry-delete
  :config
  (global-hungry-delete-mode))

(use-package gnuplot)

(use-package org-roam)
(use-package ox-report)

(setq org-agenda-files "~/org-lam/lam-arch-notes.org")
(setq org-directory "/home/lam/org-lam/")
(setq org-default-notes-file (concat org-directory "capture.org"))

(use-package org-pdftools
  :after org
  :defer nil
  :custom
  (pdf-tools-install))

;; not working yet
;; (setq image-use-external-converter t)

(use-package org-download
  :after org
  :defer nil
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

;; (use-package magit)
(use-package evil-magit)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '()))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; '(package-selected-packages
;;   '(org-roam gnuplot auctex ox-report evil)))

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
;;  (package-initialize)

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;(straight-use-package 'auctex)

(use-package evil
  :init
  (setq evil-want-keybinding nil))

(use-package evil-collection
  :after evil 
  :defer nil)

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

(use-package org-download
  :after org
  :defer nil
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "images")
  (org-download-heading-lvl nil)
  (org-download-timestamp "%Y%m%d-%H%M%S_")
  (org-image-actual-width 300)
  ;; (org-download-screenshot-method "/usr/bin/scrot %s")
  ;; Drag-and-drop to `dired`
  (add-hook 'dired-mode-hook 'org-download-enable)
  :bind
  ("C-M-y" . org-download-screenshot)
  ("C-M-p" . org-download-clipboard)
  :config)

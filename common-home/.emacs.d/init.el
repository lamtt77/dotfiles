;;; init.el -*- lexical-binding: t; -*-

;; NOTE: init.el is now generated from readme.org.  Please edit that file instead

(setq startup-time-tic (current-time))

;; === apply some doom performance tuning tips, gccemacs startup time before tuning being at ~2.4s with much less packages
;; repeating here in case early-init.el is not loaded with chemacs
(setq gc-cons-threshold most-positive-fixnum)
(setq package-enable-at-startup nil)
(setq comp-deferred-compilation nil)

;; `file-name-handler-alist' is consulted on every `require', `load' and various
;; path/io functions. You get a minor speed up by nooping this. However, this
;; may cause problems on builds of Emacs where its site lisp files aren't
;; byte-compiled and we're forced to load the *.el.gz files (e.g. on Alpine)
(unless (daemonp)
  (defvar doom--initial-file-name-handler-alist file-name-handler-alist)
  (setq file-name-handler-alist nil)
  ;; Restore `file-name-handler-alist' later, because it is needed for handling
  ;; encrypted or compressed files, among other things.
  (defun doom-reset-file-handler-alist-h ()
    ;; Re-add rather than `setq', because changes to `file-name-handler-alist'
    ;; since startup ought to be preserved.
    (dolist (handler file-name-handler-alist)
      (add-to-list 'doom--initial-file-name-handler-alist handler))
    (setq file-name-handler-alist doom--initial-file-name-handler-alist))
  (add-hook 'emacs-startup-hook #'doom-reset-file-handler-alist-h)
  (add-hook 'after-init-hook #'(lambda ()
                                 ;; restore after startup
                                 (setq gc-cons-threshold 16777216
                                       gc-cons-percentage 0.1)))
  )
;; Ensure Doom is running out of this file's directory
(setq user-emacs-directory (file-name-directory load-file-name))

(setq straight-use-package-by-default t)
;; below does not fully work yet, unless finding and correcting `:demand` on all appropriate packages
;; (setq use-package-always-defer t)

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

(straight-use-package 'use-package)

;; leave it here so that we could use package-list-packages
;; (require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; M-x use-package-report to see the statictics
;; (setq use-package-compute-statistics t)

(use-package benchmark-init
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

;; performance tuning: garbage collection hack
(use-package gcmh
  :demand
  :config
  (gcmh-mode 1))

;; don't show any extra window chrome
(when (window-system)
  (column-number-mode t)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  (menu-bar-mode -1)			              ; Use F10 or Fn-F10 for emacs context menu
  (toggle-scroll-bar -1))

;; from doom-emacs core.el
(defconst EMACS27+   (> emacs-major-version 26))
(defconst EMACS28+   (> emacs-major-version 27))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))

;; always allow 'y' instead of 'yes'.
(defalias 'yes-or-no-p 'y-or-n-p)

;; restore the defaults changed by emacsMacport
(cond (IS-MAC (setq mac-command-modifier      'super
                    mac-option-modifier       'meta
                    mac-control-modifier      'control
                    )))

;; from https://sam217pa.github.io/2016/09/02/how-to-build-your-own-spacemacs/
;; for more ref: https://github.com/abo-abo/oremacs/blob/github/init.el
(setq delete-old-versions -1)           ; delete excess backup versions silently
(setq version-control t)                ; use version control
(setq vc-make-backup-files t)           ; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))                   ; which directory to put backups file
(setq vc-follow-symlinks t)             ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))  ;transform backups file name

(setq user-full-name "LamT"
      user-mail-address "lam@lamhub.com")

;; customized from yay-evil-emacs, better scrolling experience, press 'k' do not scroll-back page pls
(setq scroll-margin 3
      scroll-conservatively 101 ; > 100
      scroll-preserve-screen-position t
      auto-window-vscroll nil)

;; dump custom-set-variables to a custom.el file and don't load it
(setq custom-file (concat user-emacs-directory "custom.el"))

;; from https://github.com/lccambiaghi/vanilla-emacs
(setq inhibit-startup-screen t        ; toggle wrapping text at the 80th character
      kill-whole-line t               ; make Ctrl-K remove the whole line, instead of just emptying it.
      default-fill-column 80
      initial-scratch-message nil
      sentence-end-double-space nil
      ring-bell-function 'ignore
      blink-cursor-mode nil
      frame-resize-pixelwise t
      create-lockfiles nil)

;; default to utf-8 for all the things
(set-charset-priority 'unicode)
(setq locale-coding-system 'utf-8
      coding-system-for-read 'utf-8
      coding-system-for-write 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; write over selected text on input... like all modern editors do
(delete-selection-mode t)
(show-paren-mode t)
(recentf-mode t)
;; enable winner mode globally for undo/redo window layout changes
(winner-mode t)

;; don't want ESC as a modifier
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Don't persist a custom file, this bites me more than it helps
(setq custom-file (make-temp-file "")) ; use a temp file as a placeholder
(setq custom-safe-themes t)            ; mark all themes as safe, since we can't persist now
(setq enable-local-variables :all)     ; fix =defvar= warnings

;; from https://github.com/gilbertw1/bmacs/blob/master/bmacs.org#popup-rules
(defvar my-popups '()
  "A list of popup matchers that determine if a popup can be escaped")

(cl-defun my/make-popup (buffer-rx &optional (height 0.4))
  (add-to-list 'my-popups buffer-rx)
  (add-to-list 'display-buffer-alist
               `(,buffer-rx
                 (display-buffer-reuse-window
                  display-buffer-in-side-window)
                 (reusable-frames . visible)
                 (side            . bottom)
                 (window-height   . ,height))))

(my/make-popup (rx bos "*Messages*" eos))
(my/make-popup (rx bos "*Backtrace*" eos))
(my/make-popup (rx bos "*Warnings*" eos))
(my/make-popup (rx bos "*compilation*" eos))
(my/make-popup (rx bos "*Help*" eos))
(my/make-popup (rx bos "*helpful*" eos))
(my/make-popup (rx bos "*scratch*" eos) 0.4)

;; from https://emacs.stackexchange.com/questions/46210/reuse-help-window
(setq display-buffer-alist
      `((,(rx bos (or "*Apropos*" "*Help*" "*helpful" "*info*" "*Summary*") (0+ not-newline))
         (display-buffer-reuse-mode-window display-buffer-below-selected)
         (window-height . 0.33)
         (mode apropos-mode help-mode helpful-mode Info-mode Man-mode))))

(add-to-list 'display-buffer-alist
             '((lambda (buffer _) (with-current-buffer buffer
                                    (seq-some (lambda (mode)
                                                (derived-mode-p mode))
                                              '(help-mode))))
               (display-buffer-reuse-window display-buffer-below-selected)
               (reusable-frames . visible)
               (window-height . 0.33)))

;; use common convention for indentation by default
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; use a reasonable line length
(setq-default fill-column 120)

;; let emacs handle indentation
(electric-indent-mode +1)
;; and auto-close parentheses
(electric-pair-mode +1)
(add-function :before-until electric-pair-inhibit-predicate
              (lambda (c) (eq c ?<)))

;; add a visual intent guide
(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  ;; :custom
  ;; (highlight-indent-guides-method 'character)
  ;; (highlight-indent-guides-character ?|)
  ;; (highlight-indent-guides-responsive 'stack)
  )
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package tree-sitter
  :hook (python-mode . (lambda ()
                         (require 'tree-sitter)
                         (require 'tree-sitter-langs)
                         (require 'tree-sitter-hl)
                         (tree-sitter-hl-mode))))

(use-package general
  :demand t
  :config
  (general-evil-setup)

  (general-create-definer my/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer my/local-leader-keys
    :states '(normal visual)
    :keymaps 'override
    ;; :prefix ","
    :global-prefix "SPC m")

  (my/leader-keys
    "SPC" '(execute-extended-command :which-key "execute command")
    "`" '(switch-to-prev-buffer :which-key "prev buffer")
    ";" '(eval-expression :which-key "eval sexp")

    "b" '(:ignore t :which-key "buffer")
    "br"  'revert-buffer
    "bd"  'kill-current-buffer
    "bs" '((lambda () (interactive) (pop-to-buffer "*scratch*")) :wk "scratch")

    "c" '(:ignore t :which-key "code")

    "f" '(:ignore t :which-key "file")
    "ff"  'find-file
    "fs" 'save-buffer
    "fr" 'recentf-open-files

    "g" '(:ignore t :which-key "git")

    "h" '(:ignore t :which-key "describe")
    "hv" 'describe-variable
    "he" 'view-echo-area-messages
    "hp" 'describe-package
    "hf" 'describe-function
    "hF" 'describe-face
    "hk" 'describe-key

    "o" '(:ignore t :which-key "org")

    "p" '(:ignore t :which-key "project")

    "s" '(:ignore t :which-key "search")

    "t"  '(:ignore t :which-key "toggle")
    "td"  '(toggle-debug-on-error :which-key "debug on error")
    "tv" '((lambda () (interactive) (visual-line-mode)) :wk "visual line")
    "ts" '(hydra-text-scale/body :which-key "scale text")

    "w" '(:ignore t :which-key "window")
    "wl"  'windmove-right
    "wh"  'windmove-left
    "wk"  'windmove-up
    "wj"  'windmove-down
    "wd"  'delete-window
    "wu" 'winner-undo
    "wr" 'winner-redo
    "wm"  '(delete-other-windows :wk "maximize")

    "[d" 'diff-hl-previous-hunk
    "]d" 'diff-hl-next-hunk
    )

  (my/local-leader-keys
    "d" '(:ignore t :which-key "debug")
    "e" '(:ignore t :which-key "eval")
    "t" '(:ignore t :which-key "test")
    )
  )

;; suppercharge `Shift-K`
(use-package helpful
  :after evil
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :init
  (setq evil-lookup-func #'helpful-at-point)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package eldoc
  :hook (emacs-lisp-mode cider-mode))

(use-package all-the-icons)

;; I use `dwm` terminal which has different default font size
;; (if IS-LINUX (setq my-font (font-spec :family "Liberation Mono" :size 10.5)))
(defvar my/default-font-name "Liberation Mono")
(defvar my/default-font-size 100)
(defvar my/default-variable-font-name "Cantarell")
(defvar my/default-variable-font-size 105)

(cond (IS-MAC (setq my/default-font-name "Monaco"
                    my/default-font-size 120
                    my/default-variable-font-name "Tahoma"
                    my/default-variable-font-size 125
                   )))

(set-face-attribute 'default nil :font my/default-font-name :height my/default-font-size)
(set-face-attribute 'fixed-pitch nil :font my/default-font-name :height my/default-font-size)
(set-face-attribute 'variable-pitch nil :font my/default-variable-font-name :height my/default-variable-font-size :weight 'regular)

(use-package doom-themes
  :demand
  :config (load-theme 'doom-gruvbox t))

(use-package doom-modeline
  :demand
  :init
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-env-enable-python nil)
  (setq doom-modeline-height 15)
  :config
  (doom-modeline-mode 1))

(use-package hide-mode-line
  :commands (hide-mode-line-mode))

(use-package which-key
  :demand t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  ;; (setq which-key-idle-delay 0.5)
  :config
  (which-key-mode))

(use-package evil
  :demand t
  :general
  (my/leader-keys
    "wv" 'evil-window-vsplit
    "ws" 'evil-window-split)
  :init
  (setq evil-want-keybinding nil)
  ;; (setq evil-want-C-u-scroll t)
  (setq evil-want-Y-yank-to-eol t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  )

(use-package evil-collection
  :after evil
  :demand
  :config
  (evil-collection-init)
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer
    "q" 'quit-window)
  )

(use-package evil-commentary
  :demand
  :config
  (evil-commentary-mode))

;; column alignment like easy-alignment
(use-package evil-lion
  :config
  (evil-lion-mode))

;; multiple cursors
(use-package evil-mc
  :commands (evil-mc-make-and-goto-next-match ;C-n
             evil-mc-make-and-goto-prev-match ;C-p
             evil-mc-make-cursor-here ; grh
             evil-mc-undo-all-cursors ; grq
             evil-mc-make-all-cursors ; grm
             evil-mc-make-cursor-move-next-line ; grj
             evil-mc-make-cursor-move-prev-line ; grk
             )
  :config
  (global-evil-mc-mode +1)
  )

(use-package evil-surround
  :general
  (:states 'visual
           "S" 'evil-surround-region
           "gS" 'evil-Surround-region))

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

(use-package ranger
  :config
  (setq ranger-show-hidden t))

(use-package vterm
  :general
  (my/leader-keys
    "'" 'vterm-other-window)
  :config
  (setq ;; vterm-shell (executable-find "fish")
   vterm-max-scrollback 10000))

(use-package dired
  :straight nil
  :ensure nil
  :bind (("C-x C-j" . dired-jump)
         ("C-x 4 C-j" . dired-jump-other-window))
  :custom ((dired-listing-switches "-agho --group-directories-first")))

(use-package dired-single
  :after dired)

(use-package dired-open
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

;; is this still need if using counsel?
(use-package deadgrep
  :config
  (global-set-key (kbd "<f5>") #'deadgrep))

(use-package diminish)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         ("C-c C-r" . ivy-resume)
         ("<f6>" . ivy-resume)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (ivy-mode 1))

;; counsel includes 3 packages: counsel, swiper and ivy
(use-package counsel
  :bind (("M-x" . 'counsel-M-x)
         ("C-M-j" . 'counsel-switch-buffer)
         ("C-x C-f" . 'counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  ;; enable this if you want `swiper' to use it
  ;; (setq search-default-mode #'char-fold-to-regexp)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c c") 'counsel-compile)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c G") 'counsel-git-grep)
  (global-set-key (kbd "C-c L") 'counsel-git-log)
  (global-set-key (kbd "C-c k") 'counsel-rg)
  (global-set-key (kbd "C-c m") 'counsel-linux-app)
  (global-set-key (kbd "C-c n") 'counsel-fzf)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (counsel-mode 1))

;; ivy-rich needed to load after counsel
(use-package ivy-rich
  :after counsel
  :config
  (ivy-rich-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Uncomment the following line to have sorting remembered across sessions!
  ;;(prescient-persist-mode 1)
  (ivy-prescient-mode 1))

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

(use-package wgrep)

(use-package magit			; evil-magit is now part of evil-collection
  :general
  (my/leader-keys
    "g g" 'magit-status
    "g G" 'magit-status-here
    "g l" '(magit-log :wk "log"))
  :init
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (setq magit-log-arguments '("--graph" "--decorate" "--color")))

(if IS-LINUX (use-package evil-magit	; but gccemacs linux still requires it
               :after magit))

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge :after magit)

(use-package git-timemachine
  :hook (git-time-machine-mode . evil-normalize-keymaps)
  :init (setq git-timemachine-show-minibuffer-details t)
  :general
  (general-nmap "SPC g t" 'git-timemachine-toggle)
  (git-timemachine-mode-map "C-k" 'git-timemachine-show-previous-revision)
  (git-timemachine-mode-map "C-j" 'git-timemachine-show-next-revision)
  (git-timemachine-mode-map "q" 'git-timemachine-quit)
  )

;; (use-package git-gutter-fringe
;;   :hook
;;   ((text-mode
;;     org-mode
;;     prog-mode) . git-gutter-mode)
;;   :config
;;   (setq-default fringes-outside-margins t)
;;   )

;; diff-hl is a newer package
(use-package diff-hl
  :hook
  (((text-mode org-mode prog-mode) . diff-hl-mode)
   (magit-pre-refresh . diff-hl-magit-pre-refresh)
   (magit-post-refresh . diff-hl-magit-post-refresh))
  :init
  (setq diff-hl-draw-borders nil)
  )

(use-package persistent-scratch
  :demand
  :config
  (persistent-scratch-setup-default))

(use-package company
  :demand
  :bind
  (:map company-active-map
        ("<tab>" . company-complete-selection))
  :init
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.0)
  (setq company-backends '(company-capf company-dabbrev-code company-keywords company-files company-dabbrev))
  :config
  (global-company-mode))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package envrc
  :hook ((python-mode . envrc-mode)
         (org-mode . envrc-mode)))

(use-package projectile
  :demand
  :general
  (my/leader-keys
    "p" '(:keymap projectile-command-map :which-key "projectile")
    "p a" 'projectile-add-known-project
    "p t" 'projectile-run-vterm)
  :init
  (when (file-directory-p "~/git")
    (setq projectile-project-search-path '("~/git")))
  (setq projectile-completion-system 'default)
  (setq projectile-switch-project-action #'projectile-find-file)
  (setq projectile-project-root-files '("Dockerfile" "pyproject.toml" "project.clj" "deps.edn"))
  ;; (add-to-list 'projectile-globally-ignored-directories "straight") ;; TODO
  :config
  (defadvice projectile-project-root (around ignore-remote first activate)
    (unless (file-remote-p default-directory) ad-do-it))
  (projectile-mode))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package dashboard
  :after projectile
  :demand
  :init
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  (setq dashboard-center-content t)
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          ;; (agenda . 5)
                          ))
  ;; (setq dashboard-startup-banner [VALUE])
  :config
  (dashboard-setup-startup-hook)
  )

(use-package perspective
  :general
  (my/leader-keys
    "<tab> <tab>" 'persp-switch
    "<tab> `" 'persp-switch-last
    "<tab> d" 'persp-kill)
  :config
  (persp-mode))

(use-package persp-projectile
  :general
  (my/leader-keys
    "p p" 'projectile-persp-switch-project))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("=" (text-scale-set 0) "default")
  ("f" nil "finished" :exit t))

(use-package smerge-mode
  :straight nil
  :ensure nil
  :after hydra
  :general
  (my/leader-keys "g m" 'hydra-smerge)
  :init
  (defhydra hydra-smerge (:hint nil
                                :pre (smerge-mode 1)
                                ;; Disable `smerge-mode' when quitting hydra if
                                ;; no merge conflicts remain.
                                :post (smerge-auto-leave))
    "
                                                                ╭────────┐
              Movement   Keep           Diff              Other │ smerge │
              ╭─────────────────────────────────────────────────┴────────╯
                 ^_g_^       [_b_] base       [_<_] upper/base    [_C_] Combine
                 ^_C-k_^     [_u_] upper      [_=_] upper/lower   [_r_] resolve
                 ^_k_ ↑^     [_l_] lower      [_>_] base/lower    [_R_] remove
                 ^_j_ ↓^     [_a_] all        [_H_] hightlight
                 ^_C-j_^     [_RET_] current  [_E_] ediff             ╭──────────
                 ^_G_^                                            │ [_q_] quit"
    ("g" (progn (goto-char (point-min)) (smerge-next)))
    ("G" (progn (goto-char (point-max)) (smerge-prev)))
    ("C-j" smerge-next)
    ("C-k" smerge-prev)
    ("j" next-line)
    ("k" previous-line)
    ("b" smerge-keep-base)
    ("u" smerge-keep-upper)
    ("l" smerge-keep-lower)
    ("a" smerge-keep-all)
    ("RET" smerge-keep-current)
    ("\C-m" smerge-keep-current)
    ("<" smerge-diff-base-upper)
    ("=" smerge-diff-upper-lower)
    (">" smerge-diff-base-lower)
    ("H" smerge-refine)
    ("E" smerge-ediff)
    ("C" smerge-combine-with-next)
    ("r" smerge-resolve)
    ("R" smerge-kill-current)
    ("q" nil :color blue)))

(use-package yasnippet
  :hook
  ((text-mode . yas-minor-mode)
   (prog-mode . yas-minor-mode)
   (org-mode . yas-minor-mode)))

(use-package centaur-tabs
  :hook (emacs-startup . centaur-tabs-mode)
  :general
  (general-nvmap "gt" 'centaur-tabs-forward)
  (general-nvmap "gT" 'centaur-tabs-backward)
  :init
  (setq centaur-tabs-set-icons t)
  :config
  (centaur-tabs-mode t)
  (centaur-tabs-group-by-projectile-project)
  )

(use-package centered-cursor-mode
  :general (my/leader-keys "t -" (lambda () (interactive) (centered-cursor-mode 'toggle))))

;; turn on flycheck-mode on demand, global-flycheck-mode is a bit too much, do I still need flycheck if used lsp-mode?
(use-package flycheck)

;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
;; (setq lsp-keymap-prefix "s-l")
;; (setq lsp-keymap-prefix "C-c l")

;; (defun my/lsp-mode-setup ()
;;   (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
;;   (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  ;; :hook (lsp-mode . my/lsp-mode-setup)
  :general
  (my/leader-keys
    "l" '(:keymap lsp-command-map :which-key "lsp"))

  (lsp-mode-map "<tab>" 'company-indent-or-complete-common)
  :init
  (setq lsp-restart 'ignore)
  (setq lsp-eldoc-enable-hover nil)
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook ((lsp-mode . lsp-ui-mode))
  :init
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-ui-doc-show-with-mouse nil)
  )

;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

(use-package dap-mode
  :general
  (my/local-leader-keys
    :keymaps 'python-mode-map
    "d h" '(dap-hydra :wk "hydra"))
  :init
  (setq dap-auto-configure nil)
  :config
  (dap-ui-mode 1))
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

(use-package elisp-mode
  :straight nil
  :ensure nil
  :general
  (my/local-leader-keys
    :keymaps '(org-mode-map emacs-lisp-mode-map)
    "e l" '(eval-last-sexp :wk "last sexp"))
  (my/local-leader-keys
    :keymaps '(org-mode-map emacs-lisp-mode-map)
    :states 'visual
    "e" '(eval-last-sexp :wk "sexp")))

(use-package clojure-mode
  :mode "\\.clj$")

(use-package cider
  :commands (cider-jack-in cider-mode)
  :general
  ;; (clojure-mode-map "")
  :init
  (setq nrepl-hide-special-buffers t)
  :config
  (add-hook 'cider-mode-hook #'eldoc-mode))

(use-package nix-mode
  :commands (nix-mode) ;;FIXME
  :mode "\\.nix\\'")

;; expand the marked region in semantic increments (negative prefix to reduce region)
(use-package expand-region
  :config
  (global-set-key (kbd "C--") 'er/contract-region)
  (global-set-key (kbd "C-=") 'er/expand-region))

;; deletes all the whitespace when you hit backspace or delete
(use-package hungry-delete
  :config
  (global-hungry-delete-mode))

(use-package gnuplot)

(use-package org-roam)

(defun my/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font my/default-variable-font-name :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch))

;; from https://emacs.stackexchange.com/questions/20707/automatically-tangle-org-files-in-a-specific-directory
(defun my/org-babel-tangle-config ()
  "If the current file is in '~/dotfiles/common-home/', the code blocks are tangled"
  (when (equal (file-name-directory (directory-file-name buffer-file-name))
               (concat (getenv "HOME") "/dotfiles/common-home/.emacs.d/"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :init
  (setq org-superstar-headline-bullets-list '("✖" "✚" "◆" "▶" "○")
        org-superstar-special-todo-items t
        org-ellipsis "▼")
  )

;; (defun my/org-mode-visual-fill ()
;;   (setq visual-fill-column-width 100
;;         visual-fill-column-center-text t)
;;   (visual-fill-column-mode 1))

;; (use-package visual-fill-column
;;   :hook (org-mode . my/org-mode-visual-fill))

;; setup my org mode
(defun my/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :pin org
  :hook ((org-mode . my/org-mode-setup)
         (org-mode . (lambda () (add-hook 'after-save-hook #'my/org-babel-tangle-config))))
  :general
  (my/leader-keys
    "C" '(org-capture :wk "capture"))
  (org-mode-map
   :states '(normal)
   "z i" '(org-toggle-inline-images :wk "inline images"))
  ;; :init
  ;; (setq org-agenda-files "~/org-lam/lam-arch-notes.org"
  ;;       org-default-notes-file (concat org-directory "capture.org"))
  :config
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-directory "~/org-lam")

  (setq org-agenda-files
        '("~/org-lam/Tasks.org"
          "~/org-lam/Habits.org"
          "~/org-lam/Birthdays.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
        '(("Archive.org" :maxlevel . 1)
          ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
        '((:startgroup)
          ;; Put mutually exclusive tags here
          (:endgroup)
          ("@errand" . ?E)
          ("@home" . ?H)
          ("@work" . ?W)
          ("agenda" . ?a)
          ("planning" . ?p)
          ("publish" . ?P)
          ("batch" . ?b)
          ("note" . ?n)
          ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-deadline-warning-days 7)))
            (todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))
            (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

          ("n" "Next Tasks"
           ((todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))))

          ("W" "Work Tasks" tags-todo "+work-email")

          ;; Low-effort next actions
          ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
           ((org-agenda-overriding-header "Low Effort Tasks")
            (org-agenda-max-todos 20)
            (org-agenda-files org-agenda-files)))

          ("w" "Workflow Status"
           ((todo "WAIT"
                  ((org-agenda-overriding-header "Waiting on External")
                   (org-agenda-files org-agenda-files)))
            (todo "REVIEW"
                  ((org-agenda-overriding-header "In Review")
                   (org-agenda-files org-agenda-files)))
            (todo "PLAN"
                  ((org-agenda-overriding-header "In Planning")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "BACKLOG"
                  ((org-agenda-overriding-header "Project Backlog")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "READY"
                  ((org-agenda-overriding-header "Ready for Work")
                   (org-agenda-files org-agenda-files)))
            (todo "ACTIVE"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "COMPLETED"
                  ((org-agenda-overriding-header "Completed Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "CANC"
                  ((org-agenda-overriding-header "Cancelled Projects")
                   (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
        `(("t" "Tasks / Projects")
          ("tt" "Task" entry (file+olp "~/org-lam/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

          ("j" "Journal Entries")
          ("jj" "Journal" entry
           (file+olp+datetree "~/org-lam/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(my/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
          ("jm" "Meeting" entry
           (file+olp+datetree "~/org-lam/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

          ("w" "Workflows")
          ("we" "Checking Email" entry (file+olp+datetree "~/org-lam/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

          ("m" "Metrics Capture")
          ("mw" "Weight" table-line (file+headline "~/org-lam/Metrics.org" "Weight")
           "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  (my/org-font-setup)
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("clj" . "src clojure"))
  (add-to-list 'org-structure-template-alist '("jp" . "src jupyter-python"))
  )

;; configure babel languages
(use-package org
  :general
  (my/local-leader-keys
    :keymaps 'org-mode-map
    "," '(org-edit-special :wk "edit")
    "-" '(org-babel-demarcate-block :wk "split block"))
  (my/local-leader-keys
    :keymaps 'org-src-mode-map
    "," '(org-edit-src-exit :wk "exit")) ;;FIXME
  :init
  ;; (setq org-confirm-babel-evaluate nil)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t))))

;; (setq image-use-external-converter t)   ; not working yet
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
  ("C-M-]" . org-download-clipboard)
  :config)

;; ;; on-going issue: https://github.com/politza/pdf-tools/pull/588
;; ;; also refer to https://emacs.stackexchange.com/questions/13314/install-pdf-tools-on-emacs-macosx
;; (use-package pdf-tools
;;   :config
;;   (pdf-tools-install)
;;   (setq-default pdf-view-display-size 'fit-width)
;;   (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
;;   :custom
;;   (pdf-annot-activate-created-annotations t "automatically annotate highlights"))

;; ;; original from http://alberto.am/2020-04-11-pdf-tools-as-default-pdf-viewer.html
;; (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
;;       TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
;;       TeX-source-correlate-start-server t)

;; (add-hook 'TeX-after-compilation-finished-functions
;; 	  #'TeX-revert-document-buffer)

;; (add-hook 'pdf-view-mode-hook (lambda() (linum-mode -1)))

;; (use-package org-pdftools
;;   :after org)

;; from https://zzamboni.org/post/my-emacs-configuration-with-commentary/
(use-package adoc-mode
  :mode "\\.asciidoc\\'"
  :hook
  (adoc-mode . visual-line-mode)
  (adoc-mode . variable-pitch-mode))

(use-package markdown-mode
  :hook
  (markdown-mode . visual-line-mode)
  (markdown-mode . variable-pitch-mode))

;; ===
(setq startup-time-toc (current-time))
(setq startup-time-seconds
      (time-to-seconds (time-subtract startup-time-toc startup-time-tic)))

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "LamT"
      user-mail-address "lamtt77@gmail.com")

;; List of gpg keys for file encryption here, else doom will scan for all
;; available 'Encrypt' keys in the key-ring
;; lamtt77@gmail.com and lam@lamhub.com
;; (setq epa-file-encrypt-to '("0xA332D9C1F057A785" "0x1AEB38F471BDE5B2"))
(setq epa-file-encrypt-to '("0xA332D9C1F057A785"))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(if IS-LINUX (setq doom-font (font-spec :family "Liberation Mono" :size 10.5)))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org-lam/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Restore right-option as meta changed by doom-emacs https://github.com/hlissner/doom-emacs/issues/4178
(setq mac-right-option-modifier 'meta
      ns-right-option-modifier  'meta)

;; LamT - tramp slowness issue, does not seem to get improved
;; (setq remote-file-name-inhibit-cache nil)
;; (setq vc-ignore-dir-regexp
;;       (format "%s\\|%s"
;;                     vc-ignore-dir-regexp
;;                     tramp-file-name-regexp))
;;
;; set verbose to 10 in rare case
;; (setq tramp-verbose 6)
;; (eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

;; Fix my zsh custom prompt (z4h) issue as per tramp hangs #6: https://www.emacswiki.org/emacs/TrampMode
(setq tramp-shell-prompt-pattern "\\(?:^\\|\\)[^]#$%>\n]*#?[]#$%>].* *\\(\\[[[:digit:];]*[[:alpha:]] *\\)*")

;; C-s: Control-Super or Control-Command on Mac, a bit easier to press than Doom's default C-S-j/k for scrolling down/up minibuffer
;; (after! vertico
;;   (define-key vertico-map (kbd "C-s-j") #'vertico-scroll-up)
;;   (define-key vertico-map (kbd "C-s-k") #'vertico-scroll-down))
;;
;; A bit more universal with this approach
(when (featurep! :editor evil +everywhere)
  (define-key! :keymaps +default-minibuffer-maps
    "C-s-j"  #'scroll-up-command
    "C-s-k"  #'scroll-down-command))

;; I use back-tick quite often, so change the default org cdlatex-math-symbol from back-tick to C-M-`, :i is for insert state
(after! cdlatex
  (map! :map org-cdlatex-mode-map
        "`"     nil
        :i "C-M-`" #'cdlatex-math-symbol))

;; testing eglot & clangd
;; (set-eglot-client! 'cc-mode '("clangd" "-j=3" "--clang-tidy"))

;; from https://www.reddit.com/r/DoomEmacs/comments/jl6p9x/whitespacemode/
;; LamT: FIXME this will get doom's default whitespace-mode broken
(defun me:see-all-whitespace () (interactive)
       (setq whitespace-style (default-value 'whitespace-style))
       (setq whitespace-display-mappings (default-value 'whitespace-display-mappings))
       (whitespace-mode 'toggle))
(global-set-key (kbd "C-<f4>") 'me:see-all-whitespace)

;; if do not like to load ranger by default
;; (ranger-override-dired-mode nil)
;; (setq ranger-show-hidden t)
;; (setq ranger-cleanup-on-disable t)
;; (setq ranger-cleanup-eagerly t)

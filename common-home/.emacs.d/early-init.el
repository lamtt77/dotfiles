;; in ~/.emacs.d/init.el (or ~/.emacs.d/early-init.el in Emacs 27)
;; performance tuning tips
(setq package-enable-at-startup nil ; don't auto-initialize!
      ;; don't add that `custom-set-variables' block to my init.el!
      package--init-file-ensured t)

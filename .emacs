
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(load "~/.emacs.d/custom/init.el")
(if (file-exists-p "~/.emacs.d/custom_local/init.el")
    (load "~/.emacs.d/custom_local/init.el"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-strict-trailing-comma-warning nil)
 '(package-archives
   (quote
    (("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/"))))
 '(package-selected-packages
   (quote
    (rjsx-mode helm-ag with-editor yasnippet yaml-mode web-mode toml-mode toml thrift smartparens robe rbenv rainbow-mode projectile powerline pig-mode php-mode pallet multiple-cursors multi-term moe-theme markdown-mode magit linum-off kill-ring-search jsx-mode js2-mode highlight-indentation helm-open-github helm-ls-git helm-git-grep helm-codesearch helm-cmd-t grizzl goto-last-change find-things-fast find-file-in-repository find-file-in-project exec-path-from-shell enh-ruby-mode dash-at-point crontab-mode company color-theme coffee-mode auto-complete ag)))
 '(safe-local-variable-values
   (quote
    ((eval setq flycheck-command-wrapper-function
           (lambda
             (command)
             (append
              (quote
               ("bundle" "exec"))
              command))))))
 '(tls-checktrust t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

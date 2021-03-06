(require 'cask "~/.cask/cask.el")
(cask-initialize)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(let ((trustfile
       (replace-regexp-in-string
        "\\\\" "/"
        (replace-regexp-in-string
         "\n" ""
         (shell-command-to-string "python -m certifi")))))
  (setq tls-program
        (list
         (format "gnutls-cli%s --x509cafile %s -p %%p %%h"
                 (if (eq window-system 'w32) ".exe" "") trustfile))))

(require 'pallet)
(pallet-mode t)

(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

(define-key my-keys-minor-mode-map (kbd "C-.") 'ska-point-to-register)
(define-key my-keys-minor-mode-map (kbd "C-,") 'ska-jump-to-register)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t "my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)
;; Helm
(require 'helm)
(require 'helm-ls-git)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-y") 'helm-M-x)
(global-set-key (kbd "C-x C-r") 'helm-recentf)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)
(define-key my-keys-minor-mode-map (kbd "C-c C-y") 'helm-M-x)
;; (define-key my-keys-minor-mode-map (kbd "C-c C-r") 'helm-recentf)
(define-key my-keys-minor-mode-map (kbd "C-c C-s") 'helm-occur)

(define-key my-keys-minor-mode-map (kbd "C-c g") 'helm-git-grep)
(define-key my-keys-minor-mode-map (kbd "C-c C-g") 'helm-git-grep-at-point)
(define-key my-keys-minor-mode-map (kbd "C-c C-g") 'helm-git-grep-at-point)

(define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)
(eval-after-load 'helm
  '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm))
(add-hook 'dired-mode-hook (lambda () (helm-mode -1)))

(setq helm-ls-git-show-abs-or-relative 'relative)
(setq helm-ls-git-fuzzy-match t)

(setq standard-indent 2)

(require 'powerline)
(require 'moe-theme)
(moe-dark)
(powerline-moe-theme)
(setq powerline-display-buffer-size nil)
(setq-default mode-line-format
              '("%e"
                (:eval
                 (let*
                     ((active
                       (powerline-selected-window-active))
                      (mode-line
                       (if active 'mode-line 'mode-line-inactive))
                      (face1
                       (if active 'powerline-active1 'powerline-inactive1))
                      (face2
                       (if active 'powerline-active2 'powerline-inactive2))
                      (separator-left
                       (intern
                        (format "powerline-%s-%s"
                                (powerline-current-separator)
                                (car powerline-default-separator-dir))))
                      (separator-right
                       (intern
                        (format "powerline-%s-%s"
                                (powerline-current-separator)
                                (cdr powerline-default-separator-dir))))
                      (lhs
                       (list
                        (powerline-raw "%*" nil 'l)
                        (when powerline-display-buffer-size
                          (powerline-buffer-size nil 'l))
                        (when powerline-display-mule-info
                          (powerline-raw mode-line-mule-info nil 'l))
                        (powerline-buffer-id nil 'l)
                        (when
                            (and
                             (boundp 'which-func-mode)
                             which-func-mode)
                          (powerline-raw which-func-format nil 'l))
                        (powerline-raw " ")
                        (funcall separator-left mode-line face1)
                        (when
                            (boundp 'erc-modified-channels-object)
                          (powerline-raw erc-modified-channels-object face1 'l))
                        (powerline-major-mode face1 'l)
                        (powerline-process face1)
                        ;; (powerline-minor-modes face1 'l)
                        (powerline-narrow face1 'l)
                        (powerline-raw " " face1)
                        (funcall separator-left face1 face2)
                        ;; (powerline-vc face2 'r)
                        (when
                            (bound-and-true-p nyan-mode)
                          (powerline-raw
                           (list
                            (nyan-create))
                           face2 'l))))
                      (rhs
                       (list
                        (powerline-raw global-mode-string face2 'r)
                        (funcall separator-right face2 face1)
                        ;; (unless window-system
                        ;;   (powerline-raw
                        ;;    (char-to-string 57505)
                        ;;    face1 'l))
                        (powerline-raw "%4l" face1 'l)
                        (powerline-raw ":" face1 'l)
                        (powerline-raw "%3c" face1 'r)
                        (funcall separator-right face1 mode-line)
                        (powerline-raw " ")
                        (powerline-raw "%6p" nil 'r)
                        (when powerline-display-hud
                          (powerline-hud face2 face1)))))
                   (concat
                    (powerline-render lhs)
                    (powerline-fill face2
                                    (powerline-width rhs))
                    (powerline-render rhs))))))

(setq ns-use-srgb-colorspace nil)
; (desktop-save-mode 1)

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)
(setq split-height-threshold 120)

;; Determine where we are
(defvar on_darwin
  (string-match "darwin" (prin1-to-string system-type)))

(defvar on_gnu_linux
  (string-match "gnu/linux" (prin1-to-string system-type)))

(defvar on_X
  (string-match "x" (prin1-to-string window-system)))

(defvar on_Terminal
  (string-match "nil" (prin1-to-string window-system)))

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;;25functions.el

(defun recentf-open-files-compl ()
  (interactive)
  (let* ((all-files recentf-list)
	 (tocpl (mapcar (function
			 (lambda (x) (cons (file-name-nondirectory x) x))) all-files))
	 (prompt (append '("File name: ") tocpl))
	 (fname (completing-read (car prompt) (cdr prompt) nil nil)))
    ;; (find-file (cdr (assoc-ignore-representation fname tocpl)))))
    (find-file (cdr (assoc-string fname tocpl)))))
;; (global-set-key (kbd "C-x C-r") 'recentf-open-files-compl)
;; (global-set-key (kbd "C-c C-r") 'recentf-open-files-compl)

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))
(global-set-key "%" 'match-paren)

(defun wy-go-to-char (n char)
  "Move forward to Nth occurence of CHAR.
Typing `wy-go-to-char-key' again will move forwad to the next Nth
occurence of CHAR."
  (interactive "p\ncGo to char: ")
  (search-forward (string char) nil nil n)
  (while (char-equal (read-char)
		     char)
    (search-forward (string char) nil nil n))
  (setq unread-command-events (list last-input-event)))
(define-key global-map (kbd "C-c f") 'wy-go-to-char) ;; go-to-char

(defun ai-insert-date ()
  (interactive)
  (insert (format-time-string "%Y/%m/%d %H:%M:%S" (current-time))))
(global-set-key (kbd "C-c d") 'ai-insert-date)

(defun ska-point-to-register()
  "Store cursorposition _fast_ in a register.
Use ska-jump-to-register to jump back to the stored
position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))

(defun ska-jump-to-register()
  "Switches between current cursorposition and position
that was stored with ska-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
    (jump-to-register 8)
    (set-register 8 tmp)))

;; 25keybindings.el
;; Costomized key bindings
;; Effective Emacs
;; (global-set-key "\C-x\C-y" 'execute-extended-command)
;; (global-set-key "\C-c\C-y" 'execute-extended-command)
;; (global-set-key "\C-c\C-f" 'ido-find-file)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)

(global-set-key "\r" 'newline-and-indent)

(global-set-key (kbd "M-`") 'other-window) ; prefer this to C-x o
(global-set-key (kbd "M-~") '(lambda () (interactive) (other-window -1)))
(global-set-key (kbd "C-x /") 'comment-or-uncomment-region)

;; 25modes.el

;; go to last edit location (super useful)
(require 'goto-last-change)
(global-set-key (kbd "C-\\") 'goto-last-change)

(require 'ido)
(ido-mode t)
(setq ido-everywhere t)
;; (iswitchb-mode 0)
;; (defun iswitchb-local-keys ()
;;   (mapc (lambda (K)
;;           (let* ((key (car K)) (fun (cdr K)))
;;             (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
;;         '(("<right>" . iswitchb-next-match)
;;           ("<left>"  . iswitchb-prev-match)
;;           ("<up>"    . ignore             )
;;           ("<down>"  . ignore             ))))
;; (add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq linum-format "%4d")
(cond (on_Terminal
       (progn
	 (setq linum-format "%4d| "))))

(global-linum-mode 1)
(require 'linum-off)

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 500)

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq js-indent-level 2)

(setq css-indent-offset 2)

;; 50dired.el
(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)
(require 'dired-x)
(global-set-key (kbd "C-x j") 'dired-jump)
(global-set-key (kbd "C-c j") 'dired-jump)

;; 50misc.el
(setq visible-bell 1) (setq ring-bell-function 'ignore)

(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'text-mode-hook-identify)

(setq kill-ring-max 1000)
(setq enable-recursive-minibuffers t)
(setq scroll-margin 3
      scroll-conservatively 10000)
(show-paren-mode t)
(setq show-paren-style 'parentheses)

(setq line-number-mode t)
(setq column-number-mode t)

(global-font-lock-mode t)

(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")
(global-set-key (kbd "C-M-g") 'magit-status)

(setq-default fill-column 80)

;; smart split
(defun smart-split ()
  "Split the frame into exactly as many (fill-column)-column sub-windows as
   possible."
  (interactive)
  (defun ordered-window-list ()
    "Get the list of windows in the selected frame, starting from
	 the one at the top left."
    (window-list (selected-frame) (quote no-minibuf) (frame-first-window)))
  (defun resize-windows-destructively (windows)
    "Resize each window in the list to be (fill-column) characters wide. If
	 there is not enough space to do that, delete the appropriate
	 window until there is space."
    (when windows
      (condition-case error
	  (progn
	    (adjust-window-trailing-edge
	     (first windows)
             (- fill-column (window-width (first windows))) t)
	    (resize-windows-destructively (cdr windows)))
	(error
	 (if (cdr windows)
	     (progn
	       (delete-window (cadr windows))
	       (resize-windows-destructively
		(cons (car windows) (cddr windows))))
	   (ignore-errors
	     (delete-window (car windows))))))))
  (defun subsplit (w)
    "If the given window can be split into multiple (fill-column)-column
         windows, do it."
    (when (> (window-width w) (* 2 (+ fill-column 1)))
      (let ((w2 (split-window w (+ fill-column 1) t)))
	(save-excursion
	  (select-window w2)
	  (switch-to-buffer (other-buffer (window-buffer w))))
	(subsplit w2))))
  (delete-other-windows)
  (resize-windows-destructively (ordered-window-list))
  (walk-windows (quote subsplit))
  (balance-windows))
(smart-split)
(defalias 's 'smart-split)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Multiple window keybindings
(global-set-key (kbd "<C-up>") 'windmove-up)
(global-set-key (kbd "<C-down>") 'windmove-down)
(global-set-key (kbd "<C-left>") 'windmove-left)
(global-set-key (kbd "<C-right>") 'windmove-right)

(global-auto-revert-mode t)

;; ;; Highlight-current-line
;; (add-to-list 'load-path "~sxie/.emacs.d/highlight-current-line")
;; (require 'highlight-current-line)
;; (highlight-current-line-on nil)

;; ;; To customize the background color
;; (set-face-background 'highlight-current-line-face "magenta")

;; (global-hl-line-mode nil)

;; To customize the background color
;; (set-face-background 'hl-line "#330")  ;; Emacs 22 Only

(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist '(("." . "~/.saves"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups
;; (setq make-backup-files nil) ; stop creating those backup~ files
;; (setq auto-save-default nil) ; stop creating those #autosave# files

(global-auto-revert-mode 1)

(require 'whitespace)
(setq-default whitespace-line-column fill-column) ;; limit line length
(setq-default whitespace-style '(face lines-tail tailing))

(setq-default show-trailing-whitespace t)
(add-hook 'prog-mode-hook 'whitespace-mode)
;; (add-hook 'jsx-mode-hook 'whitespace-mode)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

(require 'php-mode)

;; (electric-indent-mode +1)

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)
(setq ispell-program-name "/usr/local/bin/ispell")
(global-set-key (kbd "s-:") 'ispell-word)

(set-fontset-font t 'han (font-spec :name "Songti SC"))

(require 'yasnippet)
(yas-global-mode 1)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-dabbrev-downcase nil)
(setq company-dabbrev-ignore-case t)
(add-to-list 'company-backends 'company-tern)
(global-set-key (kbd "M-/") 'company-complete)

;; flyspell
(require 'flyspell)
(setq flyspell-issue-message-flg nil)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(defun my-flyspell-mode-hook ()
  (define-key flyspell-mode-map (kbd "C-.") 'ska-point-to-register)
  (define-key flyspell-mode-map (kbd "C-,") 'ska-jump-to-register))
(add-hook 'flyspell-mode-hook 'my-flyspell-mode-hook)

;; Projectile
(require 'grizzl)
(projectile-global-mode)
(setq projectile-enable-caching t)
(setq projectile-completion-system 'grizzl)
;; Press Command-p for fuzzy find in project
(global-set-key (kbd "C-c C-p") 'projectile-find-file)
;; Press Command-b for fuzzy switch buffer
(global-set-key (kbd "C-c C-b") 'projectile-switch-to-buffer)
;; Press Command-a for Ag search
(global-set-key (kbd "C-c C-a") 'projectile-ag)

(require 'fzf)
(global-set-key (kbd "C-c C-f") 'fzf)

;; find-file-in-project
;; (autoload 'find-file-in-project "find-file-in-project" nil t)
;; (autoload 'find-file-in-project-by-selected "find-file-in-project" nil t)
;; (autoload 'find-directory-in-project-by-selected "find-file-in-project" nil t)
;; (autoload 'ffip-show-diff "find-file-in-project" nil t)
;; (autoload 'ffip-save-ivy-last "find-file-in-project" nil t)
;; (autoload 'ffip-ivy-resume "find-file-in-project" nil t)

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(setq web-mode-engines-alist
      '(("erb"    . "\\.html.erb\\'")))

(setq js-switch-indent-offset 2)
(setq js2-mode-show-parse-errors nil)
(setq js2-mode-show-strict-warnings nil)

(require 'js2-refactor)
(require 'xref-js2)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
;; (define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook (lambda ()
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

(defun my-web-mode-hook ()
  ;; Press Command-p for fuzzy find in project
  (define-key web-mode-map (kbd "C-c C-p") 'projectile-find-file)
  ;; Press Command-b for fuzzy switch buffer
  (define-key web-mode-map (kbd "C-c C-b") 'projectile-switch-to-buffer)
  ;; Press Command-a for Ag search
  (define-key web-mode-map (kbd "C-c C-a") 'projectile-ag)

  (define-key web-mode-map (kbd "C-c a b") 'web-mode-attribute-beginning)
  (define-key web-mode-map (kbd "C-c a e") 'web-mode-attribute-end)
  (define-key web-mode-map (kbd "C-c a i") 'web-mode-attribute-insert)
  (define-key web-mode-map (kbd "C-c a n") 'web-mode-attribute-next)
  (define-key web-mode-map (kbd "C-c a s") 'web-mode-attribute-select)
  (define-key web-mode-map (kbd "C-c a k") 'web-mode-attribute-kill)
  (define-key web-mode-map (kbd "C-c a p") 'web-mode-attribute-previous)
  (define-key web-mode-map (kbd "C-c a t") 'web-mode-attribute-transpose)

  (define-key web-mode-map (kbd "C-c b b") 'web-mode-block-beginning)
  (define-key web-mode-map (kbd "C-c b c") 'web-mode-block-close)
  (define-key web-mode-map (kbd "C-c b e") 'web-mode-block-end)
  (define-key web-mode-map (kbd "C-c b k") 'web-mode-block-kill)
  (define-key web-mode-map (kbd "C-c b n") 'web-mode-block-next)
  (define-key web-mode-map (kbd "C-c b p") 'web-mode-block-previous)
  (define-key web-mode-map (kbd "C-c b s") 'web-mode-block-select)
  (setq web-mode-attr-value-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-indent-style 2))

(add-hook 'web-mode-hook 'my-web-mode-hook)

;; RJSX mode
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
(defun my-js2-mode-hook ()
  ;; Press Command-a for Ag search
  (define-key js2-mode-map (kbd "C-c C-a") nil)
  (define-key js2-mode-map (kbd "C-c C-f") nil)
)
(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;; flycheck
(require 'flycheck)
;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)
;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

;; (add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
;; (autoload 'jsx-mode "jsx-mode" "JSX mode" t)
;; (setq jsx-indent-level 2)

;; highlight-indentation
(require 'highlight-indentation)
(add-hook 'enh-ruby-mode-hook
	  (lambda () (highlight-indentation-current-column-mode)))

(add-hook 'coffee-mode-hook
	  (lambda () (highlight-indentation-current-column-mode)))

;; ;; smoartparens
;; (require 'smartparens-config)
;; (require 'smartparens-ruby)
;; (smartparens-global-mode)
;; (show-smartparens-global-mode t)
;; (sp-with-modes '(rhtml-mode)
;;   (sp-local-pair "<" ">")
;;   (sp-local-pair "<%" "%>"))

;; pig-mode
(require 'pig-mode)

;; hive
(add-to-list 'auto-mode-alist '("\\.hql\\'" . sql-mode))

;; uniquify
(require 'uniquify)
(setq
  uniquify-buffer-name-style 'post-forward
  uniquify-separator "|")

(setq-default indent-tabs-mode nil)

(require 'multi-term)
(defun multi-term-dedicated-toggle-and-select ()
  "Toggle the `multi-term` dedicated. If opened, select it."
  (interactive)
  (multi-term-dedicated-toggle)
  (if (multi-term-dedicated-exist-p)
      (multi-term-dedicated-select)))
(global-set-key (kbd "M-s-i") 'multi-term-dedicated-toggle-and-select)

(defun last-term-buffer (l)
  "Return most recently used term buffer."
  (when l
    (let ((w (car l)))
      (if (and
           (eq 'term-mode (with-current-buffer w major-mode))
           (not (equal (multi-term-dedicated-get-buffer-name) (buffer-name w))))
          w (last-term-buffer (cdr l))))))

(defun get-term ()
  "Switch to the term buffer last used, or create a new one if
    none exists, or if the current buffer is already a term."
  (interactive)
  (let ((b (last-term-buffer (buffer-list))))
    (if (or (not b) (and (eq 'term-mode major-mode) (not (multi-term-dedicated-window-p))))
        (multi-term)
      (switch-to-buffer b))))
(global-set-key (kbd "C-`") 'get-term)

(setq toml-indent-level 2)

(defun trim-string (string)
  "Remove white spaces in beginning and ending of STRING.
White space here is any of: space, tab, emacs newline (line feed, ASCII 10)."
  (replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string)))

;; Open github pages from files
(defun browse-on-github ()
  "Show the current file on github"
  (interactive)
  (let* ((full-path (mapconcat 'identity `("~/bin/gitopener" ,(buffer-file-name)) " "))
         (line-no (number-to-string (1+ (count-lines 1 (point)))))
         (file-url (trim-string (shell-command-to-string full-path)))
         (result-url (concat file-url "#L" line-no)))
    (message result-url)
    (browse-url result-url)))

(define-key my-keys-minor-mode-map (kbd "C-c C-o") 'browse-on-github)

(setq python-indent-offset 2)

;; Load other files
(defun load-local (filename)
  (load (expand-file-name
         (concat "custom/" filename ".el")
         user-emacs-directory)))

(load-local "01ruby")
; (load-file "~/.emacs.d/flow-for-emacs/flow.el")

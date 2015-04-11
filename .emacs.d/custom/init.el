(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

(let ((default-directory "~/.emacs.d/site-lisp/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

(require 'moe-theme)
(moe-dark)

; (desktop-save-mode 1)

(setq inhibit-startup-message t)
(tool-bar-mode -1)
;; (toggle-frame-fullscreen)

;; Determine where we are
(defvar on_darwin
  (string-match "darwin" (prin1-to-string system-type)))

(defvar on_gnu_linux
  (string-match "gnu/linux" (prin1-to-string system-type)))

(defvar on_X
  (string-match "x" (prin1-to-string window-system)))

(defvar on_Terminal
  (string-match "nil" (prin1-to-string window-system)))

;; color-theme
(require 'color-theme-wombat)
(color-theme-wombat)

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
(global-set-key (kbd "C-x C-r") 'recentf-open-files-compl)
(global-set-key (kbd "C-c C-r") 'recentf-open-files-compl)

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1))))) ;;À¨ºÅÆ¥Åä
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
(global-set-key "\C-x\C-y" 'execute-extended-command)
(global-set-key "\C-c\C-y" 'execute-extended-command)
(global-set-key "\C-c\C-f" 'ido-find-file)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)

(global-set-key "\r" 'newline-and-indent)
(global-set-key (kbd "C-\\") (quote shell))

(global-set-key (kbd "C-c g") 'gnus)

(global-set-key (kbd "M-`") 'other-window) ; prefer this to C-x o
(global-set-key (kbd "M-~") '(lambda () (interactive) (other-window -1)))
(global-set-key (kbd "C-x /") 'comment-or-uncomment-region) ; smart enough to toggle between commenting and uncommenting


;; 25modes.el

;; go to last edit location (super useful)
(require 'goto-last-change)
(global-set-key (kbd "C-c C-q") 'goto-last-change)

;; ;; tree representation of changes to to walk the undo/redo graph. "C-x u" to open tree for current file.
;; (require 'undo-tree)
;; (global-undo-tree-mode)

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

(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
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
(which-function-mode)

(setq line-number-mode t)
(setq column-number-mode t)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)

(global-font-lock-mode t)

(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")

;; (server-start)
;; (add-hook 'after-init-hook 'server-start)
;; (add-hook 'server-done-hook
;;           (lambda ()
;;             (shell-command
;;              "screen -r -X select `cat ~sxie/tmp/emacsclient-caller`")))

;; ;; ERC
;; (require 'tls)
;; (require 'erc)
;; (require 'erc-ring)
;; (require 'erc-services)
;; (require 'erc-fill)
;; ;; (require 'erc-autoaway)
;; (require 'erc-log)

;; ;; Logging
;; (setq erc-log-channels t
;;       erc-log-channels-directory "~sxie/logs/erc"
;;       erc-log-insert-log-on-open nil
;;       erc-log-write-after-send t
;;       erc-log-write-after-insert t
;;       erc-log-file-coding-system 'utf-8)
;; (erc-log-enable)
;; (erc-ring-enable)
;; (setq erc-save-buffer-on-part t)
;; (defadvice save-buffers-kill-emacs
;;   (before save-logs (arg) activate)
;;   (save-some-buffers t (lambda () (when (eq major-mode 'erc-mode) t))))

;; ;; Channel specific prompt
;; (setq erc-prompt (lambda ()
;;                    (if (and (boundp 'erc-default-recipients)
;;                             (erc-default-target))
;;                        (erc-propertize (concat (erc-default-target) ">")
;;                                        'read-only t
;;                                        'rear-nonsticky t
;;                                        'front-nonsticky t)
;;                      (erc-propertize (concat "ERC>")
;;                                      'read-only t
;;                                      'rear-nonsticky t
;;                                      'front-nonsticky t))))

;; ;; Automatically truncate buffer
;; (defvar erc-insert-post-hook)
;; (add-hook 'erc-insert-post-hook
;;           'erc-truncate-buffer)
;; (setq erc-truncate-buffer-on-save t)

;; ;; Spell check
;; (erc-spelling-mode 1)

;; (defun start-irc ()
;;   "Connect to IRC."
;;   (interactive)
;;   (erc-tls :server "irc.tfbnw.net" :port 6443
;;            :nick "sxie" :full-name "Song Xie")
;;   (setq erc-autojoin-channels-alist '(("tfbnw.net" "#bootcamp"))))
;; (start-irc)

(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)

;; smart split
(defun smart-split ()
  "Split the frame into exactly as many 80-column sub-windows as
   possible."
  (interactive)
  (defun ordered-window-list ()
    "Get the list of windows in the selected frame, starting from
	 the one at the top left."
    (window-list (selected-frame) (quote no-minibuf) (frame-first-window)))
  (defun resize-windows-destructively (windows)
    "Resize each window in the list to be 80 characters wide. If
	 there is not enough space to do that, delete the appropriate
	 window until there is space."
    (when windows
      (condition-case error
	  (progn
	    (adjust-window-trailing-edge
	     (first windows)
	     (- 80 (window-width (first windows))) t)
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
    "If the given window can be split into multiple 80-column
	 windows, do it."
    (when (> (window-width w) (* 2 81))
      (let ((w2 (split-window w 82 t)))
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

(set-fill-column 100)

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

(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

(define-key my-keys-minor-mode-map (kbd "C-.") 'ska-point-to-register)
(define-key my-keys-minor-mode-map (kbd "C-,") 'ska-jump-to-register)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t "my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

(setq-default fill-column 100)
(global-auto-revert-mode 1)

(require 'whitespace)
(setq-default whitespace-line-column 80) ;; limit line length
(setq-default whitespace-style '(face lines-tail tailing))

(setq-default show-trailing-whitespace t)

(add-hook 'prog-mode-hook 'whitespace-mode)
(add-hook 'before-save-hook 'whitespace-cleanup)

(require 'ws-trim)

(global-ws-trim-mode t)
(set-default 'ws-trim-level 1)
(setq ws-trim-global-modes '(guess (not message-mode eshell-mode)))
(add-hook 'ws-trim-method-hook 'joc-no-tabs-in-java-hook)

(defun joc-no-tabs-in-java-hook ()
  "WS-TRIM Hook to strip all tabs in Java mode only"
  (interactive)
  (if (string= major-mode "jde-mode")
      (ws-trim-tabs)))

(require 'php-mode)

;; (electric-indent-mode +1)

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)
(setq ispell-program-name "/usr/local/bin/ispell")
(global-set-key (kbd "s-:") 'ispell-word)

(set-fontset-font t 'han (font-spec :name "Songti SC"))

;; auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
	     "~/.emacsb.d/.cask/24.3.1/elpa/auto-complete-20140605.1908/dict")
(ac-config-default)
(setq ac-ignore-case nil)
(add-to-list 'ac-modes 'enh-ruby-mode)
(add-to-list 'ac-modes 'web-mode)

;; flyspell
(require 'flyspell)
(setq flyspell-issue-message-flg nil)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; flyspell mode breaks auto-complete mode without this.
(ac-flyspell-workaround)

;; Projectile
(require 'grizzl)
(projectile-global-mode)
;; (setq projectile-enable-caching t)
(setq projectile-completion-system 'grizzl)
;; Press Command-p for fuzzy find in project
(global-set-key (kbd "C-c C-p") 'projectile-find-file)
;; Press Command-b for fuzzy switch buffer
(global-set-key (kbd "C-c C-b") 'projectile-switch-to-buffer)
;; Press Command-a for Ag search
(global-set-key (kbd "C-c C-a") 'projectile-ag)

;; dash-at-point
(autoload 'dash-at-point "dash-at-point"
  "Search the word at point with Dash." t nil)
(add-hook 'enh-ruby-mode-hook
	  (lambda () (setq dash-at-point-docset "rails")))
(global-set-key "\C-cd" 'dash-at-point)
(global-set-key "\C-ce" 'dash-at-point-with-docset)

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

;; powerline
;; (require 'powerline)
;; (powerline-default-theme)

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

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
(autoload 'jsx-mode "jsx-mode" "JSX mode" t)
(setq jsx-indent-level 2)

(setq scss-compile-at-save nil)

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

(load "01ruby.el")

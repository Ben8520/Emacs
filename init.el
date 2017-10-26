(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck company-irony irony dtrt-indent goto-last-change highlight-symbol ggtags helm-gtags evil company vimish-fold autopair helm sublime-themes)))
 '(safe-local-variable-values
   (quote
    ((company-clang-arguments "-I/home/ben/net-snmp-code/include/")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Me
(setq user-full-name "Benjamin Leroux")
(setq user-mail-address "benjamin.leroux@outlook.fr")

;; Packages
(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; Minimal interface
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-frame-fullscreen)

;; Custom theme
(if (display-graphic-p) 
    (load-theme 'spolsky t)
  (load-theme 'tango-dark t))

;; Removes *Completions* from buffer after you've opened a file.
(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
                (kill-buffer buffer)))))

;; Windows move
(windmove-default-keybindings 'meta)

;; Revert buffers
(global-auto-revert-mode t)

;; Text settings
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)
(show-paren-mode t)

;; Identation
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
;; C-style
(setq-default c-basic-offset 4)
(setq-default c-default-style "k&r")
;; Auto-indent new line
(global-set-key (kbd "RET") 'newline-and-indent)

;; No backup file
(setq make-backup-files nil)
;; No Auto-Save file
(setq auto-save-default nil)

;; Yes or No
(defalias 'yes-or-no-p 'y-or-n-p)

;; Save sessions
(if (display-graphic-p) 
    (desktop-save-mode t)
  (desktop-save-mode nil))

;; Display time and battery level
(display-time-mode t)
(display-battery-mode t)

;; Line numbers
(setq linum-format "%d ")
(add-hook 'prog-mode-hook 'linum-mode)

;; Column numbers
(setq column-number-mode t)

;; Edit files as root
(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(global-set-key (kbd "C-x C-r") 'sudo-edit)

;; Terminal
(defun bash (buffer-name)
  "Start a terminal and rename buffer."
  (interactive "sBuffer name: ")
  (ansi-term "/bin/bash")
  (rename-buffer buffer-name t))

;; Compile
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))



;; PACKAGES

;;Helm mode
(require 'helm)
(require 'helm-config)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) 
(define-key helm-map (kbd "C-i")   'helm-execute-persistent-action) 
(define-key helm-map (kbd "C-z")   'helm-select-action)             

(setq helm-split-window-in-side-p t)

(helm-autoresize-mode t)

(global-set-key (kbd "M-x")     'helm-M-x)
(global-set-key (kbd "M-y")     'helm-show-kill-ring)
(global-set-key (kbd "C-x b")   'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c h o") 'helm-occur)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h x") 'helm-register)

(helm-mode 1)

;; Helm GTAGS
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)


;; Autopair
(require 'autopair)
(autopair-global-mode t)

;; Vimish Fold
(require 'vimish-fold)
(global-set-key (kbd "C-x v f") #'vimish-fold)
(global-set-key (kbd "C-x v v") #'vimish-fold-delete)

;; Company mode
(require 'company)
(setq company-dabbrev-downcase 0)
(setq company-idle-delay 0)
(add-hook 'after-init-hook 'global-company-mode)

;; DTRT mode (guess offset)
(require 'dtrt-indent)
(add-hook 'c-mode-hook 'dtrt-indent-mode)

;; Clean Indent
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

;; WS butler
(require 'ws-butler)
(add-hook 'c-mode-common-hook 'ws-butler-mode)

;; Irony mode
(require 'irony)
(add-hook 'c-mode-hook 'irony-mode)

;; Goto-Last-Change
(require 'goto-last-change)
(global-set-key (kbd "s-g") 'goto-last-change)

;; Highlight Mode
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

(require 'flycheck)
(add-hook 'c-mode-hook 'flycheck-mode)

;; Final Message
(message "---> .emacs loaded <---")

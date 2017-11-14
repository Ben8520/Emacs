(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck-irony ws-butler vimish-fold sublime-themes powerline highlight-symbol helm goto-last-change ggtags flycheck evil dtrt-indent diminish company-irony clean-aindent-mode autopair))))
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

;; Line numbers
(setq linum-format "%d ")
(add-hook 'prog-mode-hook 'linum-mode)

;; Column numbers
(setq column-number-mode t)

;; Whitespace
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)
(diminish 'global-whitespace-mode)

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
(diminish 'helm-mode)

;; Autopair
(require 'autopair)
(autopair-global-mode t)
(diminish 'autopair-mode)

;; Vimish Fold
(require 'vimish-fold)
(global-set-key (kbd "C-x v f") #'vimish-fold)
(global-set-key (kbd "C-x v v") #'vimish-fold-delete)


;; DTRT mode (guess offset)
(require 'dtrt-indent)
(setq dtrt-indent-verbosity 0)
(add-hook 'c-mode-hook 'dtrt-indent-mode)

;; Clean Indent
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

(require 'ggtags)
(add-hook 'c-mode-hook 'ggtags-mode)
(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)
(diminish 'ggtags-mode)

;; WS butler
(require 'ws-butler)
(add-hook 'c-mode-common-hook 'ws-butler-mode)
(diminish 'ws-butler-mode)

;; Irony Mode
(use-package irony
  :ensure t
  :defer t
  :init
  (add-hook 'c-mode-hook 'irony-mode)
  :config
  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  )
(diminish 'irony-mode)

;; Company Mode
(use-package company
  :ensure t
  :defer t
  :init
   (add-hook 'after-init-hook 'global-company-mode)
  :config
  (use-package company-irony :ensure t :defer t)
  (setq
   company-idle-delay              0
   company-minimum-prefix-length   2
   company-show-numbers            t
   company-tooltip-limit           20
   company-dabbrev-downcase        nil
   company-backends                '((company-irony))
   )
  )
(diminish 'company-mode)

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
(diminish 'flycheck-mode)
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;; Powerline
(require 'powerline)
(powerline-default-theme)

;; GDB
(setq gdb-many-windows  t
      gdb-show-main     t)

;; HS minor mode
(add-hook 'c-mode-hook 'hs-minor-mode)

;; Abbrev ??
(diminish 'abbrev-mode)

;; Final Message
(message "---> .emacs loaded <---")

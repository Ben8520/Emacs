(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-projectile highlight-symbol ggtags helm-gtags evil company vimish-fold autopair helm sublime-themes)))
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
(setq x-select-enable-clipboard t)

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
(global-linum-mode t)

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



;; PACKAGES

;;Helm mode
(require 'helm)
(require 'helm-config)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i")   'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")   'helm-select-action)             ; list actions using C-z

(setq helm-split-window-in-side-p t)

(helm-autoresize-mode t)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
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

;; Compile
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

;; ;; Predictive Mode
;; (add-to-list 'load-path "/home/ben/.emacs.d/predictive")
;; (add-to-list 'load-path "/home/ben/.emacs.d/predictive/latex")
;; (add-to-list 'load-path "/home/ben/.emacs.d/predictive/misc")
;; (add-to-list 'load-path "/home/ben/.emacs.d/predictive/html")
;; (add-to-list 'load-path "/home/ben/.emacs.d/predictive/texinfo")
;; (require 'predictive)

;; (setq predictive-auto-learn t
;;       predictive-which-dict t
;;       predictive-latex-electric-environments t)
;; (add-hook 'LaTeX-mode-hook 'predictive-mode)

;; ;; FlySpell
;; (add-to-list 'load-path "~/.emacs.d/flyspell/")
;; (autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
;; (autoload 'flyspell-delay-command "flyspell" "Delay on command." t)
;; (autoload 'tex-mode-flyspell-verify "flyspell" "" t) 

;; ;; AucTeX
;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq-default TeX-master nil)

;; (add-hook 'LaTeX-mode-hook 'auto-fill-mode)
;; (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;; (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
;; (setq TeX-source-correlate-method 'synctex)

;; (setq TeX-view-program-list '(("Evince" "evince %o"))
;;       TeX-view-program-selection '((output-pdf "Evince")))

;; (setq reftex-plug-into-AUCTeX t)

;; (setq TeX-PDF-mode t)

;; ;; Outline Mino Mode
;; (defun turn-on-outline-minor-mode ()
;; (outline-minor-mode 1))

;; (add-hook 'LaTeX-mode-hook 'turn-on-outline-minor-mode)
;; (add-hook 'latex-mode-hook 'turn-on-outline-minor-mode)
;; (setq outline-minor-mode-prefix "\C-c \C-o")

;; Terminal
(defun bash (buffer-name)
  "Start a terminal and rename buffer."
  (interactive "sBuffer name: ")
  (term "/bin/bash")
  (rename-buffer buffer-name t))

;; Vimish Fold
(global-set-key (kbd "C-x v f") #'vimish-fold)
(global-set-key (kbd "C-x v v") #'vimish-fold-delete)

;; Company mode
(add-hook 'after-init-hook 'global-company-mode)

;; Highlight Mode
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

;; Final Message
(message "---> .emacs loaded <---")

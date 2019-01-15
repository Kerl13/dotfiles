(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(defvar my-packages
  '(evil
    company-coq
    proof-general))

(defun install-my-packages ()
  "Install missing packages."
  (interactive)
  (message "%s" "Refreshing the package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (company-coq proof-general evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq evil-want-abbrev-expand-on-insert-exit nil)

(evil-mode 1)

;; Load company-coq when opening Coq files
(add-hook 'coq-mode-hook #'company-coq-mode)

(global-set-key (kbd "C-j") 'proof-assert-next-command-interactive)
(global-set-key (kbd "C-k") 'proof-undo-last-successful-command)
(global-set-key (kbd "C-S-j") 'proof-process-buffer)
(toggle-scroll-bar -1)
(setq inhibit-startup-screen t)

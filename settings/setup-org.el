(use-package org
  :ensure org-plus-contrib
  :init
  (add-hook 'org-mode-hook 'visual-line-mode)
  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook 'flyspell-mode)
  (setq org-mobile-directory "~/Dropbox/GTD/MobileOrg")
  :diminish visual-line-mode
  :diminish org-indent-mode
  :defer t
  :bind (("\C-c a" . org-agenda)
         ("\C-c c" . org-capture)
         ("\C-c j" . gs-helm-org-link-to-contact))
  :config


  (defun sk/diminish-org-indent ()
    "Diminish org-indent-mode on the modeline"
    (interactive)
    (diminish 'org-indent-mode ""))
  (add-hook 'org-indent-mode-hook #'sk/diminish-org-indent)

   ;; Custom functions for emacs & org mode
  (load-file "~/.emacs.d/config/gas-org.el")
  (require 'org)

  (setq org-display-inline-images t)
  (setq org-redisplay-inline-images t)
  (setq org-startup-with-inline-images "inlineimages")

  ;; == Agenda ==
  (defvar org-agenda-window-setup)
  (setq org-agenda-window-setup 'current-window)

  ;; Run/highlight code using babel in org-mode
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (python . t)
     (clojure . t)
     (octave . t)
     (C . t)
     (shell . t)
     ))
  ;; Syntax hilight in #+begin_src blocks
  (setq org-src-fontify-natively t)
  ;; Don't prompt before running code in org
  (setq org-confirm-babel-evaluate nil)
  ;; Display inline images after running code
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
)

(defun myorg-update-parent-cookie ()
  (when (equal major-mode 'org-mode)
    (save-excursion
      (ignore-errors
        (org-back-to-heading)
        (org-update-parent-todo-statistics)))))

(defadvice org-kill-line (after fix-cookies activate)
  (myorg-update-parent-cookie))

(defadvice kill-whole-line (after fix-cookies activate)
  (myorg-update-parent-cookie))

(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map (kbd "M-<f6>") 'org-capture)

(provide 'setup-org)

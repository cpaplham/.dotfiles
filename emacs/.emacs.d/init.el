;;; init.el -- Initialization file for Emacs -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(setq gc-cons-threshold (* 256 1024 1024))
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold (* 5 1024 1024))))
(add-hook 'focus-out-hook 'garbage-collect)
(run-with-idle-timer 10 t 'garbage-collect)

(if (display-graphic-p)
    (progn
      (set-face-background 'default "gray10")
      (set-face-foreground 'default "#bdbdb3")
      (set-face-font 'default "PragmataPro")
      (setq-default line-spacing 1)
      (scroll-bar-mode -1)
      (tool-bar-mode -1))
  (menu-bar-mode -1))

(column-number-mode t)
(delete-selection-mode t)
(electric-pair-mode t)
(line-number-mode t)
(show-paren-mode t)

(setq-default auto-save-default nil
              c-basic-offset 4
              c-default-style "bsd"
              fill-column 80
              indent-tabs-mode nil
              inhibit-startup-screen t
              make-backup-files nil
              mouse-wheel-progressive-speed nil
              ring-bell-function 'ignore
              show-paren-delay 0)

(fset 'yes-or-no-p 'y-or-n-p)

(when (string= window-system "mac")
  (setq mac-option-modifier 'meta
        mac-command-modifier 'super))

(add-hook 'eshell-mode-hook
          (lambda ()
            (defun eshell/clear (&optional _scrollback)
              "Clear the scrollback contents (regardless of SCROLLBACK)."
              (declare-function eshell/clear-scrollback "esh-mode")
              (eshell/clear-scrollback))))

(setq custom-file (make-temp-file "emacs" nil ".el"))
(load custom-file t)
(add-hook 'kill-emacs-hook
          (lambda () (when (file-exists-p custom-file)
                       (delete-file custom-file))))

(require 'package)
(setq package-enable-at-startup nil
      package-archive-contents '(("gnu" . "http://elpa.gnu.org/packages/")
                                 ("melpa" . "http://melpa.org/packages/")
                                 ("orgmode" . "https://orgmode.org/elpa/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

(if (display-graphic-p)
    (use-package nimbus-theme
      :config
      (load-theme 'nimbus t)))

(use-package avy)

(use-package company
  :diminish company-mode
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-global-modes '(c-mode
                               c++-mode
                               emacs-lisp-mode
                               lisp-interaction-mode
                               python-mode))
  (setq-default company-dabbrev-downcase 0
                company-idle-delay 0.5
                company-minimum-prefix-length 2
                company-tooltip-limit 10))

(use-package company-irony
  :after (company irony))

(use-package company-irony-c-headers
  :after (company irony)
  :config
  (add-to-list 'company-backends '(company-irony-c-headers company-irony)))

(use-package diminish)

(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode t))

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(ns x))
    (exec-path-from-shell-initialize)))

(use-package fic-mode
  :config
  (add-hook 'prog-mode-hook 'fic-mode))

(use-package fiplr)

(use-package flycheck
  :config
  (global-flycheck-mode)
  (setq flycheck-mode-line-prefix "ƒ"))

(use-package free-keys
  :defer t)

(use-package general
  :after (avy evil)
  :config
  (general-define-key "s-u" 'revert-buffer
                      "s-a" 'mark-whole-buffer
                      "s-s" 'save-buffer
                      "s-z" 'undo-tree-undo
                      "s-Z" 'undo-tree-redo
                      "s-x" 'kill-region
                      "s-c" 'kill-ring-save
                      "s-v" 'yank)
  (general-define-key :states 'motion
                      :keymaps 'override
                      :prefix "SPC"
                      :non-normal-prefix "M-SPC"
                      "" nil
                      "e" 'eshell
                      "d" 'diff-buffer-with-file
                      "D" (lambda ()
                            (interactive)
                            (diff-buffer-with-file (current-buffer)))
                      "k" 'kill-buffer
                      "K" 'kill-current-buffer
                      "c" 'cd
                      "b" 'switch-to-buffer
                      "n" 'neotree-toggle
                      "N" 'neotree-refresh
                      "SPC" 'fiplr-find-file)
  (general-define-key :states '(normal operator visual motion)
                      "s" 'avy-goto-char-timer))

(use-package irony
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(use-package ivy
  :diminish ivy-mode
  :config
  (ivy-mode t))

(use-package neotree
  :defer t
  :config
  (setq neo-theme 'ascii)
  (general-define-key :states 'motion
                      :keymaps 'neotree-mode-map
                      "RET" 'neotree-enter
                      "TAB" 'neotree-quick-look))

(use-package org
  :defer t
  :ensure org-plus-contrib
  :config
  (setq org-adapt-indentation t
        org-edit-src-content-indentation 2
        org-highlight-latex-and-related '(latex script)
        org-list-allow-alphabetical t
        org-src-tab-acts-natively t)
  (when (string= window-system "mac")
    (setq org-preview-latex-default-process 'dvisvgm))
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((C .t)
                                 (dot . t)
                                 (emacs-lisp . t)
                                 (python . t)
                                 (R . t)
                                 (shell . t))))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package tex
  :defer t
  :ensure auctex)

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (declare-function global-undo-tree-mode "undo-tree")
  (global-undo-tree-mode t))

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode t))

;;; init.el ends here

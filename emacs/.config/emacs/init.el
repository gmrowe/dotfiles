;;;; package --- Summary

;;; Commentary:

;;;;
;; TODO - change frame title bar to something more sensible
;;        (see: frame-title-format)
;; TODO - Add a visual indicator of which window is active
;;
;; TODO - Automatic spell-check in text modes
;;
;; TODO - Look into updating the mode-line with Doom-modeline + all-the-icons

;;
;; TODO - ivy-rich has even more goodies for discoverabilty
;;
;;;;

;;; Code:

(defvar config--min-emacs-major-version 29)

;; Show an error if this file is run with version < 29
(when (< emacs-major-version config--min-emacs-major-version)
  (error
   (format
    "This config only works with Emacs %s and newer; you have version %s"
    config--min-emacs-major-version
    emacs-major-version)))

;; Put emacs generated customization blocks into separate file
;; so that they aren't cluttering up this config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;;; Add melpa package archives to the mix
(with-eval-after-load 'package
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;;; TODO: should this function actually live here?
(defun config--ignore-trailing-whitespace-in-modal-spaces (hooks)
  "Turn off show trailing whitespace in modes where it is not useful.
HOOKS should be an alist of mode hooks in which whitespace should be ignored"
  (dolist
      (hook hooks)
    (add-hook hook
	      (lambda () (setq show-trailing-whitespace nil)))))

;; Default options to use when emacs loads
(use-package emacs
  :bind
  (;; Bind C-z to undo, by default it is bound to `suspend-frame'
   ("C-z" . undo)
   ;; Comment selected line(s) by using C-;
   ;; TODO: This is only really needed in prog-modes,
   ;;       can we define it there
   ("C-;" . comment-line))

  :hook
  ;; Display line numbers in any program mode
  (prog-mode . display-line-numbers-mode)
  ;; Use relative line numbering strategy
  (prog-mode . (lambda () (setopt display-line-numbers-type 'relative)))
  ;; Electric pair mode automatically closes parens and braces
  ;; it's just nice to have
  (prog-mode . electric-pair-mode)
  ;; When in a text mode, use visual line mode to wrap lines
  (text-mode . visual-line-mode)

  :config
  ;; C-<arrow key> will navagate between windows (frames)
  ; (windmove-default-keybindings 'control)
  ;; When in a gui frame, mouse right-click will bring up context menu
  (when (display-graphic-p) (context-menu-mode))
  ;; Save minibuffer history between sessions
  (savehist-mode 1)
  ;; Replace tabs with spaces
  (indent-tabs-mode nil)
  ;; Smoother scrolling - not sure if it's helpful or not
  (pixel-scroll-precision-mode 1)
  ;; Set the cursor to a lighter color so it is easier to see
  ;; #ededed is a very light grey
  (set-face-attribute 'cursor nil :background "#ededed")
  ;; Get rid of scroll bars
  (scroll-bar-mode 0)
  ;; Get rid of the graphical tool bar
  (tool-bar-mode 0)
  ;; Ignore trailing whitespace in spaces where it doesn't matter
  (config--ignore-trailing-whitespace-in-modal-spaces
   '(special-mode-hook
     term-mode-hook
     comint-mode-hook
     compilation-mode-hook
     minibuffer-setup-hook))

  :custom
  (inhibit-splash-screen t "Turn off the welcome screen")
  (line-number-mode t "Show line numbers in modeline")
  (column-number-mode t "Show column numbers in modeline")
  (initial-major-mode 'fundamental-mode "Start emacs in fundamental mode")
  (display-time-default-load-average nil "Turn off display of system load")
  (sentence-end-double-space nil "Sentences don't need double space")
  (cursor-type
   '(bar . 2)
   "Use a `bar: width = 2` type cursor like all the cool kids'")
  (initial-scratch-message nil "Suppress initial scratch message")
  (show-trailing-whitespace t "Indicate empty whitespace at end of line")
  (require-final-newline t "Attomatically append eof newline if not present")
  (ring-bell-function 'ignore "Never make a sound")
  (backup-directory-alist
   `(("." . ,(expand-file-name
	      (file-name-as-directory "backups")
	      user-emacs-directory)))
   "Don't clutter up random folders with backups")
  (backup-by-copying t "Always use copying to create backup files"))

(expand-file-name (file-name-as-directory "backups") user-emacs-directory)

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; Use smex for autocompletion in the minibuffer with M-x
(use-package smex
  :ensure t
  :config
  (smex-initialize)
  :bind
  (;; Bind smex to the default exteded command key
   ("M-x" . smex)
   ;; This is the default behavior for M-x - for historical purposes
   ("C-c C-c M-x" . execute-extended-command)))

;; move-text: Moves current line up or down with M-<up, down>
(use-package move-text
  :ensure t
  :bind
  (;; Bind move-text-[up, down] to M-<up, down>
   ("M-<up>" . move-text-up)
   ("M-<down>" . move-text-down)))

;; org-superstar: better looking bullets for org-mode
(use-package org-superstar
  :ensure t
  :hook
  (org-mode . org-superstar-mode))


;; simplicity-theme is a minimalist theme that only
;; colors a small number of elements (strings, comments, errors, etc.)
;; see: https://github.com/smallwat3r/emacs-simplicity-theme
(use-package simplicity-theme
  :ensure t
  :config
  (setq simplicity-override-colors-alist
	'(("simplicity-background" . "#2d3743")
	  ("simplicity-comment" . "gold")))
  (load-theme 'simplicity))

;; ivy: completion mode for multiple modes. Trust me, we really
;; want this!
(use-package ivy
  :ensure t
  :config (ivy-mode)
  :custom
  (ivy-use-virtual-buffers t "Buffers are indexes to provide faster search")
  (ivy-count-format "(%d/%d) "))


;; ~~~~~~~~~~~~~ Development specific packages

;; company-mode: text completion for emacs
(use-package company
  :ensure t)

;; flycheck-rust: a flycheck extension for configuring flycheck
;; automatically for the current cargo project
(use-package flycheck-rust
  :ensure t)

;; flycheck-mode: syntax checking for emacs
;; flycheck mode
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; projectile: project-aware focused functions (compile, test, search etc.)
(use-package projectile
  :ensure t
  :init   (projectile-mode 1)
  :bind-keymap
  ("s-p" . projectile-command-map)
  ("C-c p" . projectile-command-map))

;;; Rust setup
;; rust-mode
(use-package rust-mode
  :ensure t)

;; rustic-mode - some additional goodies on top of rust-mode
(use-package rustic
  :ensure t
  :config
  (setq rustic-format-on-save t)
  (push 'rustic-clippy flycheck-checkers)
  (remove-hook 'rustic-mode-hook 'flycheck-mode)
  :custom
  (rustic-lsp-setup-p nil "Do not setup lsp mode... for now"))

;;; Clojure setup
;; clojure mode
(use-package clojure-mode
  :ensure t)

;; smartparens is a drop in replacement for paredit,
;; trying it for a while to see if it fits me
(use-package smartparens
  :ensure t

  :hook
  (clojure-mode . smartparens-strict-mode)
  (emacs-lisp-mode . smartparens-strict-mode) ; May as well enable for elisp

  :bind
  (:map smartparens-mode-map
	("C-M-f" . sp-forward-sexp)
	("C-M-b" . sp-backward-sexp)
	("C-<right>" . sp-forward-slurp-sexp)
	("C-<left>" . sp-forward-barf-sexp)
	("C-M-<left>" . sp-backward-slurp-sexp)
	("C-M-<right>" . sp-backward-barf-sexp)
	("C-M-k" . sp-kill-sexp)
	("C-M-w" . sp-copy-sexp)))

(use-package cider
  :ensure t)

(provide 'init)
;;; init.el ends here

(defun init-evil ()

;;------------------------------viper-mode--------------------------------------------
;;(use-package vimpulse)
;;toggle-viper-mode

(defun open-with-vim ()
    (interactive)
    (start-process-shell-command "Vim" "*Messages*" (concat "C:/Worktools/Vim/vim81/gvim.exe -p --remote-tab-silent " (buffer-file-name)))
    (message (concat (buffer-name) " Opened with Vim")))

(global-set-key (kbd "C-x v c") 'open-with-vim)

(defun open-with-default ()
    (interactive)
    (start-process-shell-command "nil" "*Messages*" (concat "open " "\"" (buffer-file-name) "\""))
    (message (concat (buffer-name) " Opened with default")))

(global-set-key (kbd "C-x v v") 'open-with-default)

(require 'evil)
(evil-mode 1)
(setq evil-default-state 'emacs)

(setq evil-move-cursor-back nil)
; (setq evil-emacs-state-cursor '("red" box))
; (setq evil-normal-state-cursor '("green" box))
; (setq evil-visual-state-cursor '("orange" box))
; (setq evil-insert-state-cursor '("red" bar))
; (setq evil-replace-state-cursor '("red" bar))
; (setq evil-operator-state-cursor '("red" hollow))

;;============================= Hack ======================================	
;; 由于chinese-wbim 的问题(在basic输入位置设置), key-chord-mode 出现问题, 必须对其hack.
(defun evil-emacs-state-chord-hack ()
  (interactive)
  (call-interactively 'key-chord-mode)
  (call-interactively 'key-chord-mode)
  (evil-emacs-state)
  (message "--EMACS--")
)

; (defalias 'evil-emacs-state 'evil-emacs-state-chord-hack)  ;;change insert-state to emacs-state automaticly

(defun evil-open-above (count)
  "Insert a new line above point and switch to Insert state.
The insertion will be repeated COUNT times."
  (interactive "p")
  (evil-insert-newline-above)
  (setq evil-insert-count count
        evil-insert-lines t
        evil-insert-vcount nil)
  (evil-insert-state 1)
  (add-hook 'post-command-hook #'evil-maybe-remove-spaces)
  (when evil-auto-indent
    (indent-according-to-mode))
	(evil-normal-state)
	(message "Line Opened"))

(defun evil-open-below (count)
  "Insert a new line below point and switch to Insert state.
The insertion will be repeated COUNT times."
  (interactive "p")
  (push (point) buffer-undo-list)
  (evil-insert-newline-below)
  (setq evil-insert-count count
        evil-insert-lines t
        evil-insert-vcount nil)
  (evil-insert-state 1)
  (add-hook 'post-command-hook #'evil-maybe-remove-spaces)
  (when evil-auto-indent
    (indent-according-to-mode))
	(evil-normal-state)
	(message "Line Opened"))

(defun evil-append-line (count &optional vcount)
  "Switch to Insert state at the end of the current line.
The insertion will be repeated COUNT times.  If VCOUNT is non nil
it should be number > 0. The insertion will be repeated in the
next VCOUNT - 1 lines below the current one."
  (interactive "p")
  (evil-move-end-of-line)
  (setq evil-insert-count count
        evil-insert-lines nil
        evil-insert-vcount
        (and vcount
             (> vcount 1)
             (list (line-number-at-pos)
                   #'end-of-line
                   vcount)))
  (evil-insert-state 1)
  (call-interactively 'key-chord-mode)
  (call-interactively 'key-chord-mode)
  (evil-emacs-state)
  (message "--EMACS--"))


(define-key evil-emacs-state-map (kbd "M-l") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "M-l") 'evil-normal-state)
(define-key evil-normal-state-map (kbd "i") 'evil-emacs-state-chord-hack)
; (define-key evil-normal-state-map (kbd "M-l") 'evil-emacs-state)
;(define-key evil-normal-state-map (kbd "a") 'bury-buffer)
(define-key evil-normal-state-map (kbd "q") 'kill-buffer)
(define-key evil-normal-state-map (kbd "C-e") 'move-end-of-line)
(define-key evil-normal-state-map (kbd "1") 'evil-end-of-line)

(setq evil-emacs-state-modes (append evil-insert-state-modes evil-emacs-state-modes))
(setq evil-insert-state-modes nil)



;(defalias 'evil-insert-state 'evil-emacs-state)  ;;change insert-state to emacs-state automaticly
;(define-key key-translation-map (kbd "C-`") (kbd "C-g"))
;;(define-key key-translation-map (kbd "M-s") (kbd "C-g"))


;;Exit insert mode by pressing j and then j quickly
;; 与 Space 作 Ctrl 键功能冲突
(setq key-chord-two-keys-delay 0.9)
(key-chord-define evil-emacs-state-map "jj" 'evil-normal-state)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-define evil-emacs-state-map "vv" 'evil-visual-char)
(key-chord-mode 1)

;;============================== PLUGINS===================================	
;;------------------------ surround ---------------------------
(require 'evil-surround)
(global-evil-surround-mode 1)
;; To change the default surround-pairs-alist you have to use setq-default
(setq-default evil-surround-pairs-alist
    (quote ((40 "(" . ")")
     (91 "[" . "]")
     (123 "{" . "}")
     (41 "(" . ")")
     (93 "[" . "]")
     (125 "{" . "}")
     (35 "#{" . "}")
     (98 "(" . ")")
     (66 "{" . "}")
     (62 "<" . ">")
     (116 . evil-surround-read-tag)
     (60 . evil-surround-read-tag)
     (102 . evil-surround-function))))
	 
;; -------Comment ----------------------
;;evil-nerd-commenter
;;(evilnc-default-hotkeys)

;;Comment-dwim-2
(global-set-key (kbd "M-;") 'comment-dwim-2)

;;------------evil-org-------
; (require 'evil-org)
; (evil-define-key 'normal evil-org-mode-map "O" 'evil-open-above)
; (evil-define-key 'normal evil-org-mode-map  "o" 'evil-open-below)
; (evil-define-key 'insert evil-org-mode-map  (kbd "M-l") 'evil-normal-state)

(require 'syndicate)
(evil-define-key 'normal syndicate-mode-map
  "<" 'evil-shift-left
  ">" 'evil-shift-right)
  
(defun insert-item-below ()
  "Try to infer what to insert."
  (if (not (org-in-item-p))
      (insert "\n")
    (org-insert-item)
	(insert " ")))
(evil-define-key 'normal syndicate-mode-map
  "o" '(lambda () (interactive) (syndicate-eol-then 'insert-item-below) (evil-normal-state) (message "Item Inserted")))
;;=========================== PLUGINS END==================================

;;========================================Evil Setup END=============================================
"Init Evil"
(interactive)			
			)

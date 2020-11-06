(defun init-edit ()


;; ----------- CTRLF-mode --------------------------------
  (ctrlf-mode +1)
  ; (define-key global-map "\C-t" 'ctrlf-forward-literal)
  ; (define-key esc-map "\C-t" 'ctrlf-forward-regexp)
  ;; 注意：上面这两句没有作用，需要改动 ctrlf.el 和 ctrlf-autoloads.el 中的快捷键, 
  ;; 对 ctrlf.el 中多处作了修改，通过 "hacked by JL" 查找
  ; (define-key isearch-mode-map (kbd "M-z") 'ctrlf-cancel)   ;; isearch
  ; (define-key ctrlf-mode-map (kbd "M-z") 'ctrlf-cancel)   ;; isearch

;; Being able to duplicate current line
 (defun duplicate-line-down ()
   (interactive)
   (save-mark-and-excursion
     (beginning-of-line)
     (insert (thing-at-point 'line t))))

 (defun duplicate-line-up ()
   (interactive)
   (save-mark-and-excursion
     (beginning-of-line)
     (insert (thing-at-point 'line t)))
   (previous-line)
)


;; Move or drag a line up and down
 (defun move-line-down ()
   (interactive)
   (let ((col (current-column)))
     (save-excursion
       (forward-line)
       (transpose-lines 1))
     (forward-line)
     (move-to-column col)))

 (defun move-line-up ()
   (interactive)
   (let ((col (current-column)))
     (save-excursion
       (forward-line)
       (transpose-lines -1))
     (forward-line -1)
     (move-to-column col)))

(global-set-key (kbd "C-S-h") 'duplicate-line-up)
(global-set-key (kbd "C-S-l") 'duplicate-line-down)
(global-set-key (kbd "C-S-j") 'move-line-down)
(global-set-key (kbd "C-S-k") 'move-line-up)

;; 鼠标滚动行数  
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1) ))


(require 'fast-scroll)
;; If you would like to turn on/off other modes, like flycheck, add
;; your own hooks.
;; (add-hook 'fast-scroll-start-hook (lambda () (flycheck-mode -1)))
;; (add-hook 'fast-scroll-end-hook (lambda () (flycheck-mode 1)))
(fast-scroll-config)
(fast-scroll-minor-mode 1)

;(require 'smooth-scrolling)
;(smooth-scrolling-mode 1)

  
(setq reb-re-syntax 'string)  ;; re-builder’s support for different syntax
;;----------------------------------------Auto Pairs------------------------------------
; (defun set-parens-24.2 ()
; (use-package autopair
; :config
; (autopair-global-mode) ;; enable autopair in all buffers  注意与tex.el 中的(setq cdlatex-paired-parens "$([{" ) 的兼容问题
; turn on highlight matching brackets when cursor is on one
; (show-paren-mode 1)))

; (defun set-parens-24.5 ()
(use-package smartparens-config
:config
(smartparens-global-mode t)
;;(sp-pair "$" "$")
(sp-pair "\[" "\]")
(sp-local-pair 'org-mode "$" "$")
(show-smartparens-global-mode t))
; )

; (if (version< emacs-version "24.3")
  ; (set-parens-24.2)
  ; (set-parens-24.5)
; )

;;------------undo fill-paragraph in emacs----------------
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))
(global-set-key (kbd "M-u") 'unfill-paragraph)
;; 一行一行可以用 	"M-^"

(defun unfill-region ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))

;;------------------------- undo-tree ------------------------------------
(use-package undo-tree
:config
(global-undo-tree-mode))

;;------------------------------binding revert to F5-----------------------
(global-auto-revert-mode t)
(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  (revert-buffer t t))

(global-set-key (kbd "C-c C-a") 'revert-buffer-no-confirm)
;;-------------------------------------------------------------------------

;;-----------------------------------Mark----------------------------------
(use-package visible-mark
:init
;; 把 set-mark-command 绑定到 其他键上面 上
(global-set-key (kbd "M-c") 'set-mark-command)
;;--------- visible-mark 显示 mark的位置 ----------------
;;注意：visible-mark.el中visible-mark-mode-maybe的cl-flet函数在24.2(其是24.3的函数)中错误，被改成flet
(defface visible-mark-active ;; put this before (use-package visible-mark)
  '((((type tty) (class mono)))
    (t (:background "magenta"))) "")
:config
(global-visible-mark-mode 1)
(setq visible-mark-max 2)
(setq visible-mark-faces `(visible-mark-face1 visible-mark-face2)))

(defun xah-mark-current-line ()
  "Select current line.
URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2016-07-22"
  (interactive)
  (end-of-line)
  (set-mark (line-beginning-position)))


(defun xah-extend-mark ()
  "Select the current word, bracket/quote expression, or expand selection.
Subsequent calls expands the selection.

when no selection,
? if cursor is on a bracket, select whole bracketed thing including bracket
? if cursor is on a quote, select whole quoted thing including quoted
? if cursor is on the beginning of line, select the line.
? else, select current word.

when there's a selection, the selection extension behavior is still experimental.
Roughly:
? if 1 line is selected, extend to next line.
? if multiple lines is selected, extend to next line.
? if a bracketed text is selected, extend to include the outer bracket. If there's no outer, select current line.

 to line, or bracket/quoted text,
or text block, whichever is the smallest.

URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2017-01-15"
  (interactive)
  (if (region-active-p)
      (progn
        (let (($rb (region-beginning)) ($re (region-end)))
          (goto-char $rb)
          (cond
           ((looking-at "\\s(")
            (if (eq (nth 0 (syntax-ppss)) 0)
                (progn
                  (message "left bracket, depth 0.")
                  (end-of-line) ; select current line
                  (set-mark (line-beginning-position)))
              (progn
                (message "left bracket, depth not 0")
                (up-list -1 t t)
                (mark-sexp))))
           ((eq $rb (line-beginning-position))
            (progn
              (goto-char $rb)
              (let (($firstLineEndPos (line-end-position)))
                (cond
                 ((eq $re $firstLineEndPos)
                  (progn
                    (message "exactly 1 line. extend to next whole line." )
                    (forward-line 1)
                    (end-of-line)))
                 ((< $re $firstLineEndPos)
                  (progn
                    (message "less than 1 line. complete the line." )
                    (end-of-line)))
                 ((> $re $firstLineEndPos)
                  (progn
                    (message "beginning of line, but end is greater than 1st end of line" )
                    (goto-char $re)
                    (if (eq (point) (line-end-position))
                        (progn
                          (message "exactly multiple lines" )
                          (forward-line 1)
                          (end-of-line))
                      (progn
                        (message "multiple lines but end is not eol. make it so" )
                        (goto-char $re)
                        (end-of-line)))))
                 (t (error "logic error 42946" ))))))
           ((and (> (point) (line-beginning-position)) (<= (point) (line-end-position)))
            (progn
              (message "less than 1 line" )
              (end-of-line) ; select current line
              (set-mark (line-beginning-position))))
           (t (message "last resort" ) nil))))
    (progn
      (cond
       ((looking-at "\\s(")
        (message "left bracket")
        (mark-sexp)) ; left bracket
       ((looking-at "\\s)")
        (message "right bracket")
        (backward-up-list) (mark-sexp))
       ((looking-at "\\s\"")
        (message "string quote")
        (mark-sexp)) ; string quote
       ((and (eq (point) (line-beginning-position)) (not (looking-at "\n")))
        (message "beginning of line and not empty")
        (end-of-line)
        (set-mark (line-beginning-position)))
       ((or (looking-back "\\s_" 1) (looking-back "\\sw" 1))
        (message "left is word or symbol")
        (skip-syntax-backward "_w" )
        ;; (re-search-backward "^\\(\\sw\\|\\s_\\)" nil t)
        (mark-sexp))
       ((and (looking-at "\\s ") (looking-back "\\s " 1))
        (message "left and right both space" )
        (skip-chars-backward "\\s " ) (set-mark (point))
        (skip-chars-forward "\\s "))
       ((and (looking-at "\n") (looking-back "\n" 1))
        (message "left and right both newline")
        (skip-chars-forward "\n")
        (set-mark (point))
        (re-search-forward "\n[ \t]*\n")) ; between blank lines, select next text block
       (t (message "just mark sexp" )
          (mark-sexp))
       ;;
       ))))

(global-set-key (kbd "M-v") 'xah-extend-mark)

;;------------ selection without mouse----------------
(use-package expand-region
:bind
(("C-=" . er/expand-region)
 ("C-c SPC". ace-jump-mode)))


;;------------------------------------CopyWithoutSelection---------------------------------------
(use-package thing-edit
:bind
(("C-c n" . thing-copy-line)
;;(global-set-key (kbd "C-c e")  'thing-copy-to-line-end)
("C-c b" . thing-copy-to-line-beginning)
("C-c f" . thing-copy-defun)
("C-c s" . thing-copy-sentence)))

(defun get-point (symbol &optional arg)
  "get the point"
  (funcall symbol arg)
  (point)
 )

(defun copy-thing (begin-of-thing end-of-thing &optional arg)
  "copy thing between beg & end into kill ring"
  (save-excursion
    (let ((beg (get-point begin-of-thing 1))
	  (end (get-point end-of-thing arg)))
      (copy-region-as-kill beg end)))
  )

(defun paste-to-mark(&optional arg)
  "Paste things to mark, or to the prompt in shell-mode"
  (let ((pasteMe
     	 (lambda()
     	   (if (string= "shell-mode" major-mode)
	       (progn (comint-next-prompt 25535) (yank))
	     (progn (goto-char (mark)) (yank) )))))
    (if arg
	(if (= arg 1)
	    nil
	  (funcall pasteMe))
      (funcall pasteMe))
    ))
;;Copy Parenthesis

(defun beginning-of-parenthesis(&optional arg)
  "  "
  (re-search-backward "[[<(?\"]" (line-beginning-position) 3 1)
  (if (looking-at "[[<(?\"]")  (goto-char (+ (point) 1)) )
  )
(defun end-of-parenthesis(&optional arg)
  " "
  (re-search-forward "[]>)?\"]" (line-end-position) 3 arg)
  (if (looking-back "[]>)?\"]") (goto-char (- (point) 1)) )
  )

(defun thing-copy-parenthesis-to-mark(&optional arg)
  " Try to copy a parenthesis and paste it to the mark
     When used in shell-mode, it will paste parenthesis on shell prompt by default "
  (interactive "P")
  (copy-thing 'beginning-of-parenthesis 'end-of-parenthesis arg)
  ;;(paste-to-mark arg)
  )
; (global-set-key (kbd "C-c q") (quote thing-copy-parenthesis-to-mark))


;;Copy Paragraph
(defun copy-paragraph (&optional arg)
  "Copy paragraphes at point"
  (interactive "P")
  (copy-thing 'backward-paragraph 'forward-paragraph arg)
  (message (concat "Paragraph Copied"))
  ;;(paste-to-mark arg)
  )
;;key binding
;(global-set-key (kbd "C-c p") (quote copy-paragraph))


;;-------------------------------Increment Number--------------------------------------
(defun increment-number-or-char-at-point ()
  "Increment number or character at point."
  (interactive)
  (let ((nump  nil))
    (save-excursion
      (skip-chars-backward "0123456789")
      (when (looking-at "[0123456789]+")
        (replace-match (number-to-string (1+ (string-to-number (match-string 0)))))
        (setq nump  t)))
    (unless nump
      (save-excursion
        (condition-case nil
            (let ((chr  (1+ (char-after))))
              (unless (characterp chr) (error "Cannot increment char by one"))
              (delete-char 1)
              (insert chr))
          (error (error "No character at point")))))))

(global-set-key (kbd "C-c +") 'increment-number-or-char-at-point)


;;----------------------------------- 显示最近改动 ------------------------------------
(use-package volatile-highlights
:config
(volatile-highlights-mode t)
(use-package mark-tools))
;;(global-set-key (kbd "C-x m") 'list-marks-other-window)



;;===============================================register Setup===============================================
;;-----------improve list register-------------------------------------------
;(use-package better-registers)
;;在better-registers文件中注释了(define-key better-registers-map "\C-j" 'better-registers-jump-to-register)
;;并把"\Cx-j" 修改为"\Cr-j"
(use-package list-register
:init
;; This is used in the function below to make marked points visible
(defface register-marker-face '((t (:background "red")))
  "Used to mark register positions in a buffer."
  :group 'faces)
;;This redefines (and therefore overrides) the standard function of the same name.
;;Highlights points that are ‘registered’ and floatover help tells what register key the point was mapped to.

(defun set-register (register value)
  "Set Emacs register named REGISTER to VALUE.  Returns VALUE.
    See the documentation of `register-alist' for possible VALUE."
  (let ((aelt (assq register register-alist))
	(sovl (intern (concat "point-register-overlay-"
			      (single-key-description register))))
	)
    (when (not (boundp sovl))
      (set sovl (make-overlay (point)(point)))
      (overlay-put (symbol-value sovl) 'face 'register-marker-face)
      (overlay-put (symbol-value sovl) 'help-echo
		   (concat "Register: `"
			   (single-key-description register) "'")))
    (delete-overlay (symbol-value sovl))
    (if (markerp value)
	;; I'm trying to avoid putting overlay on newline char
	(if (and (looking-at "$")(not (looking-back "^")))
	    (move-overlay (symbol-value sovl) (1- value) value)
	  (move-overlay (symbol-value sovl) value (1+ value))))
    (if aelt
	(setcdr aelt value)
      (push (cons register value) register-alist))
    value))
)
; (use-package register-list)   ;; 出现 Eager macro-expansion 错误

(global-set-key (kbd "C-x r h") 'helm-register)

;;===========================================register Setup END===============================================


;;========================================Frame Window and Buffer Setup=======================================
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
      (progn
	;; use 120 char wide window for largeish displays
	;; and smaller 80 column windows for smaller displays
	;; pick whatever numbers make sense for you
	(if (> (x-display-pixel-width) 1440)
	    (add-to-list 'default-frame-alist (cons 'width 120))
	  (add-to-list 'default-frame-alist (cons 'width 80)))
	;; for the height, subtract a couple hundred pixels
	;; from the screen height (for panels, menubars and
	;; whatnot), then divide by the height of a char to
	;; get the height we want
	(add-to-list 'default-frame-alist
		     (cons 'height (/ (- (x-display-pixel-height) 200)
				      (frame-char-height)))))))

(set-frame-size-according-to-resolution)

;; WinnerMode
(when (fboundp 'winner-mode)
(winner-mode 1))

;;---------------------------Transpose frame------------------------
(use-package transpose-frame
:bind 
(("C-x 4 t" . transpose-frame))
)


;;; ---------------swap the buffers in 2 windows emacs ------------
(defun win-swap ()
  "Swap windows using buffer-move.el"
  (interactive)
  (if (null (windmove-find-other-window 'right))
      (buf-move-left)
    (buf-move-right)))
(global-set-key (kbd "C-x 4 s") 'win-swap)

;;---------------------Swap buffers without-------------------------
(use-package buffer-move
:bind
(("C-x 4 <up>" . buf-move-up)
("C-x 4 <down>" . buf-move-down)
("C-x 4 <left>" . buf-move-left)
("C-x 4 <right>" . buf-move-right)))
;;-------------------- Select buffer--------------------------------
(global-set-key [M-left] 'windmove-left)          ; move to left windnow
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to downer window

;;--------------------- Ace-windows ---------------------------------
(global-set-key (kbd "M-o") 'ace-window)

(global-set-key (kbd "C-:") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g f") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
(global-set-key (kbd "M-g e") 'avy-goto-word-0)

;; -------------------------- switch-window -------------------------
(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)
(global-set-key (kbd "C-x 1") 'switch-window-then-maximize)
(global-set-key (kbd "C-x 2") 'switch-window-then-split-below)
(global-set-key (kbd "C-x 3") 'switch-window-then-split-right)
(global-set-key (kbd "C-x 0") 'switch-window-then-delete)

(global-set-key (kbd "C-x 4 d") 'switch-window-then-dired)
(global-set-key (kbd "C-x 4 f") 'switch-window-then-find-file)
(global-set-key (kbd "C-x 4 m") 'switch-window-then-compose-mail)
(global-set-key (kbd "C-x 4 r") 'switch-window-then-find-file-read-only)

(global-set-key (kbd "C-x 4 C-f") 'switch-window-then-find-file)
(global-set-key (kbd "C-x 4 C-o") 'switch-window-then-display-buffer)

(global-set-key (kbd "C-x 4 0") 'switch-window-then-kill-buffer)

;;-----------------------------------Buffer Menu--------------------------------------
; eliminate the need for ‘C-x o’, making list-buffers much easier to use
(global-set-key (kbd "\C-x\C-b") 'buffer-menu-other-window)
;;(global-set-key (kbd "C-x C-b") 'bs-show)
;;
(setq ibuffer-use-other-window t)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

(setq ibuffer-saved-filter-groups
      '(("home"
	 ("LaTex" (or (mode . latex-mode)
		      (filename . ".Rnw")
		      (name . "\*RefTex Select\*")
		      (name . "\*toc\*")
		      ))
	 ("Dired" (or (mode . sr-mode)
		      (mode . dired-mode)
		      (mode . sr-virtual-mode)
		      (mode . sr-tree-mode)
		      (mode . sr-buttons-mode)
		      ))
	 ("Org" (or  (filename . ".org")
		     (filename . ".Org")
		     (name .  "\*Org Agenda\*")
		     ))
	 ("R" (or  (mode . inferior-ess-mode)
		   (mode . ess-mode)
		   ))
	 ("Markdown" (or  (filename . ".Rmd")
		     (filename . ".md")
		     ))
	 ("Python" (or  (mode . inferior-python-mode)
		   (mode . python-mode)
		   ))
	 ("EIN" (or  (name . "*ein")
		   ))
	 ("Magit" (or  (mode . magit-mode)
	               (mode . magit-process-mode)
				   (mode . magit-diff-mode)
				   (name . "magit:")
		   ))		   
	 ("Help" (or (name . "\*Help\*")
		     (name . "\*Apropos\*")
		     (name . "\*info\*"))))))

(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-switch-to-saved-filter-groups "home")))
(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)
(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (ibuffer-switch-to-saved-filter-groups "home")))
;;(use-package buff-menu+)


;;-----------------------------Control TAB buffer Cycling-----------------------------
(global-set-key [(control tab)] 'bury-buffer)

;;----------------------Switching Between Two Recently Used Buffers-------------------
(defun switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
; (global-set-key [(shift tab)] 'switch-to-previous-buffer)


;;===================================Frame Window and Buffer Setup END==================================


;;===============================================Bookmarks Setup==============================================
(setq bmkp-last-as-first-bookmark-file "~/.emacs.d/user-files/bookmarks")
(setq bookmark-default-file "~/.emacs.d/user-files/bookmarks")

;;在新窗口中打开bookmark list 和 register list
(defun get-bookmarks-in-new-frame ()
  (interactive)
  (bookmark-bmenu-list)
  (switch-to-buffer-other-window "*Bookmark List*"))

(global-set-key (kbd "C-x r l") 'get-bookmarks-in-new-frame)

(setq recentf-exclude '("/Works/org/" "/Worktools/Config/")
)
			 
(recentf-mode 1) ; keep a list of recently opened files
(global-set-key (kbd "C-x f") 'recentf-open-files)

(require 'bookmark+)

;;-------------------------------browse-kill-ring----------------------------
;; Ever feel that 'C-y M-y M-y M-y ...' is not a great way of trying
;; to find that piece of text you know you killed a while back?  Then
;; browse-kill-ring.el is for you.
;;(use-package browse-kill-ring)
;;(global-set-key (kbd "C-c k") 'browse-kill-ring)

(use-package browse-kill-ring+)

;;(global-set-key "\C-cy" '(lambda ()
;;                          (interactive)
;;                          (popup-menu 'yank-menu)))

;;(use-package popup)
;;(use-package pos-tip)
;;(use-package popup-kill-ring)

;;(global-set-key "\M-y" 'popup-kill-ring)
;;(setq popup-kill-ring-interactive-insert t)

;; ---------------- clipmon-----------------
;; monitor the system clipboard and add any changes to the kill ring
(add-to-list 'after-init-hook 'clipmon-mode-start)

;; persist the kill ring between sessions
(add-to-list 'after-init-hook 'clipmon-persist)
(setq savehist-autosave-interval (* 5 60)) ; save every 5 minutes (default)
(setq kill-ring-max 500)
(setq clipmon-timer-interval 1)

;;==========================================Bookmarks Setup END========================================

;;===================== easy-kill ====================================
(global-set-key [remap kill-ring-save] 'easy-kill)
(global-set-key [remap mark-sexp] 'easy-mark)


;; Hungry Delete
(use-package hungry-delete
:bind
(("C-c <delete>" . hungry-delete-forward)
("C-c <backspace>". hungry-delete-backward)))

;;===================== regexp ====================================
(global-set-key (kbd "C-r") 'replace-string)
(require 'visual-regexp)
(define-key global-map (kbd "C-c C-r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)

;; insert default directory
(defun insert-default-path ()
  (interactive)
  (insert (concat "\"" default-directory "\""))
)

(defun xah-toggle-margin-right ()
  "Toggle the right margin between `fill-column' or window width.
This command is convenient when reading novel, documentation."
  (interactive)
  (if (eq (cdr (window-margins)) nil)
      (set-window-margins nil 0 (- (window-body-width) fill-column))
    (set-window-margins nil 0 0)))

;----- goto-line-preview
(global-set-key [remap goto-line] 'goto-line-preview)



;;; ------------ imenu-list --------------------------
(setq imenu-list-focus-after-activation t)
(setq imenu-list-position 'left)

(add-hook 'imenu-list-major-mode-hook 'my-inhibit-global-linum-mode)

(global-set-key (kbd "C-'") #'imenu-list-smart-toggle)

(dumb-jump-mode)

"Init Edit"
(interactive)			
			)

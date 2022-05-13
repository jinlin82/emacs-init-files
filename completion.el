(defun init-completion ()

;;==================================== COMPLETION ===========================================
;; Notice: auto-complete 和 bookmark+ 以及 Icicles 在一些 Major Mode 中有冲突， 包括 R 和 latex
;; 而Icicles 是无法舍弃的功能，此外 sunrise commander 需要加载 bookmark+, 而sunrise commander也无法舍弃
;; 故只能忍受这个bug. 在 R 中已用 company mode 近似代替 auto-complete的功能，但在latex-mode中仍没有找到替代方案

;;-------- 加载 auto-compltete ---------
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-start 3)
(setq ac-auto-show-menu t)
(setq ac-use-quick-help nil)
(setq ac-delay 0.5)
(setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ))


;-------- 在latex-mode中加载 auto-complete--------
; 冲突，无法使用，见上面说明
(require 'auto-complete-latex)
(setq ac-modes (append ac-modes '(foo-mode)))
(add-hook 'foo-mode-hook 'ac-l-setup)

(setq ac-l-sources
      '(
	ac-l-source-user-keywords
	ac-l-source-basic-commands
	ac-l-source-package-commands
	ac-l-source-primitives
	ac-l-source-style-commands
	ac-l-source-latex-dot-ltx
	ac-l-source-basic-options-&-variables
	ac-l-source-package-options-&-variables
	))

;------- Org Mode AC --------------------	
(require 'org-ac)
(defun org-ac/setup-current-buffer ()
  "Do setup for using org-ac in current buffer."
  (interactive)
  (when (eq major-mode 'org-mode)
    (loop for stroke in org-ac/ac-trigger-command-keys
          do (local-set-key (read-kbd-macro stroke) 'ac-pcmp/self-insert-command-with-ac-start))
    (add-to-list 'ac-sources 'ac-source-org-ac-tex)
    (add-to-list 'ac-sources 'ac-source-org-ac-head)
    (add-to-list 'ac-sources 'ac-source-org-ac-todo)
    (add-to-list 'ac-sources 'ac-source-org-ac-tag)
    (add-to-list 'ac-sources 'ac-source-org-ac-link-head)
    (add-to-list 'ac-sources 'ac-source-org-ac-option)
    (add-to-list 'ac-sources 'ac-source-org-ac-option-key)
    (add-to-list 'ac-sources 'ac-source-org-ac-option-options)
    (auto-complete-mode t)))
(org-ac/config-default)	

;-------- Math mode AC ------------------
; (require 'ac-math) ; This is not needed when you install from MELPA
; (add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of `latex-mode`
; (defun ac-latex-mode-setup ()         ; add ac-sources to default ac-sources
  ; (setq ac-sources
     ; (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
               ; ac-sources)))
; (add-hook 'TeX-mode-hook 'ac-latex-mode-setup)

; (setq ac-math-unicode-in-math-p t)
; (add-to-list 'ac-modes 'org-mode)
; (defun ac-org-mode-setup ()
   ; (add-to-list 'ac-sources 'ac-source-math-unicode))

; (add-hook 'org-mode-hook 'ac-org-mode-setup)

; (defvar ac-source-math-latex-everywhere
; '((candidates . ac-math-symbols-latex)
  ; (prefix . ac-math-prefix)
  ; (action . ac-math-action-latex)
  ; (symbol . "l")))

;;-------------------------------------------------

;;-----------------------company-mode---------------------
(setq company-show-numbers t)

(setq company-backends '(company-math-symbols-unicode
                         company-latex-commands
                         company-elisp
						 company-bbdb
						 company-nxml
						 company-css
						 company-eclim
						 company-semantic
						 company-clang
						 company-xcode
						 company-cmake
						 company-capf
						 company-dabbrev-code
						 company-gtags
						 company-etags
						 company-keywords
						 company-oddmuse
						 company-files
						 ; company-dabbrev ; 文本补全
						 ))

(add-hook 'after-init-hook 'global-company-mode)
(define-key company-mode-map (kbd "C-c /") 'company-files)
(define-key company-mode-map (kbd "C-c C-/") 'company-files)

(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
(define-key company-active-map (kbd "TAB") nil)
(define-key company-active-map [tab] nil)
;(define-key company-active-map [return] nil)
;(define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "M-z") #'company-abort) 
(define-key company-active-map (kbd "TAB") #'company-complete-common-or-cycle)
(define-key company-active-map [tab] #'company-complete-common-or-cycle)

)

(company-quickhelp-mode)
(eval-after-load 'company
  '(define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin)
  )

;;; python R 中无法起作用
; (require 'company-box)
; (add-hook 'company-mode-hook 'company-box-mode)


;;-------------在ess中使用 company-mode----------------
 (setq ess-use-auto-complete nil)
;(setq ess-use-company nil)
 (add-hook 'inferior-ess-mode-hook 'company-mode)
 (add-hook 'ess-mode-hook 'company-mode)

(add-hook 'markdown-mode-hook 'company-mode)

(add-hook 'org-mode-hook 'company-mode)

(define-key org-mode-map (kbd "M-n TAB") 'company-math-symbols-unicode)

;;----------------------------------------------------

;; (require 'completion-ui)  ;; 似乎没有上面两个好用


;;===================================== HElM ==========================================
;; When running helm-mini: Invalid function: "B"
;; solution: recompile helm-utils.el or delete helm-utils.elc 

(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode 1)
(setq helm-inherit-input-method nil)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)
	  
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(helm-descbinds-mode)
(require 'helm-describe-modes)
(global-set-key [remap describe-mode] #'helm-describe-modes)

;;;====================================helm-swoop=======================================
;; Change the keybinds to whatever you like :)
(require 'helm-swoop)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
;; When doing evil-search, hand the word over to helm-swoop
;; (define-key evil-motion-state-map (kbd "M-i") 'helm-swoop-from-evil-search)

;; Instead of helm-multi-swoop-all, you can also use helm-multi-swoop-current-mode
(define-key helm-swoop-map (kbd "M-m") 'helm-multi-swoop-current-mode-from-helm-swoop)

;; Move up and down like isearch
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
(define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)


;;----------------------------------------------- Icicles -----------------------------------
; (require 'icicles)  ;;要出现在dired-filetype-face之后, 出现在ido 之前
; (setq completions-format (quote vertical))
; (setq icicle-completions-format (quote vertical))
; (icy-mode 1)

;;------------------------------------------- Ido -------------------------------------------
; (require 'ido)
; (ido-mode 1)
; (ido-everywhere 1)
; (require 'flx-ido)
; (flx-ido-mode 1)

; (setq ido-use-faces t)
; (set-face-attribute 'ido-first-match nil
                    ; :background nil
                    ; :foreground "orange")
; (ido-grid-mode 1)
; (setq ido-grid-mode-start-collapsed t)

; (require 'ido-vertical-mode)
; (ido-vertical-mode 1)
; (setq ido-vertical-define-keys 'C-n-and-C-p-only)





; (require 'ido-ubiquitous)
; (ido-ubiquitous-mode 1)
; (require 'ido-yes-or-no)
; (ido-yes-or-no-mode 1)

; (global-set-key (kbd "M-x") 'smex)
; (global-set-key (kbd "M-X") 'smex-major-mode-commands)
;This is your old M-x.
; (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)



; (setq org-completion-use-ido t)

 ;;How to use Sunrise with Ido?
; (defun ido-sunrise ()
  ; "Call `sunrise' the ido way.
    ; The directory is selected interactively by typing a substring.
    ; For details on keybindings, see `ido-find-file'."
  ; (interactive)
  ; (let ((ido-report-no-match nil)
        ; (ido-auto-merge-work-directories-length -1))
    ; (ido-file-internal 'sr-dired 'sr-dired nil "Sunrise: " 'dir)))
; (define-key (cdr (assoc 'ido-mode minor-mode-map-alist)) [remap dired] 'ido-sunrise)


;;===================================	Dired and Sunrise Setup END====================================

;;================================ COMPLETION END ==================================



;;========================================= guide-key ===========================================
(require 'popwin)
;;It's hard to remember keyboard shortcuts. The guide-key package pops up help after a short delay.
; (require 'guide-key)
; (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-c" "C-x"))
; (guide-key-mode 1) ; Enable guide-key-mode
; For org mode
; (defun guide-key/my-hook-function-for-org-mode ()
  ; (guide-key/add-local-guide-key-sequence "C-c")
  ; (guide-key/add-local-guide-key-sequence "M-n")
  ; (guide-key/add-local-guide-key-sequence "C-c C-x")
  ; (guide-key/add-local-guide-key-sequence "C-c C-v")
  ; (guide-key/add-local-highlight-command-regexp "org-"))
; (add-hook 'org-mode-hook 'guide-key/my-hook-function-for-org-mode)

;; ------------------- which-key ---------------
(which-key-mode)
(setq which-key-idle-delay 2.0)
(setq which-key-add-column-padding 2)
(setq which-key-show-remaining-keys t)
(setq which-key-sort-order 'which-key-prefix-then-key-order)
; (which-key-setup-side-window-right-bottom)


;;===================================== TEMPLATES ==================================
;; 主要涉及到三个 packages： skeleton, tempo 与 yasnippet，而 clipper 是一个小巧的文本
;; 保存工具，目前符合我的要求。

;;---------------- Abbrev Mode ---------------
;; turn on abbrev mode globally
(setq abbrev-file-name             ;; tell emacs where to read abbrev
        "~/.emacs.d/user-files/abbrev_defs")    ;; definitions from...
(setq-default abbrev-mode t)
(global-set-key "\C-xal" 'list-abbrevs)
(setq save-abbrevs nil)


;; --------------- clipper.el ----------------
(require 'clipper)
; (global-set-key "\M-]" 'clipper-insert)
; (global-set-key "\M-[" 'clipper-create)


;; ------------ yasnippet ----------------
(setq yas-snippet-dirs
   (quote
    ("~/../Config/.emacs.d/user-files/snippets" 
     ;"~/../Config/.emacs.d/elpa/elpy-20180314.1340/snippets/" 
     )))


(yas-reload-all)
(add-hook 'markdown-mode-hook #'yas-minor-mode)
(add-hook 'org-mode-hook #'yas-minor-mode)    ;; yas-trigger-key

(add-hook 'yas-minor-mode-hook '(lambda ()
	(define-key yas-minor-mode-map (kbd "C-x a s") 'yas-insert-snippet)
        (define-key yas-minor-mode-map (kbd "C-x a v") 'ivy-yasnippet)
	))

	
;; ---------------- yankpad --------------
;; (require 'yankpad)
;; (setq yankpad-file "~/.emacs.d/user-files/yankpad.org")
;; (global-set-key "\M-]" 'yankpad-insert)
;; (global-set-key "\M-[" 'yankpad-expand)
;; ; If you want to complete snippets using company-mode
;; (add-to-list 'company-backends #'company-yankpad)
;; ; If you want to expand snippets with hippie-expand
;; (add-to-list 'hippie-expand-try-functions-list #'yankpad-expand)


(global-set-key (kbd "\C-x c") 'clear-shell) ;; 要出现在helm之后


;; ================================== skeletor ======================================
(require 'skeletor)
;; FilePath -> IO ()
(defun skeletor--initialize-git-repo  (dir)
  "Initialise a new git repository at DIR."
  (let ((default-directory dir))
    (skeletor--log-info "Initialising git...")
    ;; Some tools (e.g. bundler) initialise git but do not make an initial
    ;; commit.
    (unless (f-exists? (f-join dir ".git"))
      (skeletor-shell-command "git init"))
    (skeletor-shell-command "git commit --allow-empty -m \"Initial commit\"") ;; hacked
    (skeletor-shell-command "git add -A && git commit -m \"Add initial files\"") ;; hacked
    (message "Initialising git...done")))


;; ================================== ivy ======================================
(defun ivy-switch-buffer-matcher-pinyin (regexp candidates)
  (unless (featurep 'pinyinlib) (require 'pinyinlib))
  (let* ((pys (split-string regexp "[ \t]+"))
         (regexp (format ".*%s.*"
                         (mapconcat 'pinyinlib-build-regexp-string pys ".*"))))
    (ivy--switch-buffer-matcher regexp candidates)))

(defun ivy-switch-buffer-by-pinyin ()
  "Switch to another buffer."
  (interactive)
  (unless (featurep 'ivy) (require 'ivy))
  (let ((this-command 'ivy-switch-buffer))
    (ivy-read "Switch to buffer: " 'internal-complete-buffer
              :matcher #'ivy-switch-buffer-matcher-pinyin
              :preselect (buffer-name (other-buffer (current-buffer)))
              :action #'ivy--switch-buffer-action
              :keymap ivy-switch-buffer-map
              :caller 'ivy-switch-buffer)))

(defun re-builder-extended-pattern (str)
  (let* ((len (length str)))
    (cond
     ;; do nothing
     ((<= (length str) 0))

     ;; If the first charater of input in ivy is ":",
     ;; remaining input is converted into Chinese pinyin regex.
     ;; For example, input "/ic" match "isController" or "isCollapsed"
     ((string= (substring str 0 1) ":")
      (setq str (pinyinlib-build-regexp-string (substring str 1 len) t)))

     ;; If the first charater of input in ivy is "/",
     ;; remaining input is converted to pattern to search camel case word
     ((string= (substring str 0 1) "/")
      (let* ((rlt "")
             (i 0)
             (subs (substring str 1 len))
             c)
        (when (> len 2)
          (setq subs (upcase subs))
          (while (< i (length subs))
            (setq c (elt subs i))
            (setq rlt (concat rlt (cond
                                   ((and (< c ?a) (> c ?z) (< c ?A) (> c ?Z))
                                    (format "%c" c))
                                   (t
                                    (concat (if (= i 0) (format "[%c%c]" (+ c 32) c)
                                              (format "%c" c))
                                            "[a-z]+")))))
            (setq i (1+ i))))
        (setq str rlt))))
    (ivy--regex-plus str)))
;; }}

;(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

 (setq ivy-re-builders-alist '((t . re-builder-extended-pattern)))
     ;; set actions when running C-x b
     ;; replace "frame" with window to open in new window
     (ivy-set-actions
      'ivy-switch-buffer-by-pinyin
      '(("j" switch-to-buffer-other-frame "other frame")
        ("k" kill-buffer "kill")
        ("r" ivy--rename-buffer-action "rename")))

;;================================== TEMPLATES  END ==================================


"Init Completion"
(interactive)			
			)








		  

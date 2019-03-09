(defun init-completion ()

;;==================================== COMPLETION ===========================================
;; Notice: auto-complete �� bookmark+ �Լ� Icicles ��һЩ Major Mode ���г�ͻ�� ���� R �� latex
;; ��Icicles ���޷������Ĺ��ܣ����� sunrise commander ��Ҫ���� bookmark+, ��sunrise commanderҲ�޷�����
;; ��ֻ���������bug. �� R ������ company mode ���ƴ��� auto-complete�Ĺ��ܣ�����latex-mode����û���ҵ��������

;;-------- ���� auto-compltete ---------
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-start 3)
(setq ac-auto-show-menu t)
(setq ac-use-quick-help nil)
(setq ac-delay 0.5)
(setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ))


;-------- ��latex-mode�м��� auto-complete--------
; ��ͻ���޷�ʹ�ã�������˵��
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
;;-------------��ess��ʹ�� company-mode----------------
; (setq ess-use-auto-complete nil)
; (add-hook 'inferior-ess-mode-hook 'company-mode)
; (add-hook 'ess-mode-hook 'company-mode)


(add-hook 'org-mode-hook 'company-mode)
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
						 ; company-dabbrev ; �ı���ȫ
						 ))

(define-key org-mode-map (kbd "M-n TAB") 'company-math-symbols-unicode)

;;----------------------------------------------------

;; (require 'completion-ui)  ;; �ƺ�û��������������






;;===================================== HElM ==========================================
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
; (require 'icicles)  ;;Ҫ������dired-filetype-face֮��, ������ido ֮ǰ
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
;; ��Ҫ�漰������ packages�� skeleton, tempo �� yasnippet���� clipper ��һ��С�ɵ��ı�
;; ���湤�ߣ�Ŀǰ�����ҵ�Ҫ��

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
    ("c:/Worktools/Config/.emacs.d/user-files/snippets" 
     "c:/Worktools/Config/.emacs.d/elpa/elpy-20180314.1340/snippets/" )))

(yas-reload-all)
(add-hook 'markdown-mode-hook #'yas-minor-mode)
(add-hook 'org-mode-hook #'yas-minor-mode)    ;; yas-trigger-key

(add-hook 'yas-minor-mode-hook '(lambda ()
	(define-key yas-minor-mode-map (kbd "C-x a s") 'yas-insert-snippet)
	))

	
;; ---------------- yankpad --------------
(require 'yankpad)
(setq yankpad-file "~/.emacs.d/user-files/yankpad.org")
(global-set-key "\M-]" 'yankpad-insert)
(global-set-key "\M-[" 'yankpad-expand)
; If you want to complete snippets using company-mode
(add-to-list 'company-backends #'company-yankpad)
; If you want to expand snippets with hippie-expand
(add-to-list 'hippie-expand-try-functions-list #'yankpad-expand)


(global-set-key (kbd "\C-x c") 'clear-shell) ;; Ҫ������helm֮��

;;================================== TEMPLATES  END ==================================


"Init Completion"
(interactive)			
			)








		  

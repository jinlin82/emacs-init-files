(defun init-basic ()

(define-key global-map "\C-t" 'isearch-forward)
(define-key esc-map "\C-t" 'isearch-forward-regexp)

(global-set-key (kbd "C-s") 'save-buffer)
; Map M-z to cancel (like C-g)...
;(define-key isearch-mode-map "\e" 'isearch-abort)   ;; \e seems to work better for terminals
(global-set-key  (kbd "M-z") 'keyboard-escape-quit)         ;; everywhere else
(define-key isearch-mode-map (kbd "M-z") 'isearch-abort)   ;; isearch

(global-set-key (kbd "M-s") 'yank)
(global-set-key (kbd "M-k") 'kill-buffer)
(global-set-key (kbd "M-j") 'ibuffer)
(global-set-key (kbd "M-a") 'delete-other-windows)
(global-set-key (kbd "M-,") 'delete-window)
(global-set-key (kbd "M-g l") 'goto-last-change)

;;--------------------------------color-theme--------------------------------------
(require 'color-theme)
(color-theme-initialize)

(if (string-equal (downcase (system-name)) (downcase "JL-Thinkpad"))
(color-theme-emacs-nw)
(color-theme-charcoal-black)
)

;(add-hook 'after-init-hook (lambda () (load-theme 'spacemacs-dark)))

;;------------------------------------------ Add melph packages Repo --------------------
(use-package package
:config
(setq package-archives '(
             ; ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
			 ("Melpa" . "https://melpa.org/packages/")
;             ("ELPA" . "http://tromey.com/elpa/")
			 ("gnu"  . "http://elpa.gnu.org/packages/")
;			 ("SC"   . "http://joseito.republika.pl/sunrise-commander/")
			 ))
; (add-to-list 'package-archives
             ; '("melpa-stable" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/") t)			 

; (setq paradox-github-token 0b38f45bfcd76015f4a3ec84bdacafc40bb32122) ;���粻��
)

(require 'benchmark-init)
;; To disable collection of benchmark data after init is done.
(add-hook 'after-init-hook 'benchmark-init/deactivate)

(require 'paradox)
(paradox-enable)	



;;==================================Basic Config==================================
;;set the default text coding system
(setq default-buffer-file-coding-system 'utf-8)
; (prefer-coding-system 'utf-8) ;; ����������䣬�ᵼ��Rconsole���룬 ������ "������"

; (set-language-environment 'Chinese-GB)
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)

; (set-keyboard-coding-system 'utf-8)   ;; ����������䣬�ᵼ��Rconsole���룬 ������ "������"
; (set-clipboard-coding-system 'utf-8)  ;; �������ӣ�ճ����������
; (set-selection-coding-system 'utf-8)  ;; �������ӣ�ճ����������

(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(gb2312 . gb2312)) ;; Ҫ����Ϊ gb2312������message�г�������
(setq-default pathname-coding-system 'utf-8)
(set-file-name-coding-system 'gb2312) ;; ��������ΪUTF-8���ᵼ������·�����ļ�������
(setq ansi-color-for-comint-mode t)


(setq default-directory "C:/Works/")
  
(column-number-mode t)
(tool-bar-mode -1);;don't display toolbar
(menu-bar-mode -1)  ;;����ʾ menu bar ,��ʱ������ Ctrl+�Ҽ�
(scroll-bar-mode -1)

(global-linum-mode 1)
(require 'hlinum)
(hlinum-activate)

; (setq linum-format 'dynamic)
(set-face-attribute 'fringe nil )
(fringe-mode '(10 . 0))

(setq-default indicate-empty-lines t)

(global-font-lock-mode t)  ; turn on syntax highlight
(setq inhibit-startup-screen t) ;; ����ʾemacs ��ʼ����
(setq inhibit-splash-screen t);; Remove splash screen

;;Setting Emacs default Split to Horizontal
(setq split-height-threshold nil)
(setq split-width-threshold 80)
(setq window-min-width 25)
(setq-default fill-column 80)


;; kill buffer without prompt
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))
(fset 'yes-or-no-p 'y-or-n-p)   ;;Change "yes or no" to "y or n"

;;=================================Basic Config END=================================



	
;;=============================== Input method =====================================
;; �� ; ��ʱ����Ӣ��
(use-package chinese-wbim-extra
:init
;;------------ ��� -------------
(autoload 'chinese-wbim-use-package "chinese-wbim" "Another emacs input method")
;; Tooltip ��ʱ��������
(setq chinese-wbim-use-tooltip nil)

(register-input-method
 "chinese-wbim" "euc-cn" 'chinese-wbim-use-package
 "���" "����������뷨" "wb.txt")
:config
(global-set-key ";" 'chinese-wbim-insert-ascii)
;����Ĭ�����뷨
; (setq default-input-method 'chinese-wbim)
)

;;------------ ƴ�� ------------
(use-package chinese-pyim
:config
(setq default-input-method "chinese-pyim")
; (global-set-key (kbd "C-\\") 'toggle-input-method)
(setq pyim-dicts
   (quote
    ((:name "Ĭ��" :file "C:/worktools/Config/Dict/pyim-bigdict.pyim" :coding utf-8-unix :dict-type pinyin-dict))))

;(global-set-key (kbd "M-k") 'pyim-convert-pinyin-at-point)
(setq pyim-page-length 9)

(setq pyim-use-tooltip nil)
(setq pyim-guidance-format-function 'pyim-guidance-format-function-one-line)
(setq pyim-enable-words-predict nil)
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  ;;pyim-probe-program-mode
                  pyim-probe-org-structure-template
				  ))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

(defun activate-input-method-py ()
  (interactive)
(activate-input-method "chinese-pyim")
(call-interactively 'key-chord-mode)
(call-interactively 'key-chord-mode)
)				  
	  
;;(add-hook 'find-file-hooks 'activate-input-method-py)
(add-hook 'find-file-hooks 'xah-math-input-mode)

  ;; ����ƴ����������
(setq pyim-isearch-enable-pinyin-search t)

(global-set-key (kbd "M-f") 'pyim-forward-word)
(global-set-key (kbd "M-b") 'pyim-backward-word)
(setq pyim-company-complete-chinese-enable nil)
)
;;================================ Input method END ====================================


;;------------------------------------- Backup and History -------------------------------
(setq create-lockfiles nil)  ;; Be aware that symbolic links of the form ��.#*�� are not auto-save files but interlocks to prevent the simultaneous editing of the same file. You can prevent the creation of lock files by setting the variable create-lockfiles to nil
(setq make-backup-files t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(setq savehist-file "~/.emacs.d/user-files/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))
		

;;----------------------------------------- filesets------------------------------
; (require 'filesets)
; (filesets-init)
; (setq filesets-data (quote (("thesis" (:files
				       ; "C:/Works/2010.9-2013.7������Ŀ/Dissertation/Rnw/data/chap-semipara/chap-semipara.Rnw"
				       ; "C:/Works/2010.9-2013.7������Ŀ/Dissertation/Rnw/data/chap-conclusion/chap-conclusion.Rnw"
				       ; "C:/Works/2010.9-2013.7������Ŀ/Dissertation/Rnw/data/chap-country/chap-country.Rnw"
				       ; "C:/Works/2010.9-2013.7������Ŀ/Dissertation/Rnw/data/chap-semimixed/chap-semimixed.Rnw"
				       ; "C:/Works/2010.9-2013.7������Ŀ/Dissertation/Rnw/data/chap-district/chap-district.Rnw"
				       ; "C:/Works/2010.9-2013.7������Ŀ/Dissertation/Rnw/data/chap-intro/chap-intro.Rnw"
				       ; "C:/Works/2010.9-2013.7������Ŀ/Dissertation/Rnw/data/chap-nonpara/chap-nonpara.Rnw"
				       ; "C:/Works/2010.9-2013.7������Ŀ/Dissertation/Rnw/thesis.Rnw")))))		

"Init Basic"
(interactive)			
			)

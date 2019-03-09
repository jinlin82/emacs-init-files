(defun init-dired ()

;;====================================Dired and Sunrise Setup==========================================
;; --------------------- springboard ------------------------
;; 注意：对springboard.el 进行了 hack
(global-set-key (kbd "C-,") 'springboard)
(setq springboard-directories (quote ("C:/" 
				      "C:/works" 
				      "C:/works/teaching" 
				      "C:/Works/2013.7-中南财经政法大学统数学院" 
				      "C:/works/learning" 
				      "C:/works/working_paper" 
				      "C:/worktools" 
				      "C:/worktools/config" 
				      "C:/worktools/config/.emacs.d" 
				      "C:/worktools/config/.emacs.d/init-files" 
				      "C:/worktools/config/.emacs.d/elpa" 
				      "C:/books")))


;;----------------- neotree ---------------------------------------------------
(add-hook 'neotree-mode-hook
	  (lambda ()
	    (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
	    (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
	    (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
	    (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))
(global-set-key (kbd "C-c f") 'neotree-toggle)
(setq neo-smart-open t)
(setq neo-window-fixed-size nil)
(setq neo-window-width 15)
(setq neo-vc-integration (quote (face char)))

;; -------------------------- find-file-in-project --------------------------
(require 'find-file-in-project)
;; fd.exe 速度更快，但存在一个bug，不能找到 .emacs.d 文件夹及其内容
;; 找不到文件属于设置原因，需设置 ffip-ignore-filenames 变量，见下面
(setq ffip-use-rust-fd t)
(setq ffip-rust-fd-respect-ignore-files nil)
(when (eq system-type 'windows-nt) (setq ffip-find-executable "c:/worktools/bat/fd"))
;(when (eq system-type 'windows-nt) (setq ffip-find-executable "c:/cygwin/bin/find"))
(global-set-key (kbd "C-x s") 'find-file-in-project) 

;; helm-ag ripgrep deadgrep


(setq ffip-ignore-filenames
  '(;; VCS
    ;; project misc
    ;"*.log"
    ;; Ctags
    "*.git"
    "tags"
    "TAGS"
    ;; compressed
    "*.tgz"
    "*.gz"
    "*.xz"
    ;"*.zip"
    "*.tar"
    ;"*.rar"
    ;; Global/Cscope
    "GTAGS"
    "GPATH"
    "GRTAGS"
    "cscope.files"
    ;; html/javascript/css
    "*bundle.js"
    "*min.js"
    "*min.css"
    ;; Images
    ;"*.png"
    ;"*.jpg"
    ;"*.jpeg"
    ;"*.gif"
    ;"*.bmp"
    ;"*.tiff"
    "*.ico"
    ;; documents
    ;"*.doc"
    ;"*.docx"
    ;"*.xls"
    ;"*.ppt"
    ;"*.pdf"
    ;"*.odt"
    ;; C/C++
    "*.obj"
    "*.so"
    "*.o"
    "*.a"
    "*.ifso"
    "*.tbd"
    "*.dylib"
    "*.lib"
    ;"*.d"
    ;"*.dll"
    ;"*.exe"
    ;; Java
    ".metadata*"
    "*.class"
    "*.war"
    ;"*.jar"
    ;; Emacs/Vim
    "*flymake"
    ;"#*#"
    ;".#*"
    "*.swp"
    ;"*~"
    "*.elc"
    ;; Python
    "*.pyc"
    ;; Sync
    "*_gsdata_*"
    ))
		  
;;------------------- Install Dired-x -------------------
(add-hook 'dired-load-hook
	  (lambda ()
	    (load "dired-x")
	    ;; Set dired-x global variables here.  For example:
	    ;; (setq dired-guess-shell-gnutar "gtar")
	    ;; (setq dired-x-hands-off-my-keys nil)
	    ))
; (add-hook 'dired-mode-hook
	  ; (lambda ()
	    ; Set dired-x buffer-local variables here.  For example:
	    ; (dired-omit-mode 1)
	    ; ))
(setq dired-omit-mode nil)

;;(require 'diredful)

(eval-after-load 'dired '(progn (require 'dired-filetype-face)))
(setq dired-filetype-document-regexp "^  .*\\.\\(pdf\\|chm\\|CHM\\|tex\\|doc\\|docx\\|xls\\|xlsx\\|ppt\\|pptx\\|odt\\|ott\\|rtf\\|sdw\\|ods\\|sxc\\|odp\\|otp\\|sdx\\|kdh\\|shx\\|caj\\|csv\\)$")
(setq dired-filetype-plain-regexp "^  .*\\.\\(TXT\\|txt\\|Txt\\|ini\\|INI\\|lrc\\|org\\|log\\|conf\\|CFG\\|cfg\\|properties\\|config\\|diff\\|patch\\|ebuild\\|inf\\|cnf\\|example\\|sample\\|default\\|m4\\)$")
(setq dired-filetype-source-regexp "^  .*\\.\\(c\\|cpp\\|java\\|JAVA\\|C\\|php\\|h\\|rb\\|pl\\|css\\|el\\|lua\\|sql\\|ahk\\|cs\\|erl\\|hrl\\|R\\|r\\)$")

(require 'dired+)
(define-key ctl-x-map   "d" 'diredp-dired-files)
(define-key ctl-x-4-map "d" 'diredp-dired-files-other-window)
(require 'dired-details+)
(require 'dired-sort-menu)
(require 'ls-lisp+)

(require 'w32-browser)


(defun dired-name-filter-only-show-matched-lines(filter-regexp)
  (interactive "s(only show matched):")
  (let ((dired-marker-char 16)
	(files (directory-files default-directory t)))
    ;;(dired-unmark-all-files dired-marker-char)
    (save-excursion
      (dolist (file files)
	(when (and (dired-goto-file  (expand-file-name file))
		   (not (string= "" filter-regexp))
		   (string-match filter-regexp (file-name-nondirectory file)))
	  (dired-mark 1)
	  )))
    (dired-toggle-marks)
    (dired-do-kill-lines nil (concat "Filter:'" filter-regexp "' omitted %d line%s"))
    (dired-move-to-filename)
    ))
	
(define-key dired-mode-map  "z" 'dired-name-filter-only-show-matched-lines)



; (setq-default dired-omit-files-p t) ; this is buffer-local variable

; (setq dired-omit-files
      ; (concat dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..*$"))


(defun w32-browser (doc) (w32-shell-execute 1 doc))
(eval-after-load "dired" '(define-key dired-mode-map [f3] (lambda () (interactive) (w32-browser (dired-replace-in-string "/" "\\" (dired-get-filename))))))
(put 'dired-find-alternate-file 'disabled nil)



;;----------------Adding files opened with external apps to the history of recent files.
(defadvice openwith-file-handler
  (around advice-openwith-file-handler (operation &rest args))
  (condition-case description
      ad-do-it
    (error (progn
	     (recentf-add-file (car args))
	     (error (cadr description))))))
(ad-activate 'openwith-file-handler)


;;---------------- Sunrise Commander -------------------------

(require 'sunrise-commander)
;;(require 'sunrise-x-buttons)
(require 'sunrise-x-mirror)
(require 'sunrise-x-loop)
(require 'sunrise-x-modeline)
(require 'sunrise-x-tree)
(require 'sunrise-x-tabs)
(require 'sunrise-x-w32-addons)
(require 'sunrise-x-popviewer)

(defun sunrise-startup ()
  (interactive)
  (setq default-directory "C:/Works/2013.7-中南财经政法大学统数学院/")
  (sunrise-cd)
  (sr-change-window)
  (sr-w32-virtual-entries)
  (sr-change-window)
  (sr-select-viewer-window)
  (delete-window)
  )
;;(sunrise-startup)

(setq find-directory-functions (quote (sr-dired sr-dired cvs-dired-noselect dired-noselect)))

(defun sunrise-1 ()
  (interactive)
  (sunrise)
  (sr-select-viewer-window)
  (delete-window)
  )
(defun sunrise-cd-1 ()
  (interactive)
  (sunrise-cd)
  (sr-select-viewer-window)
  (delete-window)
  )
(global-set-key (kbd "C-c x") 'sunrise-1)
(global-set-key (kbd "C-c X") 'sunrise-cd)

(define-key sr-mode-map (kbd "g")        'sr-checkpoint-restore)
(define-key sr-mode-map (kbd "<backspace>")        'sr-dired-prev-subdir)
(define-key sr-mode-map (kbd "o")        'dired-w32-browser)
(define-key sr-mode-map (kbd "C-c C-k")        'dired-do-kill-lines)
(define-key sr-mode-map (kbd "j")        'scroll-up-command)
(define-key sr-mode-map (kbd "k")        'scroll-down-command)
(define-key sr-mode-map (kbd "h")        'revert-buffer)
(define-key sr-mode-map (kbd "l")        'sr-dired-prev-subdir)
(define-key sr-mode-map (kbd "<mouse-1>")        'mouse-set-point)
(define-key sr-mode-map (kbd "<double-mouse-1>")        'dired-w32-browser)


(setq sr-windows-default-ratio 78)
(setq sr-windows-locked nil)
(setq ls-lisp-ignore-case  t)
(setq ls-lisp-dirs-first  t)
(setq ls-lisp-verbosity nil)
(setq find-directory-functions (cons 'sr-dired find-directory-functions))

;;----dired-view don't work-------
; (require 'dired-view)
; (define-key dired-mode-map (kbd ";") 'dired-view-minor-mode-toggle)
; (define-key sr-mode-map (kbd ";") 'dired-view-minor-mode-toggle)
;;---------------------------------open bookmark in other programs----------

;;-------------------------- use default windows browser to browse url-------------------
(setq browse-url-browser-function 'browse-url-default-windows-browser)


; (defun bookmark-jump (bookmark &optional display-function use-region-p)
; (interactive
; (list (bookmark-completing-read "Jump to bookmark" (bmkp-default-bookmark-name))
; nil
; current-prefix-arg))
; (if (string= (bookmark-get-handler bookmark) nil)
; (w32-shell-execute nil (bookmark-get-filename bookmark))
; (bmkp-jump-1 bookmark (or display-function 'switch-to-buffer) use-region-p)
; ))
; (global-set-key (kbd "C-x j j") 'sr-checkpoint-restore)

(defun bookmark-open-external (bookmark
			       &optional display-function use-region-p)
  (interactive (list (bookmark-completing-read "Jump to bookmark" (bmkp-default-bookmark-name))
                     nil
                     current-prefix-arg))
  (if (not(bookmark-get-front-context-string bookmark))
      (if (string= (bookmark-get-filename bookmark) "   - no file -")
	  (browse-url-default-windows-browser (bookmark-location bookmark))
	(or (condition-case nil
		(w32-shell-execute nil (bookmark-get-filename bookmark))
	      (error nil))
	    (find-file (bookmark-get-filename bookmark)))
	)
    (sr-dired (bookmark-get-filename bookmark))
    ))

(define-key sr-mode-map "g"           'bookmark-open-external)
(global-set-key (kbd "C-x j j") 'bookmark-open-external)


"Init Dired"
(interactive)			
			)

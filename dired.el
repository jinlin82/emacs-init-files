(defun init-dired ()

;;====================================Dired and Sunrise Setup==========================================

(defun create-new-org-buffer-untitled ()
  "Create a new frame with a new empty buffer."
  (interactive)
  (let ((buffer (generate-new-buffer 
		  (concat "Untitled_" (format-time-string "%Y%m%d_%H%M%S") ".org")))
	)
    (switch-to-buffer buffer)
    (org-mode)
    ))

(defun create-new-rmd-buffer-untitled ()
  "Create a new frame with a new empty buffer."
  (interactive)
  (let ((buffer (generate-new-buffer 
		  (concat "Untitled_" (format-time-string "%Y%m%d_%H%M%S") ".rmd")))
	)
    (switch-to-buffer buffer)
    (markdown-mode)
    ))

(global-set-key (kbd "C-x n m") #'create-new-rmd-buffer-untitled)
(global-set-key (kbd "C-x n o") #'create-new-org-buffer-untitled)

;; --------------------- springboard ------------------------
;; 注意：对springboard.el 进行了 hack
(global-set-key (kbd "C-,") 'springboard)
(setq springboard-directories (quote ("~/../../" 
				      "~/../../works" 
				      "~/../../works/teaching" 
				      "~/../../Works/2013.7-中南财经政法大学统数学院" 
				      "~/../../works/learning"
				      "~/../../works/temp" 
				      "~/../../works/working_paper"
				      "~/.." 
				      "~/../config" 
				      "~/../config/.emacs.d" 
				      "~/../config/.emacs.d/init-files" 
				      "~/../config/.emacs.d/elpa" 
				      "~/../../books")))


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
(setq neo-default-system-application "open")

;; -------------------------- find-file-in-project --------------------------
(require 'find-file-in-project)
;; fd.exe 速度更快，但存在一个bug，不能找到 .emacs.d 文件夹及其内容
;; 找不到文件属于设置原因，需设置 ffip-ignore-filenames 变量，见下面
(setq ffip-use-rust-fd t)
(setq ffip-rust-fd-respect-ignore-files nil)
(when (eq system-type 'windows-nt) (setq ffip-find-executable "fd"))
;(when (eq system-type 'windows-nt) (setq ffip-find-executable "~/../../cygwin/bin/find"))
(global-set-key (kbd "C-x s") 'find-file-in-project) 

;; ----------------- fuzzy search in emacs ----------------------------
;; helm-ag ripgrep deadgrep


(setq ffip-ignore-filenames
  '(;; VCS
    ;; project misc
    ;"*.log"
    ;; Ctags
    "*.git"
    "tags"
    "TAGS"
    ".Rproj.user"
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
  (setq default-directory "~/../../Works/2013.7-中南财经政法大学统数学院/")
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

(defun sr-copy-file-object ()
    (interactive)
    (let ((file (dired-copy-filename-as-kill 0)))
(if (equal (s-count-matches ":/" file) 1)
    (w32-shell-execute "copy" file)
    (shell-command (concat "file2clip.exe " file))
)
    (message (concat file " Copied")))
)

(global-set-key (kbd "C-c X") 'sunrise-1)
(global-set-key (kbd "C-c x") 'sunrise-cd-1)

;(define-key sr-mode-map (kbd "h")        'sr-checkpoint-restore)
(define-key sr-mode-map (kbd "<backspace>")        'sr-dired-prev-subdir)
(define-key sr-mode-map (kbd "o")        'dired-w32-browser)
(define-key sr-mode-map (kbd "C-c C-k")        'dired-do-kill-lines)
(define-key sr-mode-map (kbd "j")        'scroll-up-command)
(define-key sr-mode-map (kbd "k")        'scroll-down-command)
(define-key sr-mode-map (kbd "g")        'revert-buffer)
(define-key sr-mode-map (kbd "l")        'sr-dired-prev-subdir)
(define-key sr-mode-map (kbd "<mouse-1>")        'mouse-set-point)
(define-key sr-mode-map (kbd "<double-mouse-1>")        'dired-w32-browser)
(define-key sr-mode-map (kbd "/")        'pinyin-search)
(define-key sr-mode-map (kbd "c")        'sr-copy-file-object)
(define-key sr-mode-map (kbd ",")        'sr-find-file)
(define-key sr-mode-map (kbd "M-a")        'delete-other-windows)
(define-key sr-mode-map (kbd "M-n")        'sr-beginning-of-buffer)





(setq sr-windows-default-ratio 78)
(setq sr-windows-locked nil)
(setq ls-lisp-ignore-case  t)
(setq ls-lisp-dirs-first  t)
(setq ls-lisp-verbosity nil)
(setq find-directory-functions (cons 'sr-dired find-directory-functions))

;;----dired-view don't work-------
;(require 'dired-view)
;(define-key dired-mode-map (kbd ";") 'dired-view-minor-mode-toggle)
;(define-key sr-mode-map (kbd ";") 'dired-view-minor-mode-toggle)
;;;---------------------------------open bookmark in other programs----------

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
(sr-select-viewer-window)
  (delete-window)
    ))

(define-key sr-mode-map "h" 'bookmark-jump)
(global-set-key (kbd "C-x j j") 'bookmark-open-external)

(defun totalcmd (file)
    "Open Windows Explorer to FILE (a file or a folder)."
    (interactive "fFile: ")
    (let ((w32file (subst-char-in-string ?/ ?\\ (expand-file-name file))))
      (if (file-directory-p w32file)
          (w32-shell-execute "open" "TotalCMD64.exe" w32file )
        (w32-shell-execute "open" "TotalCMD64.exe" (concat " " w32file)))))

(defun default-totalcmd ()
    "Open Windows Explorer to current file or folder."
    (interactive)
    (totalcmd default-directory ))


(defun dired-totalcmd ()
    "Open Windows Explorer to current file or folder."
    (interactive)
    (totalcmd (dired-get-filename nil t)))

(define-key sr-mode-map (kbd "<S-return>") 'dired-totalcmd)
(global-set-key (kbd "C-x v e") 'default-totalcmd)

(setq find-directory-functions (cons 'sr-dired find-directory-functions))


(defun open-with-vim ()
    (interactive)
    (start-process-shell-command "Vim" "*Messages*"
				 (concat "gvim -p --remote-tab-silent "
					 (if buffer-file-name buffer-file-name default-directory)))
    (message (concat (buffer-name) " Opened with Vim")))

(defun open-with-vscode ()
    (interactive)
    (start-process-shell-command "Vscode" "*Messages*"
				 (concat "code "
					 (if buffer-file-name buffer-file-name default-directory)))
    (message (concat (buffer-name) " Opened with Vscode")))

(defun open-with-default ()
    (interactive)
    (start-process-shell-command "nil" "*Messages*"
				 (concat "open " "\"" (if buffer-file-name buffer-file-name default-directory) "\""))
    (message (concat (buffer-name) " Opened with default")))

(global-set-key (kbd "C-x v v") 'open-with-vim)
(global-set-key (kbd "C-x v c") 'open-with-vscode)
(global-set-key (kbd "C-x v d") 'open-with-default)


;; ---------------------------- Projectile -----------------------------------
(setq projectile-require-project-root nil)
(setq projectile-completion-system 'ivy)
(setq projectile-indexing-method 'alien)
;(projectile-ignore-global ".Rproj.user")
(setq find-program "~/../bat/fd")
(setq projectile-mode-line-function '(lambda () 
				       (format " Proj[%s]" (if (> (length (projectile-project-name)) 7)
					       (concat (substring (projectile-project-name) 0 4) "...")
					       (projectile-project-name)
					       ))))

(setq projectile-project-search-path '("~/../" "~/../../Works/Working_Paper/"))
(setq projectile-known-projects-file "~/../Config/.emacs.d/user-files/projectile-bookmarks.eld")

(setq projectile-switch-project-action #'find-file-in-project)

;;; remove Duplicated projects in index
(defun projectile-relevant-known-projects ()
    "Return a list of known projects except the current one (if present)."
    (if (projectile-project-p)

        (->> projectile-known-projects
              (--reduce-from
                (if (-contains? (-map 's-downcase acc) (s-downcase it)) acc (cons it acc))
                (list (abbreviate-file-name (projectile-project-root))))
              (-sort 'string-lessp))
      projectile-known-projects))

(setq projectile-globally-ignored-directories
   (quote
    (".idea" ".ensime_cache" ".eunit" ".git" ".hg" ".fslckout" "_FOSSIL_" ".bzr" "_darcs" ".tox" ".svn" ".stack-work" ".Rproj.user")))

(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(defun create-projectile-file()
    ".projectile file created"
    (interactive)
    (with-temp-buffer (write-file ".projectile"))
    )

"Init Dired"
(interactive)			
			)

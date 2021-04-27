(defun init-lang ()

;;======================================Programming Language Setup======================================
;;-------------------------------安装ecb和cedet--------------------------------------
;(load-file "~/../Emacs24.2/site-lisp/cedet-1.1/common/cedet.
;(global-ede-mode 1)                      ; Enable the Project management system
;(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion
;(global-srecode-minor-mode 1)            ; Enable template insertion menu
;(require 'ecb)

;; ---------------------------------------Common Lisp--------------------------------
;;(setq inferior-lisp-program (concat prepath "clisp/full/lisp.exe")
;;-B ~/../../clisp/full/
;;-M ~/../../clisp/full/lispinit.mem
;;-K full")
  ;;-ansi -q")
;(setq inferior-lisp-program (concat prepath "sbcl/sbcl"))


;;(add-to-list 'load-path "~/../Emacs24.2/site-lisp/slime")
;;(require 'slime)
;;(slime-setup '(slime-fancy slime-asdf))

;;-----------------------------------------header2------------------------------
;; 注意： header2.el 中 header-end-line 函数进行了更改
;; ((nonempty-comment-start))
;((make-string 70 (aref comment-start 0)))  ;; HACK by Jin Lin

(autoload 'auto-update-file-header "header2")
(add-hook 'write-file-hooks 'auto-update-file-header)

(autoload 'auto-make-header "header2")
(add-hook 'emacs-lisp-mode-hook 'auto-make-header)
(add-hook 'python-mode-hook 'auto-make-header)
(add-hook 'ess-r-mode-hook 'auto-make-header)
(setq header-date-format "%Y-%m-%d %A %T (%z)")

(setq make-header-hook
    '(
	; header-title 
	; header-blank 
	header-end-line 
	header-file-name 
	header-description 
	header-author 
	; header-maintainer 
	header-copyright 
	header-creation-date 
	; header-version 
	; header-pkg-requires 
	header-modification-date 
	header-modification-author 
	header-update-count 
	; header-url 
	; header-doc-url 
	; header-keywords 
	; header-compatibility 
	; header-blank 
	; header-lib-requires 
	header-end-line
	newline
	newline
	newline
	; header-commentary 
	; header-blank 
	; header-blank 
	; header-end-line 
	; header-history 
	; header-blank 
	; header-blank 
	; header-end-line 
	; header-free-software 
	; header-code 
	header-eof
	previous-line
	previous-line
	previous-line
	previous-line
	previous-line
	))

;;------------------------------------------Ruby------------------------------------
(add-to-list 'load-path "~/../Emacs24.2/site-lisp/ruby-mode")
(require 'inf-ruby)
(require 'ruby-electric)
(add-hook 'ruby-mode-hook (lambda () (ruby-electric-mode t)))


;; ------------------------------ DOT Language ----------------------------
; (load-file "~/.emacs.d/elpa/graphviz-dot-mode.el")
; (setq graphviz-dot-mode-syntax-table (syntax-table))
; (setq graphviz-dot-view-command "doted %s")
; (setq graphviz-dot-view-edit-command t)


;; --------------------------------- plantuml  ----------------------------
(setq plantuml-jar-path "~/../plantuml/plantuml.jar")
;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.uml\\'" . plantuml-mode))
(add-hook 'plantuml-mode-hook 'cdlatex-mode)

;;---------------------------------- mermaid ------------------------------
(require 'mermaid-mode)
(setq mermaid-mmdc-location
   "~/../node-v10.15.1-win-x86/node_modules/mermaid-filter/node_modules/.bin/mmdc")
(add-to-list 'auto-mode-alist '("\\.mmd\\'" . mermaid-mode))

(defun mermaid-compile ()
  "Compile the current mermaid file using mmdc."
  (interactive)
  (save-buffer)
  (let* ((input (f-filename (buffer-file-name)))
         (output (concat (file-name-sans-extension input) mermaid-output-format)))
    (call-process mermaid-mmdc-location nil "*mmdc*" nil "-i" input "-o" output)
    (let ((b (get-buffer output))) 
      (if b 
	((switch-to-buffer b) (revert-buffer t t))
	(find-file-other-window output)
	))
    (find-file-other-window input)
    (message (concat "Mermaid Completed with " output))
    ))


;;========================= GNUPlot ========================================
(require 'gnuplot-mode)
(setq gnuplot-program "~/../gnuplot/bin/wgnuplot")
;; set gnuplot arguments (if other than "-persist")
(defvar gnuplot-flags "-persist -pointsize 2")
(add-hook 'gnuplot-mode-hook
          (lambda ()
            (flyspell-prog-mode)
            (add-hook 'before-save-hook
                      'whitespace-cleanup nil t)))
(setq auto-mode-alist
(append '(("\\.\\(gp\\|gnuplot\\)$" . gnuplot-mode)) auto-mode-alist))

;;========================= SQL ===========================================
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))
			
(add-hook 'sql-mode-hook 'sqlup-mode)
(add-hook 'sql-interactive-mode-hook 'sqlup-mode)
(add-hook 'redis-mode-hook 'sqlup-mode)

(setq sql-product  "postgres")
(setq sql-postgres-options (quote ("-P" "pager=off" "-a" "-e")))
(setq sql-connection-alist
   (quote
    (("dvdrental"
      (sql-product
       (quote postgres))
      (sql-user "postgres")
      (sql-database "dvdrental")
      (sql-server "localhost")
      (sql-port 5432)))))

(setq sql-postgres-login-params
      '((user :default "postgres")
        (database :default "dvdrental")
        (server :default "localhost")
        (port :default 5432)))

(require 'sql)
(define-key sql-mode-map (kbd "<C-return>") 'sql-send-line-and-next)

;;=========================== JavaScript ================================
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))
(require 'js-comint)

;; =============================== asy-mode =============================
(autoload 'asy-mode "asy-mode.el" "Asymptote major mode." t)
(autoload 'lasy-mode "asy-mode.el" "hybrid Asymptote/Latex major mode." t)
(autoload 'asy-insinuate-latex "asy-mode.el" "Asymptote insinuate LaTeX." t)
(add-to-list 'auto-mode-alist '("\\.asy$" . asy-mode))
(require 'asy-mode)


;;====================================Programming Language Setup END==================================


"Init Lang"
(interactive)			
			)

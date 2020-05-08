(defun init-rmd ()
;; RMARKDOWN 输出PDF的设置有3个地方：1.yaml前言；2.rmd-pdf.bat和rmd-pdf.R; 3.tex模板：default-1.17.0.2.tex
(require 'f)
(require 'polymode)
;;;  注意！！！从 poly-markdown.el 文件中 注释掉 ; pm-inner/markdown-inline-math
;;;  注意！！！原因一是公式的 face 有问题，二是性能受影响
;;;  注意！！！poly-R.el hacked
(require 'poly-markdown) ;;要从github版本替换掉mepha版本,并删掉 elc文件，否则会出错
                             ; pm-inner/markdown-inline-math
(require 'poly-R)        ;;要从github版本替换掉mepha版本,并删掉 elc文件，否则会出错

;;; MARKDOWN
(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))

;;; R modes
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)

(defun markdown-disable-poly-mode ()
     (interactive)
     (progn
       (fundamental-mode)
       (markdown-mode)
       )
    (message "Poly-Mode Disabled"))

(defun org-disable-poly-mode ()
     (interactive)
     (progn
       (fundamental-mode)
       (org-mode)
       )
    (message "Poly-Mode Disabled"))
   
; (setq markdown-command "markdown")
(setq markdown-command "multimarkdown")
(setq markdown-asymmetric-header t)


(defun pandoc-md-html-setup ()
  (defun pandoc-md-html ()
     (interactive)
	 (save-buffer)
    (start-process-shell-command "nil" "*Markdown-Compile*"  (concat "pandocmdhtml.bat " (f-base (buffer-name)) ) )
    (message (concat "pandoc-md-html "  (buffer-name))))
	
  (defun pandoc-rmd-html ()
    (interactive)
	(save-buffer)

	(start-process-shell-command "nil" "*Markdown-Compile*"  (concat "rmd-html.bat " (f-base (buffer-name)) ))
    (message (concat "rmd-html.bat " (buffer-name) )))
	
  (defun pandoc-rmd-doc ()
    (interactive)
	(save-buffer)
    (start-process-shell-command "nil" "*Markdown-Compile*"  (concat "rmd-doc.bat " (f-base (buffer-name)) ))
    (message (concat "rmd-doc.bat " (buffer-name) )))

;;--- RMARKDOWN 输出PDF的设置有3个地方：1.	yaml前言；2. rmd-pdf.bat和rmd-pdf.R; 3. tex模板(在R安装文件夹中)：default-1.17.0.2.tex
  (defun pandoc-rmd-pdf ()
    (interactive)
	(save-buffer)
    (start-process-shell-command "nil" "*Markdown-Compile*"  (concat "rmd-pdf.bat " (f-base (buffer-name)) ))
    (message (concat "rmd-pdf.bat " (buffer-name) )))

  (defun pandoc-rmd-beamer ()
    (interactive)
	(save-buffer)
    (start-process-shell-command "nil" "*Markdown-Compile*"  (concat "rmd-beamer.bat " (f-base (buffer-name)) ))
    (message (concat "rmd-beamer.bat " (buffer-name) )))
	
  (defun pandoc-rmd-org ()
    (interactive)
	(save-buffer)
    (start-process-shell-command "nil" "*Markdown-Compile*"  (concat "pandocMdorg.bat " (file-name-sans-extension (buffer-name)) ) )
    (message (concat "export to org-mode with pandoc "  (buffer-name)))
  )
  
  (defun pandoc-bookdown-pdf ()
    (interactive)
	(save-buffer)
    (start-process-shell-command "nil" "*Markdown-Compile*"  (concat "bookdown-pdf.bat " (f-base (buffer-name)) ))
    (message (concat "bookdown-pdf.bat " (buffer-name) ))) 

  (defun rmarkdown-insert-r-chunk () 
  "Insert an r-chunk in markdown mode. Necessary due to interactions between polymode and yas snippet" 
  (interactive) 
  (save-buffer)
  (insert (concat "\n```{r eval=T}\n\n```")) 
  (forward-line -1)
  (save-buffer))

  
;; 添加 prefix 键
(defcustom markdownmode-prefix-key "\M-n"
  "Prefix key for the polymode mode keymap.
Not effective after loading the polymode library."
  :group 'markdown-mode
  :type '(choice string vector))
  
(define-key markdown-mode-map markdownmode-prefix-key
      (let ((map (make-sparse-keymap)))
        (define-key map "i" 'rmarkdown-insert-r-chunk)
		(define-key map "h" 'pandoc-rmd-html)
		(define-key map "a" 'pandoc-rmd-pdf)
		(define-key map "b" 'pandoc-rmd-beamer)
		(define-key map "o" 'pandoc-rmd-org)
		(define-key map "d" 'pandoc-rmd-doc)
		(define-key map "P" 'pandoc-bookdown-pdf)
		(define-key map "m" 'org-emphasize-math-word)
		(define-key map "\M-b" 'org-emphasize-math)
		(define-key map "\M-v" 'org-view-pdf)
		(define-key map "l" 'org-view-latex)
        (define-key map "\M-l" 'org-toggle-latex-fragment)
        (define-key map "s" 'math-delimiter-add-space-inline)
		(define-key map "\M-h" 'org-view-html)
		(define-key map "\M-f" 'vimish-fold)
		(define-key map "\M-c" 'polymode-mark-or-extend-chunk)
		(define-key map "f" 'vimish-fold-toggle)
		(define-key map (kbd "<down>") 'polymode-next-chunk-same-type)
		(define-key map (kbd "<up>") 'polymode-previous-chunk-same-type)
map))

(define-key markdown-mode-map (kbd "<tab>") 'markdown-cycle)
(define-key markdown-mode-map (kbd "C-c C-<left>") 'markdown-promote-subtree)
(define-key markdown-mode-map (kbd "C-c C-<right>") 'markdown-demote-subtree)

)



(add-hook 'markdown-mode-hook 'pandoc-md-html-setup t)

;;---支持LaTeX公式 ------
; (setq markdown-enable-math t) ;; 在这里设置无效，要在custom.el 设置，不知道原因
(add-hook 'markdown-mode-hook 'cdlatex-mode)

;;支持文献引用，注意 rmd 文件中需使用注释行：[//]: # (\bibliography{bibfile})
(require 'reftex)
(add-hook 'markdown-mode-hook 'turn-on-reftex)
;; 还需 设置reftex-cite-format, 增加 (?m . "[@%l]") 以支持 Pandoc markdown的文献引用

(font-lock-add-keywords 'markdown-mode
  '(("\\[@.*?\\]" . font-lock-keyword-face)
    ("\\\\@ref(.*?)" . font-lock-keyword-face)
("{#eq:.*?}" . font-lock-keyword-face)
    ))

;;----------- folding vimish -----------
;(require 'vimish-fold)
;(add-hook 'markdown-mode-hook 'vimish-fold-mode)

(setq vimish-fold-header-width 65)
(defun markdown-fold-yaml-header ()
     (interactive)
     (beginning-of-buffer)   
     (if (string= (thing-at-point 'line t) "---\n")
       (progn
	 (require 'vimish-fold)
	 (vimish-fold-mode)
	 (mark-paragraph)
	 (vimish-fold (region-beginning) (region-end)) 
	 (message "Yaml header folded")
	      ))
     (markdown-outline-next) 
     ) 

(add-hook 'markdown-mode-hook 'markdown-fold-yaml-header)
(add-hook 'markdown-mode-hook 'auto-fill-mode)
  
;; --------- Manage Org-like lists in non-Org buffers
(require 'orgalist)
(add-hook 'markdown-mode-hook 'orgalist-mode)
(define-key orgalist-mode-map (kbd "M-<up>") 'orgalist-move-item-up)
(define-key orgalist-mode-map (kbd "M-<down>") 'orgalist-move-item-down)
(define-key orgalist-mode-map (kbd "M-S-<up>") 'orgalist-previous-item)
(define-key orgalist-mode-map (kbd "M-S-<down>") 'orgalist-next-item)
(define-key orgalist-mode-map (kbd "M-S-<down>") 'orgalist-next-item)
(define-key orgalist-mode-map (kbd "<M-RET>") 'markdown-insert-list-item)



;;========================================Markdown Mode Setup END=============================================
"Init Rmd"
(interactive)			
			)

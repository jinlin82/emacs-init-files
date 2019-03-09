(defun init-tex ()
(add-to-list 'load-path "~/.emacs.d/elpa/auctex-12.1.1/")  ;; auctex-11.87 版本加载很慢，多花了8s，11.88版本与emacs24.2不兼容
;;=============================================TeX Config================================================
(setq LaTeX-fill-break-at-separators nil)
(setq TeX-PDF-mode t)
(setq TeX-engine (quote xetex))
(setq TeX-math-close-double-dollar nil)
(setq TeX-source-correlate-method (quote synctex))
(setq TeX-source-correlate-mode t)
(setq preview-auto-cache-preamble t)
(setq preview-transparent-color t)
(setq cdlatex-math-modify-prefix 64)
(setq cdlatex-math-symbol-prefix 39)
; (setq cdlatex-paired-parens "$" ) ;; 注意与edit.el 中的 autopair的兼容问题,
(setq cdlatex-simplify-sub-super-scripts t)

;;Ultra-TeX Mode
;;(setq load-path (cons "/Universal/Custom/emacs/ultratex/lisp" load-path))
;;(require 'ultex-setup)

;; -------------Latex 中设置autopair
; (add-hook 'latex-mode-hook
	  ; #'(lambda ()
              ; (push '(?< . ?>)
                    ; (getf autopair-extra-pairs :everywhere))))

;;AUCTeX Customary Customization
(require 'tex-mik)
;;(add-hook 'LaTeX-mode-hook 'flyspell-mode) 开启拼写检查
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;;AUCTeX Math Mode
;; LaTeX-math-list 在 auctex 中已经修改，所以下面有错误
; (setq LaTeX-math-list
      ; '(
	; (?/ . "frac")
	; (?t . "text")
	; (?b. "boldsymbol")
	; ))

;; Fill Break


;; Using doc-view with auto-revert to view LaTeX PDF output in Emacs
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

;; ================================= Reftex and BibTeX =================================
(require 'reftex)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ;with AUCTeX LaTeX mode


(setq reftex-toc-split-windows-fraction 0.35)
(setq reftex-toc-split-windows-horizontally t)
(setq reftex-file-extensions '(("Rnw" ".Rnw" "nw" "tex" ".tex" ".ltx") ("bib" ".bib")))
(setq reftex-use-external-file-finders t)
(setq reftex-external-file-finders
      '(("tex" . "kpsewhich -format=.tex %f")
        ("bib" . "kpsewhich -format=.bib %f")))
		
;; RefTex 以citet和citep为默认选项
(setq reftex-cite-format 'natbib)

(eval-after-load 'reftex-vars
  '(progn
     ;; (also some other reftex-related customizations)
     (setq reftex-cite-format
           '(   
	  (?\C-m . "\\cite[][]{%l}")
	  (?t . "\\citet[][]{%l}")
	  (?T . "\\citet*[][]{%l}")
	  (?p . "\\citep[][]{%l}")
	  (?P . "\\citep*[][]{%l}")
	  (?e . "\\citep[e.g.][]{%l}")
	  (?s . "\\citep[see][]{%l}")
	  (?a . "\\citeauthor{%l}")
	  (?A . "\\citeauthor*{%l}")
	  (?y . "\\citeyear{%l}")
	  (?n . "\\nocite{%l}")
      (?m . "[@%l]")
	     ))))
			 

;; ============================== Ebib ================================ 
;;Ebib is a program for managing BibTeX databases, 类似于 JabRef
(autoload 'ebib "ebib" "Ebib, a BibTeX database manager." t)


;; ============================= END ==================================

	  
(setq TeX-file-extensions
      '( "Rnw" ".Rnw" "nw" "tex" "sty" "cls" "ltx" "texi" "texinfo"))


;; Outline Mode
(add-hook 'LaTeX-mode-hook 'outline-minor-mode)
(setq TeX-outline-extra
      '(("\\\\bibliography\\b" 2)))
(add-hook 'outline-minor-mode-hook
	  (lambda () (local-set-key "\M-o"
				    outline-mode-prefix-map)))

;;Suggestion about PDF generation and other commands
(setq my-tex-commands-extra (list
			     (list "All" "texify --tex-opt=--src %s.tex" 'TeX-run-command nil t)
			     (list "All pdf" "texify --pdf %s.tex" 'TeX-run-command nil t)
			     (list "pdfLaTeX" "pdflatex \\nonstopmode\\input %t" 'TeX-run-LaTeX nil t)
			     (list "fix" "fixbbl -cjk \"%s.bbl\"" 'TeX-run-command nil t)  ;;fixbbl 参考文献中文本地化解决方案
			     (list "u2g" "iconv.exe -f utf-8 -t gbk \"%s.bbl\" > \"%s.txt\" "  "del /s *.log"'TeX-run-command nil t)
			     (list "g2u" "iconv.exe -f gbk -t utf-8 \"%s.bbl\" > \"%s.txt\" " 'TeX-run-command nil t)
			     (list "d2p" "dvipdfmx \"%s.dvi\"" 'TeX-run-command nil t)
			     (list "dvips" "dvips %s.dvi" 'TeX-run-command nil t)
			     (list "ps2pdf" "ps2pdf %s.ps" 'TeX-run-command nil t)
			     (list "gbk2uni" "gbk2uni \"%s.out\"" 'TeX-run-command nil t)
			     (list "Yap" "yap -1 \"%dS\" \"%d\"" 'TeX-run-discard nil t)
			     (list "Gsview" "start .\\\"%s.ps\"" 'TeX-run-LaTeX nil t)
			     (list "pdf" "start .\\\"%s.pdf\"" 'TeX-run-command nil t)
			     (list "del" "del /s *.log *.aux *.eps *.dvi *.pdf %s.out %s.exa %s.ilg %s.idx
%s.ind %s.lof %s.lot %s.toc %s.bbl %s.blg ctextemp_*.*" 'TeX-run-command nil t)))



(require 'tex)
(setq TeX-command-list (append TeX-command-list my-tex-commands-extra))




;; Automatic Parsing of TeX Files 可以高亮package中的命令
(setq TeX-parse-self t) ; Enable parse on load.
(setq TeX-auto-save t) ; Enable parse on save.

;; To turn on CDLaTeX Minor Mode for all LaTeX files
(autoload 'cdlatex-mode "cdlatex" "CDLaTeX Mode" t)
(autoload 'turn-on-cdlatex "cdlatex" "CDLaTeX Mode" nil)
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode

;;;AucTeX Forword Search and Inverse Search
(add-to-list 'TeX-output-view-style
	     '("^dvi$" "."
	       "%(o?)xdvi -watchfile 1 %dS %d"))
(setq TeX-source-specials-mode 1)
(setq TeX-source-specials-view-start-server t)
(add-to-list 'TeX-command-list '("View" "%V" TeX-run-discard nil t))


;;;Count TeX Words
(defun my-latex-setup ()
  (defun latex-word-count ()
    (interactive)
    (let* ((this-file (buffer-file-name))
           (word-count
            (with-output-to-string
              (with-current-buffer standard-output
                (call-process "texcount" nil t nil "-unicode" "-logograms=+cjkpunctuation" this-file)))))
      (string-match "\n$" word-count)
      (message (replace-match "" nil nil word-count))))
  (define-key LaTeX-mode-map "\C-cw" 'latex-word-count))
(add-hook 'LaTeX-mode-hook 'my-latex-setup t)

;;; run bat file
;;;fixbbl setup
(defun my-fixbbl-setup ()
  (defun latex-utf8-fixbbl ()
    (interactive)
	(if (get-buffer "*Latex-Compile*")
    (kill-buffer "*Latex-Compile*")
    )		
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "runpdf.bat " (substring (buffer-name) 0 -4) ) )
    (message (concat "runpdf.bat " (substring (buffer-name) 0 -4) )))
  (define-key LaTeX-mode-map "\M-na" 'latex-utf8-fixbbl))
(add-hook 'LaTeX-mode-hook 'my-fixbbl-setup t)

(defun my-thesis-setup ()
  (defun latex-utf8-thesis ()
	(if (get-buffer "*Latex-Compile*")
    (kill-buffer "*Latex-Compile*")
    )	  
    (interactive)
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "thesispdf.bat " (substring (buffer-name) 0 -4) ) )
    (message (concat "thesispdf.bat " (substring (buffer-name) 0 -4) )))
  (define-key LaTeX-mode-map "\M-n\M-a" 'latex-utf8-thesis))
(add-hook 'LaTeX-mode-hook 'my-thesis-setup t)


;;SumatraPDF Forword Search
(require 'sumatra-forward)
(setq TeX-view-program-list '(("Sumatra" "Sumatra.bat %o %t %n") ))
(setq TeX-view-program-selection '((output-pdf "Sumatra") (output-dvi "Yap")))
;;================================================ LaTex Config END===========================================


"Init Tex"
(interactive)			
			)

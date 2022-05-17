(defun init-org ()

;; ===========以下信息适用 org-mode 9.0 以上版本=============================
;; ----------------必读：特别注意：----------------------
;; 为了防止emacs使用emacs安装文件夹中的org，把lisp\org文件改名为如lisp\org-9.1.9
;; 1. 为了与以前的org文件兼容， 修改了 ox-latex.el 中的 “\\” 的转换方式
;; 2. 为了在beamer生成的tex文件中不包含 latex-header-extra 的内容，修改了 ox-beamer.el 中的 (org-latex-make-preamble info) 部分
;; 3. 查找 Hacked by Jin Lin 可以找到这些修改的位置
;; 4. 注意不要使用 ox-latex.elc 和 ox-beamer.elc文件，删除之 或者重新编译
;; 5. 9.2以后版本中需要增加 (require 'org)
;; 6.  ;'(org-trello-current-prefix-keybinding "C-c o" nil (org-trello)) 必需注释掉，否则9.2版本会出错


;; ===========以下信息适用 org-mode 8.2.10 版本，已打包，并放在 elpa 文件夹中备份===
;;必读：特别注意：1. 修改了ox-beamer 文件，不包含	latex-header-extra语句，
;;2. 查找 在ox-beamer.el中查找latex-header-extra，
;;3. 注意不要使用ox-beamer.elc文件，删除之

;; ======================================================================
(add-to-list 'load-path "~/.emacs.d/elpa/org-20200224/")
;;(setenv "PATH" (concat "C:\\Worktools\\Bibtex2html;" (getenv "PATH")))



;;==========================================Org Mode Setup=============================================
(require 'org-install)
(require 'org)

(setq org-startup-numerated t)


(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cr" 'remember)

(setq org-log-done t)
(setq org-latex-tables-booktabs t)
(setq org-latex-tables-centered t)
(setq org-hide-emphasis-markers t)
(setq org-image-actual-width nil)

;;----------------- 设置各级标题样式 ----------------------
(set-face-attribute 'org-level-1 nil :height 1.1 :bold t :foreground "yellow4")
(set-face-attribute 'org-level-2 nil :height 1.1 :bold t)
(set-face-attribute 'org-level-3 nil :height 1.0 :bold t)

; (require 'org-bullets)
; (setq org-bullets-bullet-list  '("" "●" "○" "◆" "◇" "▹"))
; (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))


(require 'org-superstar)
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
(setq org-superstar-headline-bullets-list '("" "●" "○" "◆" "◇" "▹"))
(setq org-superstar-item-bullet-alist (quote ((42 . 8226) (43 . 8226) (45 . 8226))))
(setq org-superstar-leading-bullet "  ")

;;----------------- 设置 auto fill width -----------------
(add-hook 'org-mode-hook
          (lambda ()
            (set-fill-column 80)))

;; org-mode ignore heading when exporting to latex,用于参考文献标题等
(require 'ox-extra)
(ox-extras-activate '(ignore-headlines))

;;;-----------------------------------------------------------------------------
;; How do I make Org-mode open PDF files
(eval-after-load "org"
  '(progn
     ;; .txt files aren't in the list initially, but in case that changes
     ;; in a future version of org, use if to avoid errors
     (if (assoc "\\.txt\\'" org-file-apps)
         (setcdr (assoc "\\.txt\\'" org-file-apps) "notepad.exe %s")
       (add-to-list 'org-file-apps '("\\.txt\\'" . "notepad.exe %s") t))
     ;; Change .pdf association directly within the alist
     (setcdr (assoc "\\.pdf\\'" org-file-apps) "sumatrapdf %s")
	 (add-to-list 'org-file-apps '("\\.png\\'" . default))))

;;=======================================Org Mode Setup END ===========================================


;; ===================================== org babel Setup ========================================
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)         
(setq org-babel-inline-result-wrap "%s")   ;;Formatting output of inline org-mode source blocks

(defun org-insert-src-block (src-code-type)
  "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
  (interactive
   (let ((src-code-types
	  '("R" "emacs-lisp" "python" "text" "C" "sh" "java" "js" "clojure" "C++" "css"
	    "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
	    "octave" "oz" "plantuml" "sass" "screen" "sql" "awk" "ditaa"
	    "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
	    "scheme" "sqlite")))
     (list (ido-completing-read "Source code type: " src-code-types))))
  (progn
    (newline)
    (insert (format "#+BEGIN_SRC %s\n" src-code-type))
    (newline)
    (insert "#+END_SRC\n")
    (previous-line 2)
    ;;      (org-edit-src-code)
    ))

(defun org-insert-python-block ()
  (interactive)
  (progn
    (newline)
    (insert "#+BEGIN_SRC python :eval yes\n")
    (newline)
    (insert "\"\"\"END\"\"\"\n")	 
    (insert "#+END_SRC\n")
    (previous-line 3)
    ;;      (org-edit-src-code)
    ))	  

(define-key org-src-mode-map (kbd "C-c C-'") 'org-edit-src-exit)
(define-key org-mode-map "\M-ni" 'org-insert-src-block)
(define-key org-mode-map "\M-ny" 'org-insert-python-block)
;;  (define-key org-mode-map "\M-ne" 'org-edit-src-code)

; (require 'ob-ipython)       ;;  ob-ipython 与 polymode 冲突
(require 'ob-mermaid)
(require 'ob-asymptote)
(setq ob-mermaid-cli-path "~/../node-v10.15.1-win-x86/node_modules/mermaid-filter/node_modules/.bin/mmdc")
(setq org-plantuml-jar-path "~/../plantuml/plantuml.jar")
(setq org-confirm-babel-evaluate nil)

; ORG source code
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (R . t)  ;byte compiled ob-R.el by calling 【Meta+x】 byte-compile-file <path to org>/ob-R.el
   (asymptote . t)
   (python . t)
   (ipython . t)
   (sql . t)
   (plantuml . t)
   (ditaa . t)
   (dot . t)
   ))

(setq org-src-lang-modes
      (quote
       (("plantuml" . plantuml)
	("mermaid" . mermaid)
	("ipython" . python)
	("ocaml" . tuareg)
	("elisp" . emacs-lisp)
	("ditaa" . artist)
	("asymptote" . asy)
	("dot" . graphviz-dot)
	("sqlite" . sql)
	("calc" . fundamental)
	("C" . c)
	("cpp" . c++)
	("C++" . c++)
	("screen" . shell-script)
	("shell" . sh)
	("bash" . sh))))

(add-to-list 'org-babel-default-header-args:plantuml 
	     '(:cmdline . "-charset UTF-8")) 

;;--Code evaluation and security issues
(defun my-org-confirm-babel-evaluate-R (lang body)
  (not (string= lang "R"))  ; don't ask for R
;;  (not (string= lang "asymptote"))  ; don't ask for R
  )

(require 'org-R)

;; ================================ Org Babel Setup END ======================================

;;====================================== Export =========================================
(setq org-export-backends (quote (ascii beamer html icalendar latex odt md)))

;;------------------------ html export ---------------------------
;; 生成的html文件中不包含css 文件的内容，必需和css文件中同一个文件夹中css才起作用
(setq org-html-with-latex (quote verbatim))  ;; 方便word中mathtype处理latex代码
(setq org-html-extension "htm") ;; 与 ox-twbs 输出区分

(defun org-html-twbs-export ()
 (org-twbs-export-to-html)
    (interactive)
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "open " (substring (buffer-name) 0 -4) ".html"))
    (message (concat "Open " (substring (buffer-name) 0 -4) ".html")))
	
(define-key org-mode-map "\M-nh" 'org-html-twbs-export)

;;------------------------ latex export ---------------------------
(setq org-latex-text-markup-alist
   (quote
    ((bold . "\\textbf{%s}")
     (code . verb)
     (italic . "\\emph{%s}")
     (strike-through . "\\sout{%s}")
     (underline . "\\uline{%s}")
     (verbatim . "\\setlength{\\fboxsep}{0pt}\\colorbox{Periwinkle!20}{\\strut \\texttt{\\ %s\\ }}"))))

;; ==================================== Latex Math =====================================
(add-hook 'org-mode-hook 'turn-on-org-cdlatex)
;;LaTeX math mode ($…$) font color in org mode
(setq org-highlight-latex-and-related (quote (latex)))

(setq org-entities-user '(("$" "$" nil " " " " " " " ")))
(setq org-emphasis-alist (quote (
				 ("*" bold)
				 ("/" italic)
				 ("_" underline)
				 ("=" org-verbatim verbatim)
				 ("~" org-code verbatim)
				 ("+" (:strike-through t :foreground "red"))
				 ("$" math))))


(defun org-emphasize-word (&optional char)
  (interactive)
  (unless (region-active-p)
    (mark-word))
  (org-emphasize char))
  
(defun org-emphasize-math-word ()
(interactive)
 (org-emphasize-word ?$)
 )

(defun org-emphasize-math ()
(interactive)
 (org-emphasize ?$)
 )

(define-key org-mode-map (kbd "M-n M-m") 'org-emphasize-math)
(define-key org-mode-map (kbd "M-n m") 'org-emphasize-math-word)


(defun replace-regexp-math-delimiter-display(beg end)
  (interactive "*r")
  (let ((beg (if (region-active-p)
                 (region-beginning)
               (line-beginning-position)))
        (end (if (region-active-p)
                 (region-end)
               (line-end-position))))
    (save-restriction
      (narrow-to-region beg end)
      (save-excursion
	(goto-char (point-min))
	
	(while (search-forward-regexp " \\\\\\]" nil t)
	  (replace-match "\\\\]" nil nil))))
    (save-restriction
      (narrow-to-region beg end)
      (save-excursion
	(goto-char (point-min)) 
	(while 
	    (search-forward-regexp "\\\\\\[\\([^]]*?\\)\\\\\\]" nil t)
	  (replace-match " $\\1$ " nil nil))))
    ))

(defun replace-regexp-math-delimiter-inline(beg end)
  (interactive "*r")
  (let ((beg (if (region-active-p)
                 (region-beginning)
               (line-beginning-position)))
        (end (if (region-active-p)
                 (region-end)
               (line-end-position))))
    (save-restriction
      (narrow-to-region beg end)
      (save-excursion
	(goto-char (point-min)) 
	(while 
	    (search-forward-regexp "\\$\\([^]]*?\\)\\$" nil t)
	  (replace-match "\\\\[\\1\\\\]" nil nil))))

    ))

(defun math-delimiter-add-space-inline(beg end)
  (interactive "*r")
  (let ((beg (if (region-active-p)
                 (region-beginning)
               (line-beginning-position)))
        (end (if (region-active-p)
                 (region-end)
               (line-end-position))))
    (save-restriction
      (narrow-to-region beg end)
      (save-excursion
	(goto-char (point-min)) 
	(while 
	    (search-forward-regexp "\\(^\\|[^$\n]\\) *\\$\\([^$\n]+?\\)\\$ *" nil t)
	  (replace-match "\\1 $\\2$ " nil nil))))
    ))
	
(defun math-delimiter-add-newline-for-typora(beg end)
  (interactive "*r")
  (let ((beg (if (region-active-p)
                 (region-beginning)
               (point-min)))
        (end (if (region-active-p)
                 (region-end)
              (point-max))))
    (save-restriction
      (narrow-to-region beg end)
      (save-excursion
	(goto-char (point-min)) 
	(while 
	  (search-forward-regexp "^ *\\(\\$\\$\\)\\([^ \n]\\)" nil t)
	  (replace-match "\\1\n\\2" nil nil))))
    (save-restriction
      (narrow-to-region beg end)
      (save-excursion
	(goto-char (point-min)) 
	(while 
	  (search-forward-regexp "\\(.\\)\\(\\$\\$\\) *$" nil t)
	  (replace-match "\\1\n\\2" nil nil))))
    ))

(define-key org-mode-map (kbd "M-n d") 'replace-regexp-math-delimiter-display)
(define-key org-mode-map (kbd "M-n M-d") 'replace-regexp-math-delimiter-inline)

(define-key org-mode-map (kbd "C-x vk") '(lambda () (interactive) (org-emphasize ?\=)))
(define-key org-mode-map (kbd "C-x vt") '(lambda () (interactive) (org-emphasize ?\~)))
(define-key org-mode-map (kbd "C-x vb") '(lambda () (interactive) (org-emphasize ?\*)))
(define-key org-mode-map (kbd "C-x vr") '(lambda () (interactive) (org-emphasize ?\ )))

;; =============================== Latex Math END ===================================

;; =================================== Latex Export Packages=========================
(setq org-latex-default-packages-alist (quote (
"\\usepackage{xeCJK}
\\setCJKmainfont[BoldFont=AdobeHeitiStd-Regular]{AdobeSongStd-Light}
\\setCJKfamilyfont{song}{AdobeSongStd-Light}
\\setCJKfamilyfont{hei}{AdobeHeitiStd-Regular}
\\setCJKfamilyfont{kai}{AdobeKaitiStd-Regular}
\\setCJKfamilyfont{fs}{Sun Yat-sen Hsingshu}

\\renewcommand{\\contentsname}{\\centerline{\\textcolor{violet}{目 \\ \\ 录}}}    % 将Contents改为目录
\\renewcommand{\\abstractname}{摘 \\ \\ 要}      % 将Abstract改为摘要
\\renewcommand{\\refname}{参考文献}            % 将Reference改为参考文献
\\renewcommand\\tablename{表}
\\renewcommand\\figurename{图}
\\renewcommand{\\today}{\\number\\year 年 \\number\\month 月 \\number\\day 日}

\\usepackage[dvipsnames]{xcolor}
\\PassOptionsToPackage{colorlinks=true,citecolor=blue, urlcolor=blue, linkcolor=violet, bookmarksdepth=4}{hyperref}

\\usepackage{lscape}
\\usepackage{indentfirst}
\\usepackage{textcomp}                      % provide many text symbols
\\usepackage{setspace}                      % 各种间距设置


% ---------------------------------Table------------------------------
\\usepackage{booktabs}
\\usepackage{array}                         % 提供表格中每一列的宽度及位置支持
\\usepackage{multirow}
\\usepackage{rotating}
\\newcolumntype{L}[1]{>{\\raggedright\\let\\newline\\\\\\arraybackslash\\hspace{0pt}}m{#1}}
\\newcolumntype{C}[1]{>{\\centering\\let\\newline\\\\\\arraybackslash\\hspace{0pt}}m{#1}}
\\newcolumntype{R}[1]{>{\\raggedleft\\let\\newline\\\\\\arraybackslash\\hspace{0pt}}m{#1}}

%\\sloppy
%\\linespread{1.0}                           % 设置行距
\\setlength{\\parindent}{22pt}
%\\setlength{\\parskip}{1ex plus 0.5ex minus 0.2ex}

\\newcommand\\hmmax{0} %% 防止Too many math alphabets used in version normal.
\\newcommand\\bmmax{0} %% 防止Too many math alphabets used in version normal.

"
					       ("AUTO" "inputenc" t)
					       ;; ("T1" "fontenc" nil)  ;;  % [T1] 主要支持东欧等国家重音符, 与下面 consolas 冲突，引入T1目的是与下面upquote=true配合，支持竖引号
					       ("" "fontenc" nil)
					       ("" "fixltx2e" nil)
					       ("" "graphicx" t)
					       ("" "longtable" nil)
					       ("" "float" nil)
					       ("" "wrapfig" nil)
					       ("" "soul" t)
					       ("" "textcomp" nil)
					       ("" "lmodern,bm" t) ;; % 必需出现在amsmath等包前面，否则会出错
					       ("" "amsmath" t)
					       ("" "marvosym" t)
					       ("" "wasysym" t)
					       ("" "latexsym" t)
					       ("" "amssymb" t)
					       ("" "hyperref" nil)
					       ("" "listings" t)
					       ("" "tikz" t)
					       "
						   
\\setmonofont{Consolas} % listings 中支持 consolas 字体，必需配合上面usepackage{fontenc} 中不出现[T1]才可以

\\lstset{numbers=left, numberstyle=\\ttfamily\\tiny\\color{Gray}, stepnumber=1, numbersep=8pt,
  frame=leftline,
  framexleftmargin=0mm,
  rulecolor=\\color{CadetBlue},
  backgroundcolor=\\color{Periwinkle!20},
  stringstyle=\\color{CadetBlue},
  flexiblecolumns=false,
  aboveskip=5pt,
  belowskip=0pt,
  language=R,
  basicstyle=\\fontshape{sl}\\ttfamily\\footnotesize,
  columns=flexible,
  keepspaces=true,
  breaklines=true,
  extendedchars=true,
  texcl=false,  % 必须设置为false设置为true的时候 R 代码中不能含有多个注释符号 #
  upquote=true, % 设置 引号为竖引号，但必需配合 上面 fontenc T1 使用，fontenc T1 又不能使用 consolas，所以冲突
  showstringspaces=false,
  keywordstyle=\\bfseries,
  keywordstyle=\\color{Purple},
  xleftmargin=20pt,
  xrightmargin=10pt,
  morecomment=[s]{\\#}{\\#},
  commentstyle=\\color{OliveGreen!60}\\scriptsize,
  tabsize=4
  }
"
					       "\\tolerance=1000")))
;; ============================== Latex Export Packages END =========================


;; ================================== Latex Compile =================================
(setq org-latex-compiler "xelatex")
(setq org-latex-listings 'listings)
(setq org-latex-listings-options'( ("numbers" "left") ))

;; 设置org mode to latex 的引擎为 xelatex
(setq org-latex-pdf-process '("xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-to-pdf-process '("xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f"))


(defun my-org-setup ()
  (defun org-latex-utf8-fixbbl ()
    (interactive)
    (progn
    (save-excursion
    (goto-char (point-min))
    (insert "#+LATEX_CLASS_OPTIONS: [UTF8,a4paper,12pt]{ctexart} %注释掉后面的内容\n")
    (save-buffer))
    (org-latex-export-to-latex)
)
	(if (get-buffer "*Latex-Compile*")
    (kill-buffer "*Latex-Compile*"))
    (start-process-shell-command "article-xelatex" "*Latex-Compile*"  (concat "runpdf-org.bat " (substring (buffer-name) 0 -4) ))
    (save-excursion
    (goto-char (point-min))
    (kill-whole-line)
    (save-buffer))
    (message (concat "runpdf-org.bat " (substring (buffer-name) 0 -4) )))

  (defun org-beamer-utf8-fixbbl ()
    (interactive)
    (progn
    (save-excursion
    (goto-char (point-min))
    (insert "#+LATEX_CLASS_OPTIONS: [11pt,xcolor=dvipsnames,aspectratio=1610,hyperref={colorlinks,allcolors=.,urlcolor=blue,bookmarksdepth=4}]\n")
    (save-buffer))
    (org-beamer-export-to-latex)
    ;; 把 ox-beamer 生成的tex中的tab化为space
    (find-file-literally (concat (substring (buffer-name) 0 -4) ".tex"))
    (untabify (point-min) (point-max))
    (save-buffer)
    (kill-buffer)
    )
	(if (get-buffer "*Latex-Compile*")
	  (kill-buffer "*Latex-Compile*"))  
;; 注意：1. 由于用于中文作者排序的fixbbl.exe与beamer冲突，故在runbeamer-org.bat中删除了关于fixbbl.exe的功能
;;       2. 在生成beamer时未使用 natbib 包，如想使用中括号上标引用，可如在生成article中一样，使用natbib语句
    (start-process-shell-command "beamer-xelatex" "*Latex-Compile*"  (concat "runbeamer-org.bat " (substring (buffer-name) 0 -4)))
    (save-excursion
    (goto-char (point-min))
    (kill-whole-line)
    (save-buffer))
    (message (concat "runbeamer-org.bat " (substring (buffer-name) 0 -4) )))

 (setq org-beamer-outline-frame-title "\\CJKfamily{kai}\\textcolor{violet}{\\bfseries\\LARGE 大\\ \\ 纲 }} \\textcolor{violet}{")

 (defun org-view-pdf ()
   (interactive)
   (if (file-exists-p (concat (substring (buffer-name) 0 -4) "_beamer.pdf"))
       (start-process-shell-command "nil" "*Latex-Compile*"  (concat "open " (substring (buffer-name) 0 -4) "_beamer.pdf"))
     (start-process-shell-command "nil" "*Latex-Compile*"  (concat "open " (substring (buffer-name) 0 -4) ".pdf")))
     (message (concat "Open " (substring (buffer-name) 0 -4) ".pdf")))
	
  (defun org-view-html ()
    (interactive)
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "open " (substring (buffer-name) 0 -4) ".html"))
    (message (concat "Open " (substring (buffer-name) 0 -4) ".html")))

  (defun org-view-latex ()
    (interactive)
    (if (file-exists-p (concat (substring (buffer-name) 0 -4) "_beamer.tex"))
	(start-process-shell-command "nil" "*Latex-Compile*"  (concat "open " (substring (buffer-name) 0 -4) "_beamer.tex"))
	(start-process-shell-command "nil" "*Latex-Compile*"  (concat "open " (substring (buffer-name) 0 -4) ".tex"))
      )
    (message (concat "Open " (substring (buffer-name) 0 -4) ".tex")))

  (define-key org-mode-map "\M-na" 'org-latex-utf8-fixbbl)
  (define-key org-mode-map "\M-nb" 'org-beamer-utf8-fixbbl)
  (define-key org-mode-map "\M-n\M-v" 'org-view-pdf)
  (define-key org-mode-map "\M-n\M-h" 'org-view-html)
  (define-key org-mode-map "\M-nl" 'org-view-latex)
  (define-key org-mode-map "\M-n\M-l" 'helm-imenu)
  (define-key org-mode-map (kbd "C-c C-;") 'org-toggle-comment)
  (define-key org-mode-map (kbd "C-,") 'springboard)
  (define-key org-mode-map (kbd "C-'") 'imenu-list)
)
  
(add-hook 'org-mode-hook 'my-org-setup t)
;; ================================== Latex Compile END =================================

;; ================================ EXPORT with PANDOC ==================================
(defun org-export-to-markdown-with-pandoc ()
    (interactive)
	(save-buffer)
  (start-process-shell-command "OrgtoMd" "*Pandoc-Compile*"  (concat "pandocOrgMd.bat " (file-name-sans-extension (buffer-name)) ) )
  (message (concat "export to md with pandoc "  (buffer-name))))
  
  ; (define-key org-mode-map "\M-nm" 'org-export-to-markdown-with-pandoc)
  
(defun org-export-to-docx-with-pandoc ()
    (interactive)
	(save-buffer)
  (start-process-shell-command "OrgtoDocx" "*Pandoc-Compile*"  (concat "pandocOrgDocx.bat " (file-name-sans-extension (buffer-name)) ) )
  (message (concat "export to docx with pandoc "  (buffer-name))))
  
(define-key org-mode-map "\M-nd" 'org-export-to-docx-with-pandoc)
;; ================================EXPORT with PANDOC END=================================


;; ================================= 中文空格问题处理 ==================================
;;---- 处理输出html换行会被解析成空格问题---------------------------------
(defadvice org-html-paragraph (before fsh-org-html-paragraph-advice
                                      (paragraph contents info) activate)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
  (let ((fixed-contents)
        (orig-contents (ad-get-arg 1))
        (reg-han "[[:multibyte:]]"))
    (setq fixed-contents (replace-regexp-in-string
                          (concat "\\(" reg-han "\\) *\n *\\(" reg-han "\\)")
                          "\\1\\2" orig-contents))
    (ad-set-arg 1 fixed-contents)
    ))

;;---- twbs 中文空格问题
(defadvice org-twbs-paragraph (before fsh-org-twbs-paragraph-advice
                                      (paragraph contents info) activate)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to odt."
  (let ((fixed-contents)
        (orig-contents (ad-get-arg 1))
        (reg-han "[[:multibyte:]]"))
    (setq fixed-contents (replace-regexp-in-string
                          (concat "\\(" reg-han "\\) *\n *\\(" reg-han "\\)")
                          "\\1\\2" orig-contents))
    (ad-set-arg 1 fixed-contents)
    ))	

;;---- 处理输出odt换行会被解析成空格问题----------------------------------
(defadvice org-odt-paragraph (before fsh-org-odt-paragraph-advice
                                      (paragraph contents info) activate)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to odt."
  (let ((fixed-contents)
        (orig-contents (ad-get-arg 1))
        (reg-han "[[:multibyte:]]"))
    (setq fixed-contents (replace-regexp-in-string
                          (concat "\\(" reg-han "\\) *\n *\\(" reg-han "\\)")
                          "\\1\\2" orig-contents))
    (ad-set-arg 1 fixed-contents)
    ))
;; ================================ 中文空格问题处理 END ==================================


;; ============================== RefTex and  BibTex =================================
;; 基本设置见 tex.el 中 RefTex and  BibTex 设置部分
;; 1. bibtex-mode: Emacs自带bib文件mode；2. ebib：类似于JabRef 的bib管理package
;; 3. reftex-mode(org-reftex-mode): 用于插入文献等交叉引用
;; 4. helm-bibtex -> org-ref: 类似于 reftex-mode, 但功能更强大
;; 5. ox-bibtex -> ox-bibtex-chinese: 用于org-mode参考文献输出，特别是html格式的输出

(require 'ox-bibtex) ;; 要出现在 下段代码 使用上标 之前，ox-bibtex 需要bibtex2html.exe 支持
(require 'ox-bibtex-chinese) ;; 支持 GB7714 样式
(ox-bibtex-chinese-enable)
(setq ox-bibtex-chinese-default-bibtex2html-options
   (quote ("-a" "-nobibsource" "-noabstract" "-nokeywords" "-i" "-nolinks")))
;; 样式在 ox-bibtex-chinese-default-bibtex-style 变量中设置


;; 在org文件中 增加以下语句
;;# \bibliography{Bibfile}  % 使用该注释行让 org-ref 找到本地bib文件
;;#+BIBLIOGRAPHY: Bibfile nil limit:t


;; 注意： 在html输出中参考文献引用使用上标, 对来自ox-bibtex.el 原代码进行了hack，具体见ox-bibtex.el文件
(setq org-ref-completion-library 'org-ref-helm-bibtex)
(require 'org-ref)

(setq bibtex-completion-additional-search-fields '(journal))
(setq bibtex-completion-display-formats-internal 
 (quote ((t . "${=type=:9} ${year:6} ${=key=:15} ${author:26} ${title:*} ${=has-pdf=:2} ${=has-note=:2}${journal:36}"))))
(setq bibtex-completion-display-formats
   (quote ((t . "${=type=:9} ${year:6} ${=key=:15} ${author:26} ${title:*} ${=has-pdf=:2} ${=has-note=:2}${journal:36}"))))

;(defun org-mode-reftex-setup ()
  ;(load-library "reftex")
  ;(and (buffer-file-name)
       ;(file-exists-p (buffer-file-name))
       ;(reftex-parse-all))
  (define-key org-mode-map (kbd "C-c )") 'reftex-reference)
  (define-key org-mode-map (kbd "C-c (") 'reftex-label)
  (define-key org-mode-map (kbd "C-c [") 'org-reftex-citation)
  (define-key org-mode-map (kbd "C-c ]") 'org-ref-helm-insert-cite-link)
  ;)
;(add-hook 'org-mode-hook 'org-mode-reftex-setup)

(org-add-link-type "ebib" 'ebib)
;; =============================== RefTex and BibTex END ==================================



;; ==================================== org latex preview setup =======================================
;;注意: 使用 dvisvgm 程序会使用 latex.exe 编译，速度快，并且svg文件清晰度好，但svg 文件大，公式中中文不能显示
;;注意: 使用 dvipng 程序会使用 latex.exe 编译，速度快，png 文件小，公式中中文不能显示
;;注意：使用 imagemagick 程序可以显示公式中的中文，但必需使用 xelatex.exe 编译，速度慢，png清晰度差
;;注意：由于imagemagick的程序 convert.exe 与 window格式转化程序 convert.exe 同名，故需要处理，否则或出错，
;;查找convert.exe  evernote中的相关说明. 24.5中 org latex preview失效，24.2没有问题，与org版本无关，不知何种原因
(setq org-latex-create-formula-image-program 'dvipng) 

(setq org-format-latex-options
   (quote
    (:foreground "DeepPink" :background default :scale 2.5 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
		 ("begin" "$1" "$" "$$" "\\(" "\\["))))

(setq org-preview-latex-process-alist
      (quote
       ((dvipng :programs
		("latex" "dvipng")
		:description "dvi > png" 
		:message "you need to install the programs: latex and dvipng." 
		:image-input-type "dvi" 
		:image-output-type "png" 
		:latex-header
"\\usepackage[dvipsnames]{xcolor}
\\usepackage{color}
\\usepackage{amsmath}
\\usepackage[mathscr]{eucal}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
% Package fixltx2e omitted
\\usepackage{graphicx}
% Package longtable omitted
% Package float omitted
% Package wrapfig omitted
\\usepackage[normalem]{ulem}
\\usepackage{textcomp}
\\usepackage{marvosym}
\\usepackage{wasysym}
\\usepackage{latexsym}
\\usepackage{amssymb}
\\usepackage{unicode-math}

% Package amstext omitted
% Package hyperref omitted"
		:image-size-adjust (1.0 . 1.0)
		:latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
		:image-converter ("dvipng -fg \"rgb 1 0.0784314 0.576471\" -D %D -T tight -o %O %f"))
	(dvisvgm :programs
		 ("latex" "dvisvgm")
		 :description "dvi > svg" 
		 :message "you need to install the programs: latex and dvisvgm." 
		 :use-xcolor t 
		 :image-input-type "dvi" 
		 :image-output-type "svg" 
		 :image-size-adjust (4.0 3.5)
		 :latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
		 :image-converter ("dvisvgm %f -n -b min -c %S -o %O"))
	(imagemagick :programs
		     ("latex" "convert")
		     :description "pdf > png" 
		     :message "you need to install the programs: latex and imagemagick." 
		     :use-xcolor t 
		     :image-input-type "pdf" 
		     :image-output-type "png" 
		     :image-size-adjust (1.7 . 1.5)
		     :latex-compiler ("xelatex -interaction nonstopmode -output-directory %o %f")
		     :image-converter ("convert -density %D -trim -antialias %f -quality 100 %O")))))
;; ================================== org latex preview setup END ======================================



;; =================================== trello ==================================
;; 注意：trello时间消耗太多
;; 注意：Headline 与内容中间不要空行，否则出现问题！！！
;; 在安卓app中设置后sort by date create(newest first) 乱码
;; 如何单个head乱码，可试试同步整个buffer
;; 单个head乱码, 可在description 位置加入中文后同步试试
;; 乱码问题最终解决：要设置 coding-system-for-read 变量为 'utf-8 ，但设置后 rconsole
;; 和 python inferior 模式等中文乱码，因此通过 add-hook 把其值设置为local

(require 'org-trello)

(add-hook 'org-trello-mode-hook (lambda () (set (make-local-variable 'coding-system-for-read) 'utf-8)))
;(add-hook 'org-mode-hook 'org-trello-mode)
;; org-trello major mode for all .trello files
; (add-to-list 'auto-mode-alist '("\\.trello$" . org-mode))
; (setq org-trello-files (list (concat prepath "Works/Org/trello/main.trello"))
                        ; (concat prepath "Works/Org/trello/doc.org")))
						
;;; Automatic org-trello files in emacs
;; add a hook function to check if this is trello file, then activate the org-trello minor mode.


(defun my/org-mode-hook-org-trello-mode ()
  (when (and (buffer-file-name)
             (string-match "\\.trello.org$" (buffer-file-name)))
    (message "Turning on org-trello in %s" (buffer-file-name))
    (org-trello-mode)
    (defun org-trello-sync-card-utf-8 ()
      (interactive)
      (progn 
	(setq coding-system-for-read 'utf-8) 
	(setq current-prefix-arg '(4)) ; C-u
	(call-interactively 'org-trello-sync-card)
	;; (setq coding-system-for-read nil)
	)  )
    ))
		  
(add-hook 'org-mode-hook #'my/org-mode-hook-org-trello-mode)


;; =================================== Capture ===================================
;;Capture 不出错要在setq org-agenda-files中设置文件
(setq org-default-notes-file (concat prepath "Works/Org/notes.org"))
(define-key global-map "\C-cc" 'org-capture)

(defun org-capture-with-prefix-arg ()
  (interactive)
  (setq current-prefix-arg '(4)) ; C-u
  (call-interactively 'org-capture))

(global-set-key (kbd "C-x C-d") 'org-capture-with-prefix-arg)

(setq org-capture-templates
`(
  ; ("n" "Notes" entry (file+headline (concat prepath "Works/Org/Notes.org") "Notes")
   ; "* %?\n %i\n %a")
  ;("t" "Todo" entry (file+headline (concat prepath "Works/Org/Tasks.org") "Tasks"))
   ;"* TODO %?\n %i\n %a")
  ("t" "Mixed" entry (file ,(concat prepath "Works/Org/Mixed.trello.org"))
   "* TODO %?\n %i\n %a" :unnarrowed t :empty-lines 1)
  ("m" "Trello" entry (file ,(concat prepath "Works/Org/Main.trello.org"))
   "* TODO %?\n %i\n %a" :prepend t)
  ("w" "Work" checkitem (file+headline ,(concat prepath "Works/Org/Main.trello.org") "Work Task")
   "[ ] %?\n %i\n %a")
  ("i" "Ideas" item (file+headline ,(concat prepath "Works/Org/Memos.trello.org") "Ideas")
   " %?\n %i\n %a")
  ("j" "Journal" entry (file+datetree ,(concat prepath "Works/Org/journal.org"))
   "* %?\nEntered on %U\n %i\n %a")
  ("l" "Learning" entry (file+headline ,(concat prepath "Works/Org/learning/learning.org") "Unorganized")
   "* %?\n \n %i\n %a")
))

(setq org-archive-location (concat prepath "Works/org/archive.org::* Completed Tasks From %s"))

(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/DONE" 'file))  ;; if you use 'agenda or 'tree scope instead of 'file, then it will apply to all registered agenda files.

;; =========================== Globle Agenda, TODOs =============================
(setq org-agenda-files (list (concat prepath "Works/Org/Todoist.org")
			 (concat prepath "Works/Org/Main.trello.org")
			     (concat prepath "Works/Org/Memos.trello.org")
			     (concat prepath "Works/Org/Mixed.trello.org")
			     (concat prepath "Works/Org/archive.org")
                             ;(concat prepath "Works/Org/ideas.org")
			     ;(concat prepath "Works/Org/soft.org")
			     ;(concat prepath "Works/Org/statmethods.org")
			     ;(concat prepath "Works/Org/reimburse.org")                             
                             (concat prepath "Works/Org/journal.org")
			     ;(concat prepath "Works/Org/notes.org")
			     ;(concat prepath "Works/Org/funds.org")
			     (concat prepath "Works/Org/learning/learning.org")
			     ;(concat prepath "Works/Org/Tasks.org")

			     ))
				 


(require 'todoist)
(find-file-noselect (concat prepath "Works/Org/Todoist.org"))
(with-current-buffer "Todoist.org"
(revert-buffer-with-coding-system-no-confirm 'utf-8)
(todoist-mode)
)

(execute-kbd-macro (read-kbd-macro "C-c a n"))
(org-agenda-goto-today)


;; Set refile targets to agenda files
(setq org-refile-targets '((nil :maxlevel . 2)
                           (org-agenda-files :maxlevel . 2)))
(setq org-refile-use-outline-path (quote buffer-name))  ; Refile in a single go
(setq org-refile-use-outline-path t)
;; =================================== END =======================================

;; ================================ org-download ================================= 
(require 'org-download)
(setq-default org-download-image-dir "./images")
(setq-default org-download-heading-lvl nil)
(setq-default org-download-timestamp "")


;; ================================ USE ploymode =================================
;; 要放在最下面，否则与org-capture冲突
;; 要从github版本替换掉mepha版本，并且删掉 autoload 等文件，只留下 poly-org.el 文件
;; org中的python代码块最后一句运行有问题，主要是和elpy-shell-send-statement-and-step有关系，因为会超越代码块范围寻找statement
(require 'poly-org)
(add-to-list 'auto-mode-alist '("\\.org" . poly-org-mode))

;; ================================= dot graph using org-mode: org-mind-map  ================================
;; 注意：为了避免 node上的表格线，对org-mind-map中的源代码进行了hack
;; 增加了 border=\"0\"   (concat "[label=<<table border=\"0\">" 
;; This is an Emacs package that creates graphviz directed graphs from
;; the headings of an org file
(use-package org-mind-map
  :init
  (require 'ox-org)
  :ensure t
  ;; Uncomment the below if 'ensure-system-packages` is installed
  ;;:ensure-system-package (gvgen . graphviz)
  :config
  (setq org-mind-map-engine "dot")       ; Default. Directed Graph
  ;; (setq org-mind-map-engine "neato")  ; Undirected Spring Graph
  ;; (setq org-mind-map-engine "twopi")  ; Radial Layout
  ;; (setq org-mind-map-engine "fdp")    ; Undirected Spring Force-Directed
  ;; (setq org-mind-map-engine "sfdp")   ; Multiscale version of fdp for the layout of large graphs
  ;; (setq org-mind-map-engine "twopi")  ; Radial layouts
  ;; (setq org-mind-map-engine "circo")  ; Circular Layout
  )

(setq org-mind-map-default-graph-attribs
   (quote
    (("autosize" . "false")
     ("size" . "9,12")
     ("resolution" . "100")
     ("nodesep" . "0.75")
     ("overlap" . "false")
     ("spline" . "true")
     ("rankdir" . "LR"))))

(setq org-mind-map-default-node-attribs
   (quote
    (("fontname" . "microsoft yahei")
     ("fontsize" . "20")
     ("shape" . "box"))))


(require 'orgalist)


(defun org-todo-list-current-file (&optional arg)
  "Like `org-todo-list', but using only the current buffer's file."
  (interactive "P")
  (let ((org-agenda-files (list (buffer-file-name (current-buffer)))))
    (if (null (car org-agenda-files))
        (error "%s is not visiting a file" (buffer-name (current-buffer)))
      (org-todo-list arg))))

;; -------------------- todoist ----------------------------
;; 注意: 需要修改 todoist.el 源代码, 见https://github.com/abrochard/emacs-todoist/issues/17
(setq todoist-token "2d9fb5e5a53b0d2ddaeacf34f9d1744fdad06cd0")
(setq todoist-backing-buffer (concat prepath "Works/Org/Todoist.org")) ;; 注意大小写要完全一致
(setq todoist-show-all t)

(define-key global-map "\C-x\C-t" 'todoist)



;; Automatically toggle org-mode latex fragment previews  
(defalias #'org-latex-preview #'math-preview-at-point)
(defalias #'org-clear-latex-preview #'math-preview-clear-region)
(setq math-preview-inline-style t)
(setq math-preview-margin (quote (2 . 1)))
(setq math-preview-raise 0.20)
(setq math-preview-relief 0)
(setq math-preview-scale 1.0)
(setq math-preview-scale-increment 0.1)
(setq math-preview-marks '(("\\begin{equation}" . "\\end{equation}")
                        ("\\begin{equation*}" . "\\end{equation*}")
                        ("\\[" . "\\]")
                        ("\\(" . "\\)")
                        ("$$" . "$$")
                        ("$" . "$")))
(setq math-preview-preprocess-functions '((lambda (s)
                                         (concat "{\\Large\\color{blue}" s "}"))))



(require 'org-fragtog)
(add-hook 'org-mode-hook 'org-fragtog-mode)
(add-hook 'markdown-mode-hook 'org-fragtog-mode)

;;---- org-latex-impatient
; (require 'org-latex-impatient)
; (add-hook 'org-mode-hook org-latex-impatient-mode)
  ; (setq org-latex-impatient-tex2svg-bin
        ; location of tex2svg executable
        ; "C:/Users/JL/node_modules/.bin/tex2svg")

;; Org-Projectile
(require 'org-projectile)

;; HACK org-projectile functions
(defun org-projectile-io-action-permitted (filepath)
  (or org-projectile-allow-tramp-projects
      (if (not filepath) t (find-file-name-handler filepath 'file-truename)) ;; Hacked by Jin Lin
	  ))

(defun org-projectile-project-root-of-filepath (filepath)
  (when (org-projectile-io-action-permitted filepath)
    (let ((dir (if (not filepath) ;; Hacked by Jin Lin
	(if (projectile-project-root)  (projectile-project-root) default-directory)
	(file-name-directory filepath)
	)))
      (--some (let* ((cache-key (format "%s-%s" it dir))
                     (cache-value (gethash
                                   cache-key projectile-project-root-cache)))
                (if cache-value
                    cache-value
                  (let ((value (funcall it dir)))
                    (puthash cache-key value projectile-project-root-cache)
                    value)))
              projectile-project-root-files-functions))))
			  
(defun org-projectile-get-project-todo-file (project-path)
	(if project-path 
  (let ((project-todos-filepath
         (if (stringp org-projectile-per-project-filepath)
             org-projectile-per-project-filepath
           (funcall org-projectile-per-project-filepath project-path)))
        (org-projectile-directory
         (if org-projectile-projects-directory
             org-projectile-projects-directory
           (file-name-as-directory project-path))))
    (concat org-projectile-directory project-todos-filepath))
	org-projectile-projects-file))
;; -------------------------------------------------------

(setq org-projectile-projects-file
      (concat prepath "Works/Org/ProjectsTODO.org"))
(push (org-projectile-project-todo-entry) org-capture-templates)
(setq org-agenda-files (append (org-projectile-todo-files) org-agenda-files))
(org-projectile-per-project)
(global-set-key (kbd "C-c p n") 'org-projectile-project-todo-completing-read)


(add-hook 'org-mode-hook #'ws-butler-mode)

(require 'peg)
(require 'org-ql)
(require 'org-sidebar)

;;========================================Org Mode Setup END=============================================
"Init Org"
(interactive)			
			)

(defun init-start ()

;; 拷到U盘中作两处修改：1. 修改路径名，把所有文件中的 C:\ 修改成 H:\， 2. 把face.el中的字体从 Consola 修改成 Courier new

;; PATH Settings
(let ((default-directory "~/.emacs.d/elpa/"))
(normal-top-level-add-subdirs-to-load-path))
(add-to-list 'load-path "~/.emacs.d/elpa/")
(setq custom-file "~/.emacs.d/init-files/custom.el")
(package-initialize)

;; On Glasgow PC have to set This
; (setenv "PATH" (concat "C:\\texlive\\2014\\bin\\win32;C:\\texlive\\fixbbl\\bin;" (getenv "PATH")))  


;; ---- emacs startup time benchmark ----
; (require 'benchmark-init)
;; To disable collection of benchmark data after init is done.
; (add-hook 'after-init-hook 'benchmark-init/deactivate)


(eval-when-compile
  (require 'use-package))

  
; =========== load all at Notebook 2s =======
(load "~/.emacs.d/init-files/basic.el")
(load "~/.emacs.d/init-files/edit.el")
(load "~/.emacs.d/init-files/dired.el")
(load "~/.emacs.d/init-files/tex.el")
(load "~/.emacs.d/init-files/ess.el")
(load "~/.emacs.d/init-files/org.el")
(load "~/.emacs.d/init-files/rmd.el")
(load "~/.emacs.d/init-files/lang.el")
(load "~/.emacs.d/init-files/python.el")
(load "~/.emacs.d/init-files/completion.el")
(load "~/.emacs.d/init-files/face.el")
(load "~/.emacs.d/init-files/mix.el")
(load "~/.emacs.d/init-files/git.el")
(load "~/.emacs.d/init-files/mail.el")
(load "~/.emacs.d/init-files/emms.el")
(load "~/.emacs.d/init-files/evil.el")
(load "~/.emacs.d/init-files/pdf.el")
(load "~/.emacs.d/init-files/lsp.el")
(load custom-file)


; ===== load all at Notebook 20s ===========
(init-basic) ;; 独立  start in Notebook 2s
(init-edit)  ;; 依赖 basic;  start in Notebook 1s
(init-dired) ;;独立 start in Notebook 6s
(init-tex)   ;;独立 start in Notebook 2s
(init-ess)  ;; 独立    start in Notebook 0.5s 
(init-org)      ;;依赖 tex 和 ess, start in Notebook 3s
(init-rmd)        ;;依赖 ess
(init-lang)      ;;独立 start in Notebook 0.5s
(init-python)      ;;独立 start in Notebook 0.5s
(init-completion)
(init-face)    ;;依赖 basic，edit, mix;  start in Notebook 1s
(init-mix)      ;;独立start in Notebook 2s
(init-git)
(init-mail)  ;;依赖 org;   start in Notebook 1.5s
(init-emms)    ;;独立  start in Notebook 0.5s
(init-evil)
(init-pdf)
(init-lsp)

; (execute-kbd-macro (read-kbd-macro "C-x 1"))
(delete-other-windows)


"Init Begin"
(interactive)			
			)

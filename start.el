(defun init-start ()

;; ����U�����������޸ģ�1. �޸�·�������������ļ��е� C:\ �޸ĳ� H:\�� 2. ��face.el�е������ Consola �޸ĳ� Courier new

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
(init-basic) ;; ����  start in Notebook 2s
(init-edit)  ;; ���� basic;  start in Notebook 1s
(init-dired) ;;���� start in Notebook 6s
(init-tex)   ;;���� start in Notebook 2s
(init-ess)  ;; ����    start in Notebook 0.5s 
(init-org)      ;;���� tex �� ess, start in Notebook 3s
(init-rmd)        ;;���� ess
(init-lang)      ;;���� start in Notebook 0.5s
(init-python)      ;;���� start in Notebook 0.5s
(init-completion)
(init-face)    ;;���� basic��edit, mix;  start in Notebook 1s
(init-mix)      ;;����start in Notebook 2s
(init-git)
(init-mail)  ;;���� org;   start in Notebook 1.5s
(init-emms)    ;;����  start in Notebook 0.5s
(init-evil)
(init-pdf)
(init-lsp)

; (execute-kbd-macro (read-kbd-macro "C-x 1"))
(delete-other-windows)


"Init Begin"
(interactive)			
			)

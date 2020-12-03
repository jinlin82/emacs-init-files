(defun init-python ()

;; 特别注意：inferior python mode 中 plt.show() 卡住，要设置 The matplotlibrc file
;; backend      : TkAgg 

;;================================== Python ==================================
(require 'python)

(setq
  python-shell-interpreter "ipython"
  python-shell-interpreter-args "-i"
  ;python-shell-unbuffered nil
  ;python-shell-prompt-regexp "In \\[[0-9]+\\]: "
  ;python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
)

(defun ipy ()
  (interactive)
  (setq
  python-shell-interpreter "ipython"
  python-shell-interpreter-args "-i"
  ;python-shell-unbuffered nil
  ;python-shell-prompt-regexp "In \\[[0-9]+\\]: "
  ;python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
)
  (call-interactively 'run-python)
  (other-window 1)
)

(defun scrapy ()
  (interactive)
  (setq
  python-shell-interpreter "scrapy"
  python-shell-interpreter-args " shell"
  ; python-shell-unbuffered nil
  python-shell-prompt-regexp "In \\[[0-9]+\\]: "
  python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
)
  (call-interactively 'run-python)
)


;;-------------- elpy ----------------
;; 特别注意：要把 elpy.el中的  (set (make-local-variable 'company-idle-delay)
;;          0.5) ;; 需要从0.1修改为0.5才不卡
;; 注意：elpy 自动补全 需要 ("jedi" "flake8" "autopep8" "yapf" "black" "rope") 支持
(add-hook 'python-mode-hook (lambda () (auto-complete-mode -1))) ;; 关闭auto-complete-mod 

(if (eq system-type 'windows-nt) (package-initialize))
(elpy-enable)
(remove-hook 'elpy-modules 'elpy-module-flymake)

(if (eq system-type 'windows-nt)
(setq elpy-rpc-python-command "~/../../Anaconda3/pythonw.exe")
(setq elpy-rpc-python-command "~/../usr/bin/python")
)

(setq python-indent-guess-indent-offset t)  
(setq python-indent-guess-indent-offset-verbose nil)
(setq eldoc-idle-delay 1)
(setq elpy-autodoc-delay 1)
(setq elpy-eldoc-show-current-function t)
(setq elpy-get-info-from-shell t)
(setq elpy-shell-starting-directory (quote current-directory))



;;------------ autopep8 -------------- 
;(require 'py-autopep8)
;(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
;(setq py-autopep8-options '("--max-line-length=78" "--indent-size=3")) ;设置为3的原因是为4时在latex lstings 中显示有问题

(add-hook 'python-mode-hook '(lambda () 
(setq python-indent 3)))

 
 
;;;==================== EIN SETTINGS  startup to slow =====================
 ;(require 'ein)
 ;(require 'ein-loaddefs)
 ;(require 'ein-notebook)
 ;(require 'ein-subpackages)
;; 需要把 包含 __main__.py 的 elpy 文件夹拷贝到C:\Anaconda3\Lib\site-packages 中 poly-ein-mode才起作用
;; ein-autoloads.el 中增加以下代码才不会出错 
;;(add-to-list 'load-path "~/.emacs.d/elpa/org-9.2.1/")
;;(setenv "PATH" (concat "C:\\Worktools\\Bibtex2html;" (getenv "PATH")))
;;(require 'org-install)
;;(require 'org)

;; ein-jupyter.el 中hack 函数 ein:jupyter-server-start

(setq ein:jupyter-default-notebook-directory (concat prepath "Books/Statsoft/Python/ipynb"))
(setq elpy-rpc-pythonpath "~/../Config/.emacs.d/elpa/elpy-20201003.2153/elpy")
;(add-hook 'ein:notebook-multilang-mode-hook 'poly-ein-mode)  ;; polymode 很慢，并且编辑时(jit-lock--run-functions 95 186)错误，目前可用于浏览
(add-hook 'ein:notebook-multilang-mode-hook 'cdlatex-mode)
(add-hook 'ein:notebook-multilang-mode-hook 'autopair-mode)


(setq ein:completion-backend (quote ein:use-company-backend))
(setq ein:jupyter-default-kernel
   (quote python37464bitbaseconda87bad30cbe814876802293fd365e8fe0))

;; '_xsrf' argument missing from POST issue, Cannot save notebook in ein
;;This can be solved by adding    c.NotebookApp.disable_check_xsrf = True    in jupyter_notebook_config.py.

;;---- Cannot start kernel------
 ;(defun ein:ipynb-start ()
   ;(interactive)
   ;(setq request-backend (quote url-retrieve))
   ;(call-interactively 'ein:jupyter-server-start)
 ;)

 ;(defun ein:ipynb-end ()
   ;(interactive)
   ;(call-interactively 'ein:jupyter-server-stop)
   ;(setq request-backend (quote curl))
 ;)

;;;================== EIN SETTINGS END ===================

;;;=================== python-x ==========================
(python-x-setup)

"Init Python"
(interactive)			
			)

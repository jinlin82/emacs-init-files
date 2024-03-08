(defun init-python ()

;; 特别注意：inferior python mode 中 plt.show() 卡住，要设置 The matplotlibrc file
;; backend      : TkAgg 

;;================================== Python ==================================
(require 'python)

(setq python-indent-guess-indent-offset t)  
(setq python-indent-guess-indent-offset-verbose nil)
(add-hook 'python-mode-hook '(lambda () (setq python-indent 4)))
(add-hook 'python-mode-hook (lambda () (auto-complete-mode -1))) ;; 关闭auto-complete-mode

;; Use Jupyter console (recommended for interactive Python):
; (setq python-shell-interpreter "jupyter"
      ; python-shell-interpreter-args "console --simple-prompt"
      ; python-shell-prompt-detect-failure-warning nil)
; (add-to-list 'python-shell-completion-native-disabled-interpreters
             ; "jupyter")

;; Use IPython:
(setq python-shell-interpreter "ipython"
python-shell-interpreter-args "-i --simple-prompt")

(defun ipython-or-jupyter-toggle ()
  (interactive)
  (cond ((string-equal "ipython" python-shell-interpreter)
	 (progn
	   (setq python-shell-interpreter "jupyter"
		 python-shell-interpreter-args "console --simple-prompt"
		 python-shell-prompt-detect-failure-warning nil)
	   (add-to-list 'python-shell-completion-native-disabled-interpreters
			"jupyter")
	   ))
	((string-equal "jupyter" python-shell-interpreter)
	 (setq python-shell-interpreter "ipython"
	       python-shell-interpreter-args "-i --simple-prompt")
	 )))


(defun ipy ()
  (interactive)
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

;;------------ autopep8 -------------- 
;(require 'py-autopep8)
;(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
;(setq py-autopep8-options '("--max-line-length=78" "--indent-size=3")) ;设置为3的原因是为4时在latex lstings 中显示有问题



;;-------------- elpy ----------------
;; 把 emacs elpa中的elpy 文件夹复制到C:\Anaconda3\Lib\site-packages\elpy下面
;; 安装 elpy 新版本时要把.emacs.d中的elpy文件夹删掉重新安装生成
;; 特别注意：要把 elpy.el中的  (set (make-local-variable 'company-idle-delay)
;;          0.5) ;; 需要从0.1修改为0.5才不卡;;  新版本中不会
;; 注意：elpy 自动补全 需要 ("jedi" "flake8" "autopep8" "yapf" "black" "rope") 支持
(if (eq system-type 'windows-nt) (package-initialize))
(elpy-enable)

; (remove-hook 'elpy-modules '(elpy-module-flymake))

(setq elpy-modules '(elpy-module-sane-defaults
                          ; elpy-module-company  ;; 不开启，开启后有bug，卡，使用 python-mode自带的补全，缺点是必须打开inferior python,并且在inferior python中运行一下补全
                          elpy-module-eldoc
                          ; elpy-module-flymake
                          ; elpy-module-highlight-indentation
                          ; elpy-module-pyvenv
                          elpy-module-yasnippet
                          ; elpy-module-django
			  ; elpy-module-autodoc
						  ))

(if (eq system-type 'windows-nt)
(setq elpy-rpc-python-command "~/../../Anaconda3/pythonw.exe")
(setq elpy-rpc-python-command "~/../usr/bin/python")
)


(setq elpy-autodoc-delay 1)
(setq elpy-eldoc-show-current-function t)
(setq elpy-get-info-from-shell t)
(setq elpy-shell-starting-directory (quote current-directory))
(setq elpy-shell-display-buffer-after-send t)


;;;; 定义一个行内区域发送函数
(defun elpy-shell-send-region-no-expand (start end &optional send-main msg
                                       no-cookie)
  (interactive
   (list (region-beginning) (region-end) current-prefix-arg t))
  (let* ((process (python-shell-get-process-or-error msg))
         (original-string (buffer-substring-no-properties start end))
         (_ (string-match "\\`\n*\\(.*\\)" original-string)))
    (message "Sent: %s..." (match-string 1 original-string))
    (with-current-buffer (process-buffer process)
      (compilation-forget-errors))
	(elpy-shell--append-to-shell-output original-string)
    (python-shell-send-string original-string process)
    (deactivate-mark)))

(define-key python-mode-map (kbd "<M-RET>") 'elpy-shell-send-region-no-expand)
(define-key python-mode-map (kbd "C-c v c") 'elpy-shell-send-codecell-and-step)


;;; 在Emacs外部cmd窗口中运行python文件
(defun run-python-file-in-external-cmd()
  "Open an external Windows cmd in the current directory"
  (interactive)
  (let ((default-directory
      (if (buffer-file-name)
               (file-name-directory (buffer-file-name))
               default-directory))))
          (start-process-shell-command "nil"  nil
				   (concat "start cmd /k python " "\"" default-directory (f-base (buffer-name))  ".py" "\""))
				   (message (concat "Run in CMD:" (buffer-name) ))
	)

(define-key python-mode-map (kbd "C-c v r") 'run-python-file-in-external-cmd)

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
(setq elpy-rpc-pythonpath "~/../Config/.emacs.d/elpa/elpy-20220322.41/elpy")
(add-hook 'ein:notebook-multilang-mode-hook 'poly-ein-mode)  ;; polymode 很慢，并且编辑时(jit-lock--run-functions 95 186)错误，目前可用于浏览
(add-hook 'ein:notebook-multilang-mode-hook 'cdlatex-mode)
; (add-hook 'ein:notebook-multilang-mode-hook 'autopair-mode)


(setq ein:completion-backend (quote ein:use-company-backend))
; (setq ein:jupyter-default-kernel
   ; (quote python37464bitbaseconda87bad30cbe814876802293fd365e8fe0))

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

(defun pandoc-ipynb-setup ()

  (defun pandoc-ipynb-html ()
    (interactive)
    (progn
      (save-buffer)
      (start-process-shell-command "nil" "*ipynb-Compile*"
				   (concat "ipynb-html.bat " default-directory (f-base (buffer-name))  ".ipynb"))
      (message (concat "ipynb-html.bat " (buffer-name) ))
      ))

  (defun pandoc-ipynb-doc ()
    (interactive)
    (with-current-buffer (get-buffer-create "*ipynb-Compile*") (erase-buffer))
    (progn
      (save-buffer)
      (start-process-shell-command "nil" "*ipynb-Compile*"
				   (concat "ipynb-doc.bat " default-directory (f-base (buffer-name))  ".ipynb"))
      (message (concat "ipynb-doc.bat " (buffer-name) ))
      ))

  (defun pandoc-ipynb-pdf ()
    (interactive)
    (with-current-buffer (get-buffer-create "*ipynb-Compile*") (erase-buffer))
    (progn
      (save-buffer)
      (start-process-shell-command "nil"  "*ipynb-Compile*"
				   (concat "ipynb-pdf.bat " default-directory (f-base (buffer-name))  ".ipynb"))
      (message (concat "ipynb-pdf.bat " (buffer-name) ))
      ))

  (define-key ein:notebook-mode-map (kbd "C-c v h") 'pandoc-ipynb-html)
  (define-key ein:notebook-mode-map (kbd "C-c v d") 'pandoc-ipynb-doc)
  (define-key ein:notebook-mode-map (kbd "C-c v p") 'pandoc-ipynb-pdf)
  )

(add-hook 'ein:notebook-mode-hook 'pandoc-ipynb-setup t)
;;;================== EIN SETTINGS END ===================

;;;=================== python-x ==========================
; (python-x-setup)

;;; 使用 jupyter console 时 anaconda-mode 有问题，并且 jupyter console启动速度较慢
;;; 使用 ipython 时优点速度较快，但画图使用 plt.show(block=False) 时窗口冻结

(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
(setq eldoc-idle-delay 0.5)

(eval-after-load "anaconda-mode"
  '(progn
(define-key anaconda-mode-map (kbd "M-,") 'delete-window)))

;;; python-cell

"Init Python"
(interactive)			
			)

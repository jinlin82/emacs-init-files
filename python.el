(defun init-python ()

;;================================== Python ==================================
(require 'python)

(setq
  python-shell-interpreter "ipython"
  python-shell-interpreter-args "-i"
  ; python-shell-interpreter "C:\\Anaconda2\\python.exe"
  ; python-shell-interpreter-args "-i C:\\Anaconda2\\Scripts\\jupyter-console-script.py"
  python-shell-unbuffered nil
  python-shell-prompt-regexp "In \\[[0-9]+\\]: "
  python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
  python-shell-completion-setup-code
    "from IPython.core.completerlib import module_completion"
  python-shell-completion-module-string-code
    "';'.join(module_completion('''%s'''))\n"
  python-shell-completion-string-code
    "';'.join(get_ipython().Completer.all_completions('''%s'''))\n"
)

(defun ipy ()
  (interactive)
  (setq
  python-shell-interpreter "ipython"
  python-shell-interpreter-args "-i"
  ; python-shell-interpreter "C:\\Anaconda2\\python.exe"
  ; python-shell-interpreter-args "-i C:\\Anaconda2\\Scripts\\jupyter-console-script.py"
  python-shell-unbuffered nil
  python-shell-prompt-regexp "In \\[[0-9]+\\]: "
  python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
  python-shell-completion-setup-code
    "from IPython.core.completerlib import module_completion"
  python-shell-completion-module-string-code
    "';'.join(module_completion('''%s'''))\n"
  python-shell-completion-string-code
    "';'.join(get_ipython().Completer.all_completions('''%s'''))\n"
)
  (call-interactively 'run-python)
)

(defun scrapy ()
  (interactive)
  (setq
  python-shell-interpreter "scrapy"
  python-shell-interpreter-args " shell"
  ; python-shell-interpreter "C:\\Anaconda2\\python.exe"
  ; python-shell-interpreter-args "-i C:\\Anaconda2\\Scripts\\jupyter-console-script.py"
  ; python-shell-unbuffered nil
  python-shell-prompt-regexp "In \\[[0-9]+\\]: "
  python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
  ; python-shell-completion-setup-code
    ; "from IPython.core.completerlib import module_completion"
  ; python-shell-completion-module-string-code
    ; "';'.join(module_completion('''%s'''))\n"
  ; python-shell-completion-string-code
    ; "';'.join(get_ipython().Completer.all_completions('''%s'''))\n"
)
  (call-interactively 'run-python)
)

;;-------------- elpy ----------------
(package-initialize)
(elpy-enable)

;;------------ autopep8 -------------- 
(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
(setq py-autopep8-options '("--max-line-length=78" "--indent-size=3")) ;设置为3的原因是为4时在latex lstings 中显示有问题

(add-hook 'python-mode-hook '(lambda () 
 (setq python-indent 3)))
 
 
;;;==================== EIN SETTINGS  startup to slow =====================
; (require 'ein)
; (require 'ein-loaddefs)
; (require 'ein-notebook)
; (require 'ein-subpackages)

; (setq ein:jupyter-default-notebook-directory "C:/Books/Statsoft/Python/ipynb")

;; '_xsrf' argument missing from POST issue, Cannot save notebook in ein
;;This can be solved by adding    c.NotebookApp.disable_check_xsrf = True    in jupyter_notebook_config.py.

;;---- Cannot start kernel------
; (defun ein:ipynb-start ()
  ; (interactive)
  ; (setq request-backend (quote url-retrieve))
  ; (call-interactively 'ein:jupyter-server-start)
; )

; (defun ein:ipynb-end ()
  ; (interactive)
  ; (call-interactively 'ein:jupyter-server-stop)
  ; (setq request-backend (quote curl))
; )

;;;================== EIN SETTINGS END ===================

	
"Init Python"
(interactive)			
			)

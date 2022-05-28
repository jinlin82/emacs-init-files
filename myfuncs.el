;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Filename   : myfuncs.el
;; Description:
;; Author     : JL
;; Created    : 2022-05-26 星期四 08:06:03 (+0800)
;; LastUpdated:
;; By         :
;; Update #   : 9
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; ========= Execute a list of shell commands sequentially==========
(defun execute-commands (buffer &rest commands)
  "Execute a list of shell commands sequentially"
  (with-current-buffer buffer
    (set (make-local-variable 'commands-list) commands)
    (start-next-command)))

(defun start-next-command ()
  "Run the first command in the list"
  (if (null commands-list)
      (insert "\nDone.")
    (let ((command  (car commands-list)))
      (setq commands-list (cdr commands-list))
      (insert (format ">>> %s\n" command))
      (let ((process (start-process-shell-command command (current-buffer) command)))
        (set-process-sentinel process 'sentinel)))))

(defun sentinel (p e)
  "After a process exited, call `start-next-command' again"
  (let ((buffer (process-buffer p)))
    (when (not (null buffer))
      (with-current-buffer buffer
        ;(insert (format "Command `%s' %s" p e) )
        (start-next-command)))))

(defun pandoc-ipynb-html ()
  (interactive)
  (with-current-buffer (get-buffer-create "*ipynb-Compile*") (erase-buffer))
  (progn
    (save-buffer)
    (execute-commands "*ipynb-Compile*"
		      (concat "ipynb-html.bat " default-directory (f-base (buffer-name))  ".ipynb")
		      (concat "open " default-directory (f-base (buffer-name)) ".html"))
    (message (concat "ipynb-html.bat " (buffer-name) ))
    ))
;;-------------------------------------------------------------------------------------


;; ===========================Append ELEMENTS to the end of LIST=======================
(defun append-to-list (list-var elements)
  "Append ELEMENTS to the end of LIST-VAR.
	The return value is the new value of LIST-VAR."
  (unless (consp elements)
    (error "ELEMENTS must be a list"))
  (let ((list (symbol-value list-var)))
    (if list
        (setcdr (last list) elements)
      (set list-var elements)))
  (symbol-value list-var))

; (append-to-list 'file-coding-system-alist '(("\\.\\(txt\\|md\\|rmd\\|org\\|r\\|py\\)\\'" . utf-8)));; 所有新文件以utf-8编码

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; myfuncs.el ends here

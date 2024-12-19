(defun init-ess ()

;;===============================================ESS SETUP===============================================
(require 'ess-site)
(setq inferior-R-args "--no-save")
(setq ess-eval-visibly nil)
(setq ess-ask-for-ess-directory nil)
(setq ess-startup-directory 'default-directory)
(setq ess-use-flymake nil)

;; auto completion 设置在 completion.el 中

;(require 'ess-smart-underscore)
(use-package ess-smart-equals
  :after (:any ess-r-mode inferior-ess-r-mode ess-r-transcript-mode)
  :config (ess-smart-equals-activate))

(require 'ess-view)
(setq ess-view--spreadsheet-program (concat prepath "Program Files (x86)/Microsoft Office/Office14/EXCEL.EXE"))

;;; hack Cannot view data.frame from source code
(defun ess-view-extract-R-process ()
"Return the name of R running in current buffer."
  (let*
      ((proc (ess-get-process))         ; Modified from (proc (get-buffer-process (current-buffer)))
       (string-proc (prin1-to-string proc))
       (selected-proc (s-match "^#<process \\(R:?[0-9]*\\)>$" string-proc)))
    (nth 1 (-flatten selected-proc))
    )
  )

(define-key ess-mode-map (kbd "C-x w") 'ess-view-inspect-df)


;;No .Rhistory file
(defun ei-no-rhistory ()
  (setq ess-history-file (concat prepath "Books/Statsoft/R/Code/.Rhistory")))

(add-hook 'inferior-ess-mode-hook 'ei-no-rhistory)
(add-hook 'inferior-ess-mode-hook
	  '(lambda ()
	     (progn
	       ;; 由于在git中修改了coding,所以这里要改回来
	     (setq-local default-process-coding-system '(utf-8 . utf-8))
	     )))

;;---------------------------------------SPLUS-------------------------------------------
(setq-default inferior-S+6-program-name
	      (concat prepath "progra~1/SPLUS80/cmd/Splus"))
(setq-default inferior-Sqpe+6-SHOME-name
	      (concat prepath "progra~1/SPLUS80"))
(setq-default inferior-Sqpe+6-program-name
	      (concat prepath "progra~1/SPLUS80/cmd/Sqpe.exe"))


;;--------------------------------------R-----------------------------------------------
;;Emacs ESS version of Clear Console
(setq inferior-R-font-lock-keywords (quote (
					    (ess-S-fl-keyword:prompt . t)
					    (ess-R-fl-keyword:modifiers . t)
					    (ess-R-fl-keyword:fun-defs . t)
					    (ess-R-fl-keyword:keywords . t)
					    (ess-R-fl-keyword:assign-ops . t)
					    (ess-R-fl-keyword:constants . t)
					    (ess-R-fl-keyword:messages . t)
					    (ess-fl-keyword:matrix-labels . t)
					    (ess-fl-keyword:fun-calls . t)
					    (ess-fl-keyword:numbers . t)
					    (ess-fl-keyword:operators)
					    (ess-fl-keyword:delimiters)
					    (ess-fl-keyword:= . t)
					    (ess-R-fl-keyword:F&T . t))))

(setq ess-R-font-lock-keywords (quote (
				       (ess-R-fl-keyword:modifiers . t)
				       (ess-R-fl-keyword:fun-defs . t)
				       (ess-R-fl-keyword:keywords . t)
				       (ess-R-fl-keyword:assign-ops . t)
				       (ess-R-fl-keyword:constants . t)
				       (ess-fl-keyword:fun-calls . t)
				       (ess-fl-keyword:numbers . t)
				       (ess-fl-keyword:operators . t)
				       (ess-fl-keyword:delimiters)
				       (ess-fl-keyword:= . t)
				       (ess-R-fl-keyword:F&T . t))))

;;--------------------------------重新定义ess-swv-latex函数 ------------------------------
(defun ess-swv-latex ()
  "Run LaTeX on the product of Sweave()ing the current file."
  (interactive)
  (save-excursion
    (let* ((namestem (file-name-sans-extension (shell-quote-argument (buffer-file-name))))  ;;用(shell-quote-argument (buffer-file-name)) 而不是（buffer-file-name）避免路径名中空白导致出现错误
	   (latex-filename (concat namestem ".tex"))
	   (tex-buf (get-buffer-create " *ESS-tex-output*")))
      (message "Running LaTeX on '%s' ..." latex-filename)
      ;;(switch-to-buffer tex-buf)     ;;不转向*ESS-tex-output*
      ;;(call-process "latex" nil tex-buf 1 latex-filename) ;;不能生成DVI的Source Link
      (call-process-shell-command "xelatex --synctex=1"nil tex-buf 1 latex-filename);; ;;使用xelatex引擎
      (switch-to-buffer (buffer-name))
      (display-buffer tex-buf)
      (message "Finished running LaTeX" ))))

;; ---------Send a blank line from code to *R*
(setq ess-eval-empty t)

;; -------------------- 清屏 -----------------------
(defun clear-shell ()
  (interactive)
  (let ((old-max comint-buffer-maximum-size))
    (setq comint-buffer-maximum-size 0)
    (comint-truncate-buffer)
    (setq comint-buffer-maximum-size old-max)))
(global-set-key (kbd "\C-x c") 'clear-shell)


;;---------------------------------------ESSOutlineMode------------------------------------
;;Outline mode for .R files
;;In order to enable Emacs’ standard OutlineMode for .R files:

(add-hook 'ess-mode-hook
	  '(lambda ()
	     (progn
	       ;; 由于在git中修改了coding,所以这里要改回来
	     (setq-local default-process-coding-system '(utf-8 . utf-8))
	     (outline-minor-mode)
	     (setq outline-regexp "\\(^#\\{4,5\\} \\)\\|\\(^[a-zA-Z0-9_\.]+ ?<- ?function(.*{\\)")
	     (defun outline-level ()
	       (cond ((looking-at "^##### ") 1)
		     ((looking-at "^#### ") 2)
		     ((looking-at "^### ") 3)
		     ((looking-at "^[a-zA-Z0-9_\.]+ ?<- ?function(.*{") 4)
		     (t 1000)))
	     )))

;; Simpler keybindings with the win key: (global for now, FIXME!!)
;; probably some might not work right on actual windows...

(global-set-key (kbd "s-a") 'show-all)

(global-set-key (kbd "s-T") 'hide-body)     ;; Hide all body but not subh.
(global-set-key (kbd "s-t") 'hide-other)    ;; Hide all but current+top

(global-set-key (kbd "s-d") 'hide-subtree)  ;; hide body and subh.
(global-set-key (kbd "s-s") 'show-subtree)  ;; show body and subheadings
(global-set-key (kbd "s-D") 'hide-leaves)   ;; hide body from subheadings
(global-set-key (kbd "s-S") 'show-branches) ;; show subheadings w/o body

(global-set-key (kbd "s-b") 'outline-backward-same-level)
(global-set-key (kbd "s-f") 'outline-forward-same-level)
(global-set-key (kbd "s-B") 'outline-up-heading)

(global-set-key (kbd "s-p") 'outline-previous-visible-heading)
(global-set-key (kbd "s-n") 'outline-next-visible-heading)
(global-set-key (kbd "s-P") 'outline-previous-heading)
(global-set-key (kbd "s-N") 'outline-next-heading)
;;This is what Andrei sent to the ess-help mailing list on 2010-08-18. Thank you, Andrei! It is based on an adapted (by me, Sven)
;;version of Heinz Tuechler’s outline suggestion he posted to the ESS-help mailing list on 2007-05-11.

;;The above will define the following heading levels in .R files:
;;lines starting with #####  --> level 1
;;lines starting with ####   --> level 2
;;R functions                --> level 3
;;Although R functions are not “headings” really, I still imagine this could be a nice way of getting an overview over a larger .R file. I can’t yet say whether it will prove useful for me in the long run. – Sven


;-----------------------------------------ado-Mode-------------------------------------------
(setq ado-comeback-flag t)
(setq ado-send-to-all-flag nil)
(setq ado-stata-flavor "")
(setq ado-stata-home nil)
(setq ado-stata-instance 0)
(setq ado-stata-version "")
(setq ado-submit-default "command")


(require 'ado-mode)
(require 'ado-hacks)

(add-hook 'ado-mode-hook
	  (lambda ()
	    (defun ado-send-command-to-stata-and-next-line () ""
	      (interactive)
	      (ado-send-command-to-stata)
	      (next-line))
	    (local-set-key (kbd "<C-return>") 'ado-send-command-to-stata-and-next-line)
	    )
	  )

;;---------------------------------------------- SAS -----------------------------------------
(setq ess-sas-edit-keys-toggle nil)
					;Windows example
(setq-default ess-sas-submit-command "sas.exe")


;;2; (setq ess-sas-local-unix-keys t)
;;  (setq ess-sas-local-pc-keys t)
;;4; (setq ess-sas-global-unix-keys t)
(setq ess-sas-global-pc-keys t)
;;; Next required to activate preceding selection
(ess-sas-global-pc-keys)

(require 'ess-bugs-d)

(setq ess-eldoc-abbreviation-style 'normal)
(setq eldoc-echo-area-use-multiline-p t)
(setq ess-eldoc-show-on-symbol t)

(defun ess-complete-object-name ()
  "Perform completion on `ess-language' object preceding point.
Uses \\[ess-R-complete-object-name] when `ess-use-R-completion' is non-nil,
or \\[ess-internal-complete-object-name] otherwise."
  (interactive)
  (if (ess-make-buffer-current)
      (if ess-use-R-completion
          (ess-R-complete-object-name)
        (ess-internal-complete-object-name))
    ;; else give a message on second invocation
    (when (string-match "complete" (symbol-name last-command))
      (message "No ESS process associated with current buffer")
      nil)
    ))
;;===================================== ESS END =======================================


"Init ESS"
(interactive)			
			)

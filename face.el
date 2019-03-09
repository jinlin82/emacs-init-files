(defun init-face ()
;;-========================================��������  ===============================

;; ------------- rainbow-delimiters-mode -------------------
(add-hook 'org-mode-hook #'rainbow-delimiters-mode)
(add-hook 'ess-mode-hook #'rainbow-delimiters-mode)
(add-hook 'inferior-ess-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)


;; ==================================== �������� ===================================
;; ע��custom.el�е�(default ���
;; Ĭ�������С
;(set-face-attribute 'default nil :height 118)

; (use-package dashboard
  ; :config
  ; (dashboard-setup-startup-hook))

;;--------------------------------------��������-------------------------------------
;(set-face-attribute
 ;'default nil
 ;:font (font-spec :name "-outline-Consolas-bold-normal-normal-mono-*-*-*-*-c-*-iso10646-1"
                  ;:weight 'normal
                  ;:slant 'normal
                  ;:size 12.5))

;;; Microsoft JhengHei / ΢���ź� /
;(defun init-msyh ()
;(dolist (charset '(kana han symbol cjk-misc bopomofo))
  ;(set-fontset-font (frame-parameter nil 'font)
		    ;charset
		    ;(font-spec :family "Microsoft YaHei" :height 125)))
;(interactive)			
			;)
;;(init-msyh)

;; ---------------------------- cnfonts -----------------------------
;; function toggle �ȿ�����
(cnfonts-enable)
(setq cnfonts-directory "~/.emacs.d/user-files/cnfonts/")
(cnfonts--select-profile "profile1")

(defun cnfonts-profile-toggle ()
(interactive)
(if (string-equal cnfonts--current-profile-name "profile1")
(progn
  (cnfonts--select-profile "profile2")
  (global-set-key (kbd "<C-wheel-up>") 'cnfonts-increase-fontsize)
  (global-set-key (kbd "<C-wheel-down>") 'cnfonts-decrease-fontsize)
  (message "�л����ȿ�����")
  )
  (cnfonts--select-profile "profile1")
  ;; �������4�䵽 profile1.el �ļ���
  ;(setq cnfonts-use-face-font-rescale t)
  ;(set-face-attribute 'org-level-1 nil :height 1.1 :bold t :foreground "yellow4")
  ;(set-face-attribute 'org-level-2 nil :height 1.1 :bold t)
  ;(set-face-attribute 'org-level-3 nil :height 1.0 :bold t)
  (global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
  (global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
  (message "�л���Ĭ������"))
)

(global-set-key (kbd "C-x v f") 'cnfonts-profile-toggle)
;;---------------------------------------ʹ�������������------------------------------
;(setq text-scale-mode-step 1.1)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
;(global-set-key (kbd "<C-wheel-up>") 'cnfonts-increase-fontsize)
;(global-set-key (kbd "<C-wheel-down>") 'cnfonts-decrease-fontsize)

;; =================================== �������� END ===================================


;;-----------------------------------------��󻯴���----------------------------------
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;------------------Only open one emacs window-----------------------------------------
(server-start)

;; ===================================== MODE LINE ====================================
;; time
(setq display-time-24hr-format t)
; (setq display-time-format "%R %a,%b %d")
(setq display-time-default-load-average nil)

(defface my-time-face
  '((t :foreground "purple"
       ; :weight bold
      ))
  "face for user defined variables."
)
  
; (setq display-time-string-forms
      ; '((propertize (format-time-string "%R %a,%b %d " now) 'face 'my-time-face)
	   ; ))

;; Battery	   
; (setq battery-mode-line-format " %b%p%%%%\~%t")
(setq battery-update-interval 10)	   
(setq fancy-battery-show-percentage t)	   
(add-hook 'after-init-hook #'fancy-battery-mode)   
; (display-time-mode 1)
; (display-battery-mode 1)


;; ------------------------------ spaceline -----------------------------------
; (require 'powerline)
; (powerline-default-theme)
 
(require 'spaceline-config)
(setq spaceline-highlight-face-func 'spaceline-highlight-face-modified)
(spaceline-spacemacs-theme)

;; battery config for spaceline
(setq spaceline-right 
'(which-function
     (python-pyvenv :fallback python-pyenv)      
     input-method
     ((selection-info
	   buffer-encoding-abbrev
       point-position
       line-column)
      :separator " | ")  
      (buffer-position hud :separator "")
	 (battery :when active)  ;; �޸���mode line �е�λ��
	 time-and-date
	 (global :when active)  ;; ��� yahoo-weather-mode, �ر���yahoo-weather-mode��ע�͵�
     ,@additional-segments
     ))

(defun spaceline--fancy-battery-mode-line ()  ;; �޸�spaceline-segmentsԴ�ļ��еĺ���
  "Assemble a mode line string for Fancy Battery Mode."
  (when fancy-battery-last-status
    (let* ((type (cdr (assq ?L fancy-battery-last-status)))
           (percentage (spaceline--fancy-battery-percentage))
           (time (spaceline--fancy-battery-time))
		   (charge-type (cdr (assq ?b fancy-battery-last-status))))
      (cond
       ((string= "on-line" type) (concat " AC"  percentage charge-type time))
       ((string= type "") " No Battery")
       (t (concat (if (string= "AC" type) " AC" "")  percentage charge-type time))))))

(defun spaceline--fancy-battery-face ()  ;;�޸�spaceline-segmentsԴ�ļ��еĺ���
  "Return a face appropriate for powerline"
  (let ((type (cdr (assq ?L fancy-battery-last-status))))
    (if (and type (string= "on-line" type))
        'fancy-battery-charging
      (pcase (cdr (assq ?b fancy-battery-last-status))
        ("!"  'fancy-battery-critical)
        ("+"  'fancy-battery-charging)
        ("-"  'fancy-battery-discharging)
        (_ 'fancy-battery-discharging)))
		))

(spaceline-define-segment time-and-date
    "Time and Date"
    (propertize (format-time-string "%R %a,%b %d") 'face 'my-time-face)
	)
		
(defface my-modified-face
  '((t :foreground "red"
       :weight bold
      ))
  "face for user defined variables."
)


(spaceline-define-segment buffer-modified
  "Buffer modified marker."
  (propertize "%*" 'face 'my-modified-face)
  )

(defface my-file-face
  '((t :foreground "MidnightBlue"
       :weight bold
      ))
  "face for user defined variables."
)  
  
(spaceline-define-segment buffer-id
  "Name of buffer."
  (propertize (powerline-buffer-id) 'face 'my-file-face)
  )
  
(declare-function pdf-view-current-page 'pdf-view)
(declare-function pdf-cache-number-of-pages 'pdf-view)

(defface my-pos-face
  '((t :foreground "DeepPink"
       :weight bold
      ))
  "face for user defined variables."
)  

(spaceline-define-segment buffer-position
  "The current approximate buffer position, in percent."
  (propertize "%p" 'face 'my-pos-face)
  )

(defface my-size-face
  '((t :foreground "DarkGreen"
       :weight bold
      ))
  "face for user defined variables."
)    
  
(spaceline-define-segment buffer-size
  "Size of buffer."
  (propertize (powerline-buffer-size) 'face 'my-size-face))  

(defface my-major-face
  '((t :foreground "SkyBlue1"
       :weight bold
      ))
  "face for user defined variables.")
  
(spaceline-define-segment major-mode
  "The name of the major mode."
  (propertize (powerline-major-mode) 'face 'my-major-face)  
  )  
  
;; pdf-tools page
(defface my-page-face
  '((t :foreground "SeaGreen"
       :weight bold
      ))
  "face for user defined variables."
)

(defun spaceline--pdfview-page-number ()
  "The current `pdf-view-mode' page number to display in the mode-line.
Return a formated string containing the current and last page number for the
currently displayed pdf file in `pdf-view-mode'."
  (format "(%d/%d)"
          ;; `pdf-view-current-page' is a macro in an optional dependency
          ;; any better solutions?
          (eval `(pdf-view-current-page))
          (pdf-cache-number-of-pages)))

(spaceline-define-segment line-column
  "The current line and column numbers, or `(current page/number of pages)`
in pdf-view mode (enabled by the `pdf-tools' package)."
  (propertize (if (eq major-mode 'pdf-view-mode)
      (spaceline--pdfview-page-number) 
    "%l:%2c")'face 'my-page-face))

	
	
(global-anzu-mode +1)
(diminish 'undo-tree-mode)
(diminish 'guide-key-mode)
(diminish 'anzu-mode)
(diminish 'smartparens-mode)
(diminish 'volatile-highlights-mode)
(diminish 'org-cdlatex-mode)
(diminish 'auto-complete-mode)
(diminish 'helm-mode)
(diminish 'company-mode)
(diminish 'abbrev-mode)

;;===================================== MODE LINE END =======================================

;; �ڱ�������ʾ��½���ƺ��ļ���  ;;show the current directory in the frame bar
(setq frame-title-format
      '((:eval
         (let ((login-name (getenv-internal "LOGNAME")))
           (if login-name (concat login-name "@") "")))
        (:eval (concat " JL@" (system-name)))
        " | "
        (:eval (or (buffer-file-name) (concat default-directory "--" (buffer-name))))
	))


;;---------- ����ο��� ------------------
;; (require 'fill-column-indicator)
;; (setq fci-rule-width 1)
;; (setq fci-rule-color "grey30")
;; (setq fci-rule-column 80)
;; (add-hook 'after-change-major-mode-hook 'fci-mode)

				  
"Init Face"
(interactive)			
			)

(defun init-face ()
;;-========================================界面配置  ===============================
;; (desktop-save-mode 1)

;; ------------- rainbow-delimiters-mode -------------------
(add-hook 'org-mode-hook #'rainbow-delimiters-mode)
(add-hook 'ess-mode-hook #'rainbow-delimiters-mode)
(add-hook 'inferior-ess-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;------------------------- tab bar mode -----------------------------------------
(setq tab-bar-show 1)
(tab-bar-history-mode)
(setq tab-bar-new-tab-choice 'recentf-open-files)


;; ==================================== 字体设置 ===================================
;; 注释custom.el中的(default 语句
;; 默认字体大小
;; (set-face-attribute 'default nil :height 100)
(defun toggle-monitor-font ()
  (interactive)
  (if (= (display-pixel-width) 1680)
      (progn 
	(color-theme-charcoal-black)
	(set-face-attribute 'default nil :height 110)
	(toggle-frame-fullscreen)
		(toggle-frame-fullscreen)
	)
    (progn
      (color-theme-emacs-nw)
      (set-face-attribute 'default nil :height 100)
      (toggle-frame-fullscreen)
      (toggle-frame-fullscreen)
      )
    )
  )

; (global-set-key (kbd "C-c d") 'toggle-monitor-font)


(require 'dashboard)
(dashboard-setup-startup-hook)
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)
(setq dashboard-set-navigator t)
(setq dashboard-startup-banner 'logo)

(setq dashboard-items '(
			(recents  . 8)
			(projects . 8)
			(agenda . 8)
		      ; (bookmarks . 5)
		      ; (registers . 5)
			))

(global-set-key (kbd "C-c d") 'dashboard-refresh-buffer)

;;--------------------------------------中文字体-------------------------------------
;(set-face-attribute
 ;'default nil
 ;:font (font-spec :name "-outline-Consolas-bold-normal-normal-mono-*-*-*-*-c-*-iso10646-1"
                  ;:weight 'normal
                  ;:slant 'normal
                  ;:size 12.5))

;;; Microsoft JhengHei / 微软雅黑 /
;(defun init-msyh ()
;(dolist (charset '(kana han symbol cjk-misc bopomofo))
  ;(set-fontset-font (frame-parameter nil 'font)
		    ;charset
		    ;(font-spec :family "Microsoft YaHei" :height 125)))
;(interactive)			
			;)
;;(init-msyh)


;; --------------------------- all the icons -----------------------
(require 'all-the-icons)
(setq inhibit-compacting-font-caches t)

;; neotree HACK: icons 模式中行距太高
(setq neo-theme 'icons)

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(all-the-icons-ivy-setup)



;; ---------------------------- cnfonts -----------------------------
;; function toggle 等宽字体
;; 注意：profile默认字体大小是最开始字号组合决定的
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
  (message "切换到等宽字体")
  )
  (cnfonts--select-profile "profile1")
  ;; 添加以下4句到 profile1.el 文件中
  ;(setq cnfonts-use-face-font-rescale t)
  ;(set-face-attribute 'org-level-1 nil :height 1.1 :bold t :foreground "yellow4")
  ;(set-face-attribute 'org-level-2 nil :height 1.1 :bold t)
  ;(set-face-attribute 'org-level-3 nil :height 1.0 :bold t)
  (global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
  (global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
  (message "切换到默认字体"))
)

(global-set-key (kbd "C-x v f") 'cnfonts-profile-toggle)


(defun cnfonts--set-all-the-icons-fonts (fontsizes-list)
    "Show icons in all-the-icons."
    (when (featurep 'all-the-icons)
      (dolist (charset '(kana han cjk-misc bopomofo gb18030))
        (set-fontset-font (frame-parameter nil 'font) charset (font-spec :family "Microsoft Yahei"))
        (set-fontset-font "fontset-default" charset "all-the-icons" nil 'append)
        (set-fontset-font "fontset-default" charset "file-icons" nil 'append)
        (set-fontset-font "fontset-default" charset "Material Icons" nil 'append)
        (set-fontset-font "fontset-default" charset "github-octicons" nil 'append)
        (set-fontset-font "fontset-default" charset "FontAwesome" nil 'append)
        (set-fontset-font "fontset-default" charset "Weather Icons" nil 'append)

	)))

  (add-hook 'cnfonts-set-font-finish-hook #'cnfonts--set-all-the-icons-fonts)

;;---------------------------------------使用鼠标缩放字体------------------------------
;(setq text-scale-mode-step 1.1)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
;(global-set-key (kbd "<C-wheel-up>") 'cnfonts-increase-fontsize)
;(global-set-key (kbd "<C-wheel-down>") 'cnfonts-decrease-fontsize)


;; =================================== 字体设置 END ===================================


;;-----------------------------------------最大化窗口----------------------------------
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;------------------Only open one emacs window-----------------------------------------
(server-force-delete)  ;; WARNING: Kills any existing edit server
;; Suppress error "directory ~/.emacs.d/server is unsafe" on windows.
;; 通过 emacs_daemon.bat 增加 takeown /f ..\..\Config\.emacs.d\server 修改 server 的 owner
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
       ; line-column
	   )
      :separator " | ")  
      (buffer-position hud :separator "")
	 (battery :when active)  ;; 修改在mode line 中的位置
	 time-and-date
	 (global :when active)  ;; 配合 yahoo-weather-mode, 关闭了yahoo-weather-mode就注释掉
     ,@additional-segments
     ))

(defun spaceline--fancy-battery-mode-line ()  ;; 修改spaceline-segments源文件中的函数
  "Assemble a mode line string for Fancy Battery Mode."
  (when fancy-battery-last-status
    (let* ((type (cdr (assq ?L fancy-battery-last-status)))
           (percentage (spaceline--fancy-battery-percentage))
           (time (spaceline--fancy-battery-time))
		   (charge-type (cdr (assq ?b fancy-battery-last-status))))
      (cond
       ((string= "on-line" type) (concat ""  percentage charge-type time))
       ((string= type "") " No Battery")
       (t (concat (if (string= "AC" type) "" "")  percentage charge-type time))))))

(defun spaceline--fancy-battery-face ()  ;;修改spaceline-segments源文件中的函数
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


(setq config-alist
            '(("*" all-the-icons-faicon "circle" :height 0.5 :v-adjust -0.03 :face '(:foreground "red4"))
              ("-" all-the-icons-faicon "check-circle" :height 0.6 :v-adjust -0.03 :face '(:foreground "DarkGreen"))
              ("%" all-the-icons-faicon "times-circle" :height 0.6 :v-adjust -0.03 :face 'all-the-icons-purple)
	      ))


(spaceline-define-segment buffer-modified
  "Buffer modified marker."

  )

(defface my-file-face
  '((t :foreground "MidnightBlue"
       :weight bold
      ))
  "face for user defined variables."
)  

(setq all-the-icons-ibuffer-icon-v-adjust -0.1)
(spaceline-define-segment buffer-id
  "Name of buffer."

(let ((icon (cond ((and (buffer-file-name) (all-the-icons-auto-mode-match?))
                     (all-the-icons-icon-for-file (file-name-nondirectory (buffer-file-name))
                                                  :height all-the-icons-ibuffer-icon-size
                                                  :v-adjust all-the-icons-ibuffer-icon-v-adjust))
                    ((eq major-mode 'dired-mode)
                     (all-the-icons-icon-for-dir (buffer-name)
                                                 :height all-the-icons-ibuffer-icon-size
                                                 :v-adjust all-the-icons-ibuffer-icon-v-adjust
                                                 :face 'all-the-icons-ibuffer-dir-face))
                    (t (all-the-icons-icon-for-mode major-mode
                                                    :height all-the-icons-ibuffer-icon-size
                                                    :v-adjust all-the-icons-ibuffer-icon-v-adjust)))))
    (if (or (null icon) (symbolp icon))
        (setq icon (all-the-icons-faicon "file-o"
                                         :face (if all-the-icons-ibuffer-color-icon
                                                   'all-the-icons-dsilver
                                                 'all-the-icons-ibuffer-icon-face)
                                         :height (* 0.9 all-the-icons-ibuffer-icon-size)
                                         :v-adjust all-the-icons-ibuffer-icon-v-adjust))
      (let* ((props (get-text-property 0 'face icon))
             (family (plist-get props :family))
             (face (if all-the-icons-ibuffer-color-icon
                       (or (plist-get props :inherit) props)
                     'all-the-icons-ibuffer-icon-face))
             (new-face `(:inherit ,face :family ,family)))
        (concat
     (propertize icon 'face new-face)
	(propertize (powerline-buffer-id) 'face 'my-file-face)
	" " 
    (propertize (format (eval (cdr (assoc (format-mode-line "%*") config-alist))) "%s"))	
  )))))


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
  '((t :foreground "purple"
       :weight bold
      ))
  "face for user defined variables."
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

(global-total-lines-mode)

(spaceline-define-segment buffer-size
  "The current line and column numbers, or `(current page/number of pages)`
in pdf-view mode (enabled by the `pdf-tools' package)."
 (concat (cond ((eq major-mode 'pdf-view-mode) (spaceline--pdfview-page-number)) 
			    ((bound-and-true-p total-lines-mode) (concat 
				(propertize "%l(" 'face '(:foreground "purple" :weight bold)) 
				(propertize (format "%d" total-lines) 'face '(:foreground "red4" :weight bold)) 
				(propertize "):%c" 'face '(:foreground "purple" :weight bold))
				))
			    (t (propertize "%l:%c" 'face '(:foreground "purple" :weight bold)))) 
				(propertize "|" 'face '(:foreground "tan4")) 
				(propertize (powerline-buffer-size) 'face '(:foreground "DarkGreen" :slant italic)) 
				)
  )

(defface my-major-face
  '((t :foreground "SkyBlue1"
       :weight bold
      ))
  "face for user defined variables.")


  
(spaceline-define-segment major-mode
  "The name of the major mode."
  (propertize (powerline-major-mode) 'face 'my-major-face)  
  )  
  

;;===================================== MODE LINE END =======================================

;; 在标题栏显示登陆名称和文件名  ;;show the current directory in the frame bar
(setq frame-title-format
      '((:eval
         (let ((login-name (getenv-internal "LOGNAME")))
           (if login-name (concat login-name "@") "")))
        (:eval (concat " JL@" (system-name)))
        " | "
        (:eval (or (buffer-file-name) (concat default-directory "--" (buffer-name))))
	))


;;---------- 代码参考线 ------------------
;; (require 'fill-column-indicator)
;; (setq fci-rule-width 1)
;; (setq fci-rule-color "grey30")
;; (setq fci-rule-column 80)
;; (add-hook 'after-change-major-mode-hook 'fci-mode)


;;Global minor mode that centers the text of the window. 
(require 'centered-window)
(centered-window-mode t)
(setq cwm-centered-window-width (ceiling (* 1.95 (display-pixel-width))))

;; 修改窗口按列分栏时left-fringe 消失的问题
;; https://github.com/anler/centered-window-mode/pull/39
(defun cwm-calculate-appropriate-fringe-widths (window)
  (let* ((mode-active-p (with-current-buffer (window-buffer window) centered-window-mode))
         (pixel (frame-char-width (window-frame window)))
         (window-width (window-total-width window))
         (n  (if mode-active-p
               (max
                (/ (- window-width cwm-centered-window-width)
                   2)
                (if cwm-incremental-padding
                    (/ (* window-width cwm-incremental-padding-%)
                       100)
                  0))
               0))
         (ratio (/ (* n cwm-left-fringe-ratio) 100))
         (left-width (if (> n 0) (* pixel (+ n ratio)) nil))  ;; HACKED by JL
         (right-width (if (> n 0) (* pixel (- n ratio)) 0)))  ;; HACKED by JL
    `(,left-width . ,right-width)))

(beacon-mode 1)
(setq beacon-blink-duration 0.08)
(setq beacon-size 25)

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
(diminish 'auto-revert-mode) 
(diminish 'auto-fill-mode)
(diminish 'fast-scroll-minor-mode)
(diminish 'ws-butler-mode)
(diminish 'beacon-mode)
(diminish 'ivy-mode)
(diminish 'centered-window-mode)
;(diminish 'which-key-mode) ;; 不起作用
(setq which-key-lighter "")
;(diminish 'wakatime-mode) ;; 要出现在加载wakatime-mode之后

"Init Face"
(interactive)			
			)

(defun init-mix ()

;;; timestamps in *Messages*   与24.5冲突
; (defun current-time-microseconds ()
  ; (let* ((nowtime (current-time))
         ; (now-ms (nth 2 nowtime)))
    ; (concat (format-time-string "[%Y-%m-%dT%T" nowtime) (format ".%d] " now-ms))))

; (defadvice message (before test-symbol activate)
  ; (if (not (string-equal (ad-get-arg 0) "%s%s"))
      ; (let ((deactivate-mark nil))
        ; (save-excursion
          ; (set-buffer "*Messages*")
          ; (goto-char (point-max))
          ; (if (not (bolp))
              ; (newline))
          ; (insert (current-time-microseconds))))))


;;====================================== w3m ==========================================
(setq w3m-use-favicon nil)
(setq w3m-command-arguments '("-cookie" "-F"))
(setq w3m-use-cookies t)
(setq w3m-home-page "http://www.baidu.com")

;;用w3m浏览网页时也显示图片
(setq w3m-default-display-inline-images t)

(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
;; optional keyboard short-cut
; (global-set-key "\C-xm" 'browse-url-at-point)

(defun w3m-browse-url-with-eww ()
  (interactive)
  (eww w3m-current-url)
  (message "Opened in eww-mode"))

(defun w3m-browse-url-with-external-browser ()
  (interactive)
  (eww-browse-with-external-browser w3m-current-url)
  (message "Opened in external browser"))

(add-hook 'w3m-mode-hook
       (lambda ()
         (local-set-key "%" 'w3m-browse-url-with-eww)
         (local-set-key "&" 'w3m-browse-url-with-external-browser)))  
  
 
;; ===================================== eww ==========================================
(setq shr-use-fonts nil)
(global-set-key "\C-cw" 'eww)

;; use browser depending on url
(setq browse-url-browser-function 'browse-url-default-windows-browser)


(defun eww-browse-url-with-w3m ()
  (interactive)
  (w3m (eww-copy-page-url ))
  (message "Opened in w3m-mode"))

(add-hook 'eww-mode-hook
       (lambda ()
         (local-set-key "%" 'eww-browse-url-with-w3m)))  
  
;;===================== Elfreed is a web feed client for Emacs ========================
(global-set-key (kbd "C-x w") 'elfeed)

(setq elfeed-feeds
      '(
	  ; "http://hb.qq.com/news/newsrss.xml"
        ; "https://www.quora.com/rss"
		))

(require 'elfeed)
(require 'elfeed-goodies)

;(elfeed-goodies/setup)
; (setq elfeed-goodies/entry-pane-size 0.5)
; (setq elfeed-goodies/powerline-default-separator (quote bar))

;; Load elfeed-org
(require 'elfeed-org)
(elfeed-org)

;; Optionally specify a number of files containing elfeed
;; configuration. If not set then the location below is used.
;; Note: The customize interface is also supported.
(setq rmh-elfeed-org-files (list "~/.emacs.d/user-files/elfeed.org"))


(setq elfeed-goodies/entry-pane-position (quote bottom))
(setq elfeed-goodies/entry-pane-size 0.6)
(setq elfeed-goodies/feed-source-column-width 16)
(setq elfeed-goodies/powerline-default-separator (quote wave))
(setq elfeed-search-filter "@6-months-ago")
(setq elfeed-show-entry-author nil)
(setq elfeed-show-entry-delete (quote elfeed-goodies/delete-pane))
(setq elfeed-show-entry-switch (quote elfeed-goodies/switch-pane))

(when (boundp 'utf-translate-cjk)
  (setq utf-translate-cjk t)
  (custom-set-variables
   '(utf-translate-cjk t)))
(if (fboundp 'utf-translate-cjk-mode)
    (utf-translate-cjk-mode 1))


;; 要出现在 sunrise 之后；否则会出错
;;Setting Emacs default Split to Horizontal
;; 控制 window 弹出方式 改变以下两条语句中的数字
(setq split-height-threshold nil)
(setq window-min-height 15)
(setq split-width-threshold 0)
(setq window-min-width 45)


;;----------------- Calendar ------------------
(setq calendar-week-start-day 1)

(require 'cal-china-x)
(setq mark-holidays-in-calendar t)
(setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
(setq calendar-holidays cal-china-x-important-holidays)


;;============================= Weather =============================
;; -------------- sunshine ---------------
(require 'sunshine)
(setq sunshine-location "Wuhan, China")
(setq sunshine-appid "29e41ab31b23e473a5aebafd93348235")
(setq sunshine-show-icons t)
(setq sunshine-units (quote metric))

(defun sunshine-forecast-wuhan ()
  "The main entry into Sunshine; display the forecast in a window."
  (interactive)
  ;(sunshine-prepare-window)
  (sunshine-get-forecast "Wuhan, China" sunshine-units 'full sunshine-appid))

(global-set-key (kbd "C-c C-w") 'sunshine-forecast)  
  
;; -------------- wttrin --------------
(setq wttrin-default-cities '("Wuhan" "Glasgow"))
(setq wttrin-default-accept-language '("Accept-Language" . "en-US"))

;; ---------- Yahoo weather ----------- Yahoo查阅网站打不开了
; (defface my-weather-face
  ; '((t :foreground "SkyBlue1"
      ; :weight bold
      ; ))
  ; "face for user defined variables."
; )

; (setq yahoo-weather-location "Glasgow")
; (setq yahoo-weather-mode-line
    ; '(:eval
     ; (propertize
      ; (yahoo-weather-info-format yahoo-weather-info yahoo-weather-format)
      ; 'face 'my-weather-face
	   ; )))
 
; (setq yahoo-weather-temperture-format "%d")
; (setq yahoo-weather-format (concat "%(weather) %(temperature)" (substring "⁻℃" 1 nil) "   "))
; (condition-case nil
	; (yahoo-weather-mode)
	 ; (error 
	 ; (message "Weather Not Available")
	 ; ))

;; ================ Translate =======================
;; ----------- google translate --------------------
(setq google-translate-default-source-language "en")
(setq google-translate-default-target-language "zh-CN")
(setq google-translate-output-destination nil)
(setq google-translate-show-phonetic t)
 
(setq google-translate-base-url
  "http://translate.google.cn/translate_a/single")	 
(setq google-translate-listen-url
  "http://translate.google.cn/translate_tts")	

(setq google-translate--tkk-url
  "http://translate.google.cn/")

;; -------------------  youdao -----------------------
(require 'youdao-dictionary)
(setq url-automatic-caching t)

;; Example Key binding
(global-set-key (kbd "C-c y") 'youdao-dictionary-search-at-point+)

;; Integrate with popwin-el (https://github.com/m2ym/popwin-el)
(push "*Youdao Dictionary*" popwin:special-display-config)


(defun youdao-pdf-translate ()
(interactive)
(pdf-view-kill-ring-save)
  (let ((word (car kill-ring)))
(if word
      (youdao-dictionary--pos-tip (youdao-dictionary--format-result word))
      (message "Nothing to look up"))))

(defun pdf-set-youdao-key ()
(define-key pdf-view-mode-map "y" 'youdao-pdf-translate)                     ;第一页
)

(add-hook 'pdf-view-mode-hook 'pdf-set-youdao-key)	  

;; ---------------------- CSV Mode -------------------
; (use-package csv-mode)
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
"Major mode for editing comma-separated value files." t)


;; ---------------------- shell -----------------------
;;shell-pop
(global-set-key (kbd "\C-x t") 'shell-pop) 
(setq shell-pop-universal-key "C-x t")
(setq shell-pop-window-size 30)
(setq shell-pop-full-span t)
(setq shell-pop-window-position "bottom")

(require 'aweshell)

;; ------------------------ Reddit ---------------------
(require 'md4rd)
(setq md4rd-subs-active '(MachineLearning learnmachinelearning statistics rstats Rlanguage Python learnpython emacs ))
(setq md4rd--oauth-access-token "KT1qHgAxO-Ff1Ts5f1NFMFxiddA")

;; --------------------- vimrc-mode --------------------
(add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; --------------------- pomider -------------------------------  
(add-hook 'pomidor-mode-hook 
(lambda () 
	  (setq global-mode-string
             '(:eval
               (concat " " (format-time-string "%M:%S " (pomidor-work-duration) t))))))

(defadvice pomidor-stop (before pomidor-save-log activate)
    "Log pomidor data to the ~/pomidor-log.csv file.
Columns: date,work,overwork,break,total"
    (write-region (format "%s,%s,%s,%s,%s\n"
                          (format-time-string "%Y/%m/%d-%R")
                          (format-time-string "%M:%S" (pomidor-work-duration) t)
                          (format-time-string "%M:%S" (pomidor-overwork-duration) t)
                          (format-time-string "%M:%S" (pomidor-break-duration) t)
			  (format-time-string "%M:%S" (pomidor-total-duration) t))
                  nil
                  "~/.emacs.d/user-files/pomidor-log.csv"
                  'append))

(defun  pomidor-off-modeline ()
  (interactive)
 (setq global-mode-string nil)
(pomidor-quit)
  )

;; waka time
(global-wakatime-mode)
(diminish 'wakatime-mode)

;; tabs
;(require 'awesome-tab)
;(awesome-tab-mode t)

;(require 'leetnote)
;(setq url-debug t)

;; emoji
(require 'company-emoji)
(add-to-list 'company-backends 'company-emoji)


"Init Mix"
(interactive)			
			)
		  

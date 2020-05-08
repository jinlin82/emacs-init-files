(defun init-mail ()

;; ============================Sending Mail============================
(setq user-full-name  "金林"
user-mail-address  "jinlin82@qq.com"
mail-from-style    'angles)


(setq send-mail-function		'smtpmail-send-it
      smtpmail-smtp-server      "smtp.qq.com"
	     smtpmail-stream-type  'ssl
          smtpmail-smtp-service 465
)	
   
(load-library "smtpmail")

(add-to-list 'load-path "~/../emacs26.2_64/lisp/gnus/lisp")
(add-to-list 'load-path "~/../emacs26.2_64/lisp/gnus/contrib")
	   

(setq pop3-uidl-file "~/Gnus/.pop3-uidl")
(setq gnus-startup-file "~/Gnus/.newsrc")                  ;初始文件
(setq gnus-init-file "~/Gnus/.gnus.el")                  ;初始文件
(setq gnus-home-directory "~/Gnus/")
(setq gnus-directory "~/Gnus/News/")
(setq gnus-dribble-directory "~/Gnus/")                    ;恢复目录
(setq gnus-article-save-directory "~/Gnus/News/")          ;文章保存目录
(setq gnus-kill-files-directory "~/Gnus/News/")      ;文件删除目录
(setq gnus-cache-directory "~/Gnus/News/cache/")           ;缓存目录
(setq message-directory "~/Gnus/Mail/")                    ;邮件的存储目录
(setq message-auto-save-directory "~/Gnus/Mail/drafts")    ;自动保存的目录
(setq mail-source-directory "~/Gnus/Mail/")        ;邮件的源目录
(setq nnmail-message-id-cache-file "~/Gnus/.nnmail-cache") ;nnmail的消息ID缓存
(setq nnfolder-directory "~/Gnus/Mail/archive/")
;;(setq nntp-authinfo-file "~/Gnus/.authinfo") ;;smtp authinfo 不支持指定位置，因此统一使用 ~/.authinfo


(setq mail-default-directory "~/Gnus")
(setq message-confirm-send t)                       ;防止误发邮件, 发邮件前需要确认
(setq message-kill-buffer-on-exit t)                ;设置发送邮件后删除buffer
(setq message-from-style 'angles)                   ;`From' 头的显示风格

(setq message-signature-directory "~./Gnus/")
(setq message-signature-file "~./Gnus/.signature")
(setq message-forward-as-mime nil)                    ;以普通格式转发邮件，不是以附件转发
(setq message-forward-show-mml nil)
	

;;colorizing multiply-quoted lines in Message Mode
 (add-hook 'message-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
               '(("^[ \t]*>[ \t]*>[ \t]*>.*$"
                  (0 'message-multiply-quoted-text-face))
                 ("^[ \t]*>[ \t]*>.*$"
                  (0 'message-double-quoted-text-face))))))


				  
(global-set-key (kbd "C-x m") 'compose-mail)

(defun my-message-send-and-exit ()
(interactive)
(message-goto-bcc)
(insert "jinlin@znufe.edu.cn")
(message-send-and-exit)
)


 (define-key message-mode-map "\C-c\C-c" 'my-message-send-and-exit)

				  
;; ======================== Reading Mail ================================
;;-------------RMAIL--------------------------
;; RMAIL 的问题: 1. 要么删除 邮件，要么重复收取邮件 2. 不能读取 html 邮件
 ; (setenv "MAILHOST" "pop.qq.com")
 ; (setq rmail-primary-inbox-list '("po:jinlin82")
       ; rmail-pop-password-required t)

;; Emacs Wiki 下面其他方式均初步试过，都不能在 Windows 下应用。
;; 因此 唯一的选择 Gnus

; (require 'oauth2)
; (require 'google-contacts)
; (require 'google-contacts-gnus)
 
"Init Mail"
(interactive)			
			)
			
			

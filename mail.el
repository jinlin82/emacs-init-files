(defun init-mail ()

;; ============================Sending Mail============================
(setq user-full-name  "����"
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
(setq gnus-startup-file "~/Gnus/.newsrc")                  ;��ʼ�ļ�
(setq gnus-init-file "~/Gnus/.gnus.el")                  ;��ʼ�ļ�
(setq gnus-home-directory "~/Gnus/")
(setq gnus-directory "~/Gnus/News/")
(setq gnus-dribble-directory "~/Gnus/")                    ;�ָ�Ŀ¼
(setq gnus-article-save-directory "~/Gnus/News/")          ;���±���Ŀ¼
(setq gnus-kill-files-directory "~/Gnus/News/")      ;�ļ�ɾ��Ŀ¼
(setq gnus-cache-directory "~/Gnus/News/cache/")           ;����Ŀ¼
(setq message-directory "~/Gnus/Mail/")                    ;�ʼ��Ĵ洢Ŀ¼
(setq message-auto-save-directory "~/Gnus/Mail/drafts")    ;�Զ������Ŀ¼
(setq mail-source-directory "~/Gnus/Mail/")        ;�ʼ���ԴĿ¼
(setq nnmail-message-id-cache-file "~/Gnus/.nnmail-cache") ;nnmail����ϢID����
(setq nnfolder-directory "~/Gnus/Mail/archive/")
;;(setq nntp-authinfo-file "~/Gnus/.authinfo") ;;smtp authinfo ��֧��ָ��λ�ã����ͳһʹ�� ~/.authinfo


(setq mail-default-directory "~/Gnus")
(setq message-confirm-send t)                       ;��ֹ���ʼ�, ���ʼ�ǰ��Ҫȷ��
(setq message-kill-buffer-on-exit t)                ;���÷����ʼ���ɾ��buffer
(setq message-from-style 'angles)                   ;`From' ͷ����ʾ���

(setq message-signature-directory "~./Gnus/")
(setq message-signature-file "~./Gnus/.signature")
(setq message-forward-as-mime nil)                    ;����ͨ��ʽת���ʼ��������Ը���ת��
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
;; RMAIL ������: 1. Ҫôɾ�� �ʼ���Ҫô�ظ���ȡ�ʼ� 2. ���ܶ�ȡ html �ʼ�
 ; (setenv "MAILHOST" "pop.qq.com")
 ; (setq rmail-primary-inbox-list '("po:jinlin82")
       ; rmail-pop-password-required t)

;; Emacs Wiki ����������ʽ�������Թ����������� Windows ��Ӧ�á�
;; ��� Ψһ��ѡ�� Gnus

; (require 'oauth2)
; (require 'google-contacts)
; (require 'google-contacts-gnus)
 
"Init Mail"
(interactive)			
			)
			
			

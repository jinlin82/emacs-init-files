(defun init-pdf ()

;;===================================== Doc Viewer =====================================
(setq doc-view-continuous t)
(setq doc-view-ghostscript-program "~/../gs9.15/bin/gswin32.exe")

;;solution to deal the conflict with evil-mode: blinking
(add-hook 'doc-view-mode-hook
  (lambda ()
    (set (make-local-variable 'evil-emacs-state-cursor) (list nil))))
	
;; disable linum-mode 	
(defun my-inhibit-global-linum-mode ()
  "Counter-act `global-linum-mode'."
  (add-hook 'after-change-major-mode-hook
            (lambda () (display-line-numbers-mode 0))
            :append :local))
			
(add-hook 'doc-view-mode-hook 'my-inhibit-global-linum-mode)
	
;; =================================== pdf-tools =======================================
;; ʹ�ùٷ��� 64 λϵͳ���������ٶȸ��졣 Ϊ֧��pdf tools������ pdf-tools-20180428.827.7z
;; ��ѹ��copy��elpa�ļ��м��ɣ�ע��ɾ�������汾��pdf-tools�ļ��У�

(pdf-tools-install)
(setq-default pdf-view-display-size 'fit-page)
(setq pdf-view-resize-factor 1.1)

;;solution to deal the conflict with evil-mode: blinking
;;(evil-set-initial-state 'pdf-view-mode 'emacs)  ; set in custom.files
(add-hook 'pdf-view-mode-hook
  (lambda ()
    (set (make-local-variable 'evil-emacs-state-cursor) (list nil))))
		
(add-hook 'pdf-view-mode-hook 'my-inhibit-global-linum-mode)

(add-hook 'image-mode-hook
  (lambda ()
    (set (make-local-variable 'evil-emacs-state-cursor) (list nil))))
		
(add-hook 'image-mode-hook 'my-inhibit-global-linum-mode)

;; midnite mode hook
; (add-hook 'pdf-view-mode-hook (lambda ()
                                ; (pdf-view-midnight-minor-mode))) ; automatically turns on midnight-mode for pdfs

; (setq pdf-view-midnight-colors '("#00B800" . "#000000" )) ; set the green profile as default (see below)

(defun pdf-no-filter ()
  "View pdf without colour filter."
  (interactive)
  (pdf-view-midnight-minor-mode -1)
  )

;; change midnite mode colours functions
(defun pdf-midnite-original ()
  "Set pdf-view-midnight-colors to original colours."
  (interactive)
  (setq pdf-view-midnight-colors '("#839496" . "#002b36" )) ; original values
  (pdf-view-midnight-minor-mode)
  )

(defun pdf-midnite-amber ()
  "Set pdf-view-midnight-colors to amber on dark slate blue."
  (interactive)
  (setq pdf-view-midnight-colors '("#ff9900" . "#0a0a12" )) ; amber
  (pdf-view-midnight-minor-mode)
  )

(defun pdf-midnite-green ()
  "Set pdf-view-midnight-colors to green on black."
  (interactive)
  (setq pdf-view-midnight-colors '("#00B800" . "#000000" )) ; green
  (pdf-view-midnight-minor-mode)
  )
  
(defun pdf-midnite-grey ()
  "Set pdf-view-midnight-colors to green on black."
  (interactive)
  (setq pdf-view-midnight-colors '("#DCDCCC" . "#383838")) ; grey
  (pdf-view-midnight-minor-mode)
  )
  
(defun pdf-midnite-white-theme ()
  "Set pdf-view-midnight-colors to green on black."
  (interactive)
  (setq pdf-view-midnight-colors '("gray20" . "lemon chiffon")) ; grey
  (pdf-view-midnight-minor-mode)
  )  

(defun pdf-midnite-black-theme ()
  "Set pdf-view-midnight-colors to green on black."
  (interactive)
  (setq pdf-view-midnight-colors '("gray" . "gray28")) ; grey
  (pdf-view-midnight-minor-mode)
  )   
  

(defun pdf-midnite-colour-schemes ()
  "Midnight mode colour schemes bound to keys"
  (local-set-key (kbd "!") (quote pdf-no-filter))
  (local-set-key (kbd "@") (quote pdf-midnite-grey))
  (local-set-key (kbd "#") (quote pdf-midnite-black-theme))
  (local-set-key (kbd "$") (quote pdf-midnite-amber))
  (local-set-key (kbd "%") (quote pdf-midnite-original))
  (local-set-key (kbd "w") (quote pdf-midnite-white-theme))
  )

(add-hook 'pdf-view-mode-hook 'pdf-midnite-colour-schemes)

(defun pdf-set-key ()
(define-key pdf-view-mode-map "," 'pdf-view-first-page)                     ;��һҳ
(define-key pdf-view-mode-map "." 'pdf-view-last-page)                      ;���һҳ
(define-key pdf-view-mode-map "g" 'pdf-view-goto-page)                      ;�����ڼ�ҳ
(define-key pdf-view-mode-map "e" 'pdf-view-scroll-down-or-previous-page)   ;���Ϲ���һ��
(define-key pdf-view-mode-map "SPC" 'pdf-view-scroll-up-or-next-page)       ;���¹���һ��
(define-key pdf-view-mode-map "j" 'pdf-view-next-line-or-next-page)         ;��һ�л���һ��
(define-key pdf-view-mode-map "k" 'pdf-view-previous-line-or-previous-page) ;��һ�л���һ��
(define-key pdf-view-mode-map "h" 'image-scroll-right)         ;��һ�л���һ��
(define-key pdf-view-mode-map "l" 'image-scroll-left) ;��һ�л���һ��
(define-key pdf-view-mode-map "x" 'kill-this-buffer)                        ;�˳�
(define-key pdf-view-mode-map "d" 'quit-window)                        ;�˳�
(define-key pdf-view-mode-map (kbd "<C-wheel-up>") 'pdf-view-enlarge)
(define-key pdf-view-mode-map (kbd "<C-wheel-down>") 'pdf-view-shrink)
(define-key pdf-view-mode-map (kbd "C-c C-c") 'interleave-open-notes-file-for-pdf)
)

(add-hook 'pdf-view-mode-hook 'pdf-set-key)


(defun pdf-tools-set-coding-system ()
  (with-current-buffer (current-buffer)
        (setq buffer-file-coding-system 'utf-8)
     ))
	  
(add-hook 'pdf-view-mode-hook 'pdf-tools-set-coding-system)

;; ============================= org-noter =================================
;; Ŀǰ���ڸ��ӣ���ֱ̫�ۣ����ǹ����ƺ��Ƚ�ǿ���Ժ��л�������
; (setq org-noter-always-create-frame nil)
; (setq org-noter-default-notes-file-names (quote ("PDFNotes.org")))
; (setq org-noter-notes-window-behavior (quote (scroll only-prev)))
; (setq org-noter-separate-notes-from-heading nil)


; (defun org-noter-kill-session-modified ()
  ; "Kill org-noter"
  ; (interactive)
  ; (org-noter-kill-session)
  ; (kill-this-buffer)
  ; )
  

; (add-hook 'org-noter-doc-mode-hook '(lambda ()
	; (define-key org-noter-doc-mode-map "q" 'org-noter-kill-session-modified))) 

;; ============================= interleave ================================
;; Ϊ���������·������interleave��hacked by Jin Lin ����
 (setq nterleave-disable-narrowing t)
 (setq interleave-insert-relative-name nil)
 (setq interleave-org-notes-dir-list (quote ("~/../../Works/Learning/Interleave_Org/" ".")))

 
 (add-hook 'org-mode-hook '(lambda ()
	(define-key org-mode-map (kbd "C-c i") 'interleave-mode)
	))

(defun my-interleave-hook ()
  (with-current-buffer interleave-pdf-buffer
    ;; Do something meaningful here
    (message "Interleave ON. I'm in the PDF buffer!")))

(add-hook 'interleave-mode-hook #'my-interleave-hook)

;; unset M-n key for interleave-sync-pdf-page-next
(eval-after-load 'interleave '(define-key interleave-mode-map "\M-n" nil))
(eval-after-load 'interleave '(define-key interleave-mode-map "\M-p" nil))


;; ============================= org-pdfview ================================
(eval-after-load 'org '(require 'org-pdfview))
(add-to-list 'org-file-apps '("\\.pdf\\'" . (lambda (file link) (org-pdfview-open link))))

"Init Pdf"
(interactive)			
			)








		  

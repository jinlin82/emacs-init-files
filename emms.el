;EMMS player (a music/video player for emacs)


;; 注意： 各个windows系统下 emacs 中 emms，bongo 等媒体播放器（已试过各种 backend，包括 mplayer，mpv等不支持中文路径和中文文件名，这些文件直接被跳过，所以暂时不能使用


(defun init-emms ()
(add-to-list 'exec-path "~/../mplayer/")
(add-to-list 'exec-path "~/../mp3info-0.8.5/")




(require 'emms-setup)
(emms-all)
(emms-default-players)

(setq emms-player-list '(emms-player-mpg321
                         emms-player-ogg123
                         emms-player-mplayer))

(setq emms-source-file-default-directory "~/../../Music/")

;; Now we will add all our music to a playlist by invoking M-x emms-add-directory-tree RET ~/Music/ RET. 
;; We do this because then Emms will read the tags of all your music files and caches them
;; coding settings						 
(setq emms-info-mp3info-coding-system 'utf-8
      emms-cache-file-coding-system 'utf-8
      emms-i18n-default-coding-system '(utf-8 . utf-8)
      )

;; global key-map
(global-set-key (kbd "C-c e e") 'emms)
(global-set-key (kbd "C-c g") '(lambda () (interactive) (emms-playlist-mode-go) (emms-playlist-mode-goto-selected-track)))
(global-set-key (kbd "C-c e t") 'emms-play-directory-tree)
(global-set-key (kbd "C-c e x") 'emms-start)
(global-set-key (kbd "C-c e s") 'emms-stop)
(global-set-key (kbd "C-c e n") 'emms-next)
(global-set-key (kbd "C-c e p") 'emms-previous)
(global-set-key (kbd "C-c e o") 'emms-show)
(global-set-key (kbd "C-c e h") 'emms-shuffle)
(global-set-key (kbd "C-c e e") 'emms-play-file)
(global-set-key (kbd "C-c e f") 'emms-play-playlist)
(global-set-key (kbd "C-c e SPC") 'emms-pause)
(global-set-key (kbd "C-c e a") 'emms-add-directory-tree)
(global-set-key (kbd "C-c e m") 'emms-state-mode)
(global-set-key (kbd "C-c e r") 'emms-toggle-repeat-track)
(global-set-key (kbd "C-c e R") 'emms-toggle-repeat-playlist)

(defun emms-playlist-mode-goto-selected-track ()
  (interactive)
  (goto-char (marker-position emms-playlist-selected-marker))
  (message "Current Track"))


;; playlist-mode-map
(define-key emms-playlist-mode-map (kbd "SPC") 'emms-pause)


(emms-mode-line nil)
(emms-playing-time 1)
(eval-after-load 'emms '(emms-state-mode))

"Init Mail"
(interactive)			
			)
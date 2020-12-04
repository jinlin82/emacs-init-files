;; Mobile 在XP系统中使用 Courier new 字体，使用Consolas字体会出错
 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-hl-change ((t (:background "cyan" :foreground "blue3"))))
 '(diff-hl-insert ((t (:inherit diff-added :background "dark green"))))
 '(diff-refine-added ((t (:inherit diff-refine-changed :background "dark green" :foreground "lime green"))))
 '(diff-refine-removed ((t (:inherit diff-refine-changed :background "PaleVioletRed1"))))
 '(dired-filetype-document ((t (:foreground "deep sky blue"))))
 '(elfeed-search-title-face ((t (:foreground "royal blue"))))
 '(emms-state-current-playing-time ((t (:inherit font-lock-variable-name-face :foreground "SkyBlue1"))))
 '(emms-state-total-playing-time ((t (:inherit font-lock-constant-face :foreground "LightGreen"))))
 '(font-latex-sedate-face ((t (:inherit font-latex-math-face))))
 '(helm-match ((t (:foreground "purple"))))
 '(helm-selection ((t (:background "dark khaki" :distant-foreground "black"))))
 '(highlight-indentation-face ((t nil)))
 '(line-number ((t (:inherit (shadow default)))))
 '(line-number-current-line ((t (:inherit line-number :inverse-video t :slant italic :weight bold))))
 '(linum ((t (:inherit (shadow default) :foreground "light slate gray" :slant italic :width narrow :height 0.9))))
 '(markdown-code-face ((t (:inherit font-lock-doc-face :weight normal))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :foreground "firebrick" :weight bold :height 1.3))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :foreground "dark green" :weight bold :height 1.2))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :weight bold :height 1.1))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :foreground "orange red" :weight bold :height 1.0))))
 '(markdown-language-info-face ((t (:inherit warning :weight bold))))
 '(markdown-markup-face ((t (:inherit shadow :foreground "LightCoral" :slant normal :weight normal))))
 '(markdown-math-face ((t (:inherit font-lock-string-face :foreground "peru"))))
 '(neo-vc-ignored-face ((t (:foreground "SystemGrayText"))))
 '(neo-vc-up-to-date-face ((t (:foreground "medium sea green"))))
 '(org-checkbox ((t (:inherit bold :foreground "medium sea green"))))
 '(preview-face ((((background dark)) (:foreground "white"))))
 '(preview-reference-face ((t (:background "grey"))))
 '(rainbow-delimiters-mismatched-face ((t (:foreground "red" :box (:line-width 2 :color "red") :weight bold))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "red" :weight bold))))
 '(reb-match-0 ((t (:background "yellow"))))
 '(sp-show-pair-match-face ((t (:inherit show-paren-match :underline t :weight bold))))
 '(spaceline-evil-emacs ((t (:foreground "#3E3D31" :inherit (quote mode-line)))))
 '(spaceline-modified ((t (:background "DarkGoldenrod2" :foreground "red" :inherit (quote mode-line)))))
 '(spaceline-read-only ((t (:background "slate grey" :foreground "DeepPink" :inherit (quote mode-line)))))
 '(spaceline-unmodified ((t (:background "dark slate blue" :foreground "DeepPink" :inherit (quote mode-line)))))
 '(sr-active-path-face ((t (:foreground "violet red" :underline "violet red" :slant italic :weight bold :height 120))))
 '(sr-editing-path-face ((t (:background "red" :foreground "yellow" :weight bold))))
 '(sr-highlight-path-face ((t (:background "dim gray" :foreground "#ace6ac" :weight bold))))
 '(sr-passive-path-face ((t (:foreground "slate blue" :weight bold))))
 '(sr-tabs-active-face ((t (:inherit variable-pitch :background "maroon" :weight bold :height 0.9))))
 '(sr-tabs-inactive-face ((t (:inherit variable-pitch :background "plum4" :height 0.9))))
 '(sunshine-forecast-date-face ((t (:foreground "royal blue" :weight bold :height 0.84))))
 '(sunshine-forecast-day-divider-face ((t (:foreground "white" :weight light))))
 '(sunshine-forecast-headline-face ((t (:foreground "forest green" :height 1.5))))
 '(vdiff-change-face ((t (:background "gold"))))
 '(vimish-fold-fringe ((t (:foreground "red" :weight bold))))
 '(which-key-key-face ((t (:inherit font-lock-comment-face))))
 '(which-key-separator-face ((t (:inherit font-lock-constant-face)))))
 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/user-files/bookmarks")
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "8ed752276957903a270c797c4ab52931199806ccd9f0c3bb77f6f4b9e71b9272" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "5e52ce58f51827619d27131be3e3936593c9c7f9f9f9d6b33227be6331bf9881" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(dashboard-startup-banner (quote logo))
 '(evil-emacs-state-modes
   (quote
    (eww-mode sunshine-mode pdf-outline-buffer-mode pdf-view-mode comint-mode erc-mode eshell-mode geiser-repl-mode gud-mode inferior-apl-mode inferior-caml-mode inferior-emacs-lisp-mode inferior-j-mode inferior-python-mode inferior-scheme-mode inferior-sml-mode internal-ange-ftp-mode prolog-inferior-mode reb-mode shell-mode slime-repl-mode term-mode wdired-mode archive-mode bbdb-mode biblio-selection-mode bookmark-bmenu-mode bookmark-edit-annotation-mode browse-kill-ring-mode bzr-annotate-mode calc-mode cfw:calendar-mode completion-list-mode Custom-mode debugger-mode delicious-search-mode desktop-menu-blist-mode desktop-menu-mode doc-view-mode dvc-bookmarks-mode dvc-diff-mode dvc-info-buffer-mode dvc-log-buffer-mode dvc-revlist-mode dvc-revlog-mode dvc-status-mode dvc-tips-mode ediff-mode ediff-meta-mode efs-mode Electric-buffer-menu-mode emms-browser-mode emms-mark-mode emms-metaplaylist-mode emms-playlist-mode ess-help-mode etags-select-mode fj-mode gc-issues-mode gdb-breakpoints-mode gdb-disassembly-mode gdb-frames-mode gdb-locals-mode gdb-memory-mode gdb-registers-mode gdb-threads-mode gist-list-mode git-commit-mode git-rebase-mode gnus-article-mode gnus-browse-mode gnus-group-mode gnus-server-mode gnus-summary-mode google-maps-static-mode ibuffer-mode jde-javadoc-checker-report-mode magit-cherry-mode magit-diff-mode magit-log-mode magit-log-select-mode magit-popup-mode magit-popup-sequence-mode magit-process-mode magit-reflog-mode magit-refs-mode magit-revision-mode magit-stash-mode magit-stashes-mode magit-status-mode magit-mode magit-branch-manager-mode magit-commit-mode magit-key-mode magit-rebase-mode magit-wazzup-mode mh-folder-mode monky-mode mu4e-main-mode mu4e-headers-mode mu4e-view-mode notmuch-hello-mode notmuch-search-mode notmuch-show-mode occur-mode org-agenda-mode package-menu-mode proced-mode rcirc-mode rebase-mode recentf-dialog-mode reftex-select-bib-mode reftex-select-label-mode reftex-toc-mode sldb-mode slime-inspector-mode slime-thread-control-mode slime-xref-mode sr-buttons-mode sr-mode sr-tree-mode sr-virtual-mode tar-mode tetris-mode tla-annotate-mode tla-archive-list-mode tla-bconfig-mode tla-bookmarks-mode tla-branch-list-mode tla-browse-mode tla-category-list-mode tla-changelog-mode tla-follow-symlinks-mode tla-inventory-file-mode tla-inventory-mode tla-lint-mode tla-logs-mode tla-revision-list-mode tla-revlog-mode tla-tree-lint-mode tla-version-list-mode twittering-mode urlview-mode vc-annotate-mode vc-dir-mode vc-git-log-view-mode vc-hg-log-view-mode vc-svn-log-view-mode vm-mode vm-summary-mode w3m-mode wab-compilation-mode xgit-annotate-mode xgit-changelog-mode xgit-diff-mode xgit-revlog-mode xhg-annotate-mode xhg-log-mode xhg-mode xhg-mq-mode xhg-mq-sub-mode xhg-status-extra-mode neotree-mode org-mode elfeed-search-mode elfeed-show-mode)))
 '(evil-toggle-key "M-l")
 '(eww-search-prefix "https://www.google.com/search?q=")
 '(fci-rule-color "#383838")
 '(global-display-line-numbers-mode t)
 '(interleave-disable-narrowing t)
 '(interleave-insert-relative-name t t)
 '(interleave-org-notes-dir-list (quote (".")) t)
 '(magit-todos-ignored-keywords (quote ("NOTE" "???" "XXX")))
 '(markdown-enable-math t)
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(org-noter-always-create-frame nil)
 '(org-noter-default-notes-file-names (quote ("PDFNotes.org")))
 '(org-noter-notes-window-behavior (quote (scroll only-prev)))
 '(org-noter-separate-notes-from-heading nil)
 '(package-selected-packages
   (quote
    (move-dup auto-highlight-symbol switch-window ctrlf dashboard-project-status org-sidebar rg texfrag treemacs magit-popup elfeed markdown-toc grip-mode org toc-org org-super-agenda company-emoji emojify leetcode todoist hl-todo async magit dap-mode helm-lsp lsp-treemacs company-lsp lsp-ui lsp-mode diminish wakatime-mode magic-latex-buffer helm-projectile term-projectile pythonic markdownfmt ivy-rich counsel doom-modeline all-the-icons-ivy all-the-icons octicons unicode-fonts all-the-icons-dired spaceline-all-the-icons pomidor flycheck magit-org-todos skeletor ivy ivy-yasnippet evil keyfreq company-quickhelp company-box poly-R company evil-goggles smooth-scrolling forecast focus ess-R-data-view ess-view ess-smart-equals psession window-purpose eyebrowse winum dumb-jump pinyin-search imenu-anywhere imenu-list outline-toc markdown-mode poly-noweb polymode poly-org poly-markdown jupyter ein ess-smart-underscore esup vimrc-mode ido-springboard zenburn-theme youdao-dictionary yankpad yaml-mode yahoo-weather xah-math-input wttrin which-key websocket w3m volatile-highlights visual-regexp visible-mark vdiff use-package syndicate swiper sunshine sunrise-x-w32-addons sunrise-x-tree sunrise-x-tabs sunrise-x-popviewer sunrise-x-modeline sunrise-x-loop sunrise-x-checkpoints sunrise-x-buttons sqlup-mode springboard spacemacs-theme spaceline solarized-theme skewer-mode shell-pop ruby-mode restart-emacs register-list rainbow-delimiters python-x python-mode pydoc py-yapf py-autopep8 poly-slim plantuml-mode pkg-info paradox pandoc-mode package-build ox-twbs ox-bibtex-chinese orgalist org-trello org-toodledo org-ref org-pomodoro org-pdfview org-noter org-mind-map org-download org-bullets org-alert org-ac ob-mermaid ob-ipython oauth2 neotree monokai-theme md4rd mark-tools magithub magit-todos js-comint jedi interleave indium hungry-delete hlinum helpful helm-zhihu-daily helm-tail helm-swoop helm-pydoc helm-orgcard helm-github-stars helm-emms helm-describe-modes helm-descbinds helm-ag graphviz-dot-mode goto-line-preview google-translate gnuplot-mode gnuplot github-stars gh fancy-battery evil-visual-mark-mode evil-vimish-fold evil-tutor evil-surround evil-nerd-commenter evil-anzu ess emms-state embrace emacsist-view elpy elfeed-org elfeed-goodies ebib easy-kill diff-hl delight define-word deadgrep dashboard csv-mode company-math comment-dwim-2 color-theme-solarized cnfonts clipmon chinese-wbim chinese-pyim cdlatex cal-china-x bookmark+ benchmark-init autopair auctex anaconda-mode ahk-mode ace-window ace-pinyin ac-math)))
 '(paradox-column-width-download 7)
 '(paradox-column-width-package 25)
 '(paradox-column-width-version 15)
 '(paradox-display-download-count t)
 '(paradox-github-token t)
 '(pdf-annot-default-annotation-properties
   (quote
    ((t
      (label . "JL"))
     (text
      (color . "#ff0000")
      (icon . "Note"))
     (highlight
      (color . "yellow"))
     (underline
      (color . "blue"))
     (squiggly
      (color . "orange"))
     (strike-out
      (color . "red")))))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))



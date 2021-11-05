(defun init-git()

(setq magit-commit-show-diff nil);; 加快magit反应速度

;; ---------------- Git status and magit-repolist setup -----------------
(setq magit-repository-directories `((,(concat prepath "github_fork_repo/") . 1)
					   (,(concat prepath "Works/") . 3)
					   (,(concat prepath "Works/Learning/") . 3)
					   ))

(require 'magit-todos)
(require 'magit-repos)
(require 'magit-repos-fetch)  ;; 自己根据网上资料写的包

(defun magit-repolist-column-dirty (_id)
  (cond 
    ;((magit-untracked-files) "N")
        ((magit-unstaged-files)  "U")
        ((magit-staged-files)    "S")))

(setq magit-repolist-columns
      '(("Name"    28 magit-repolist-column-ident                  ())
        ("D"        2 magit-repolist-column-dirty                  ())
        ("L<U"      4 magit-repolist-column-unpulled-from-pushremote ())
        ("L>U"      3 magit-repolist-column-unpushed-to-pushremote   ())
        (" Version" 25 magit-repolist-column-version                ())
        ("Path"    99 magit-repolist-column-path                   ())
	))

(add-hook 'magit-repolist-mode-hook 'magit-repolist-fetch)

;; 增加了 magit-get-push-remote判断，防止在刚创建repo时出错
(add-hook 'magit-status-mode-hook
	  '(lambda ()
	     (if (magit-get-current-remote) 
	     (call-interactively 'magit-fetch-all-prune)
	     nil)))

(global-set-key (kbd "C-x l") 'magit-list-repositories)
(global-set-key (kbd "C-x g") 'magit-status)

;; ------------- Magit-todos ----------------
;; bug see https://github.com/alphapapa/magit-todos/issues/72
;; https://github.com/alphapapa/magit-todos/issues/29
(global-hl-todo-mode)
(magit-todos-mode)
(setq magit-todos-nice nil)
(setq magit-todos-scanner (quote magit-todos--scan-with-git-grep))

(setq magit-todos-ignore-case nil)
;;  '(magit-todos-ignored-keywords (quote ("NOTE"))) 这个设置在custom.el中，这里设置不起作用
; (setq magit-todos-ignored-keywords (quote ("NOTE" "???" "XXX")))
(setq magit-todos-keyword-suffix "")

;; ------------------------- Hacked ----------------------------------
(magit-todos-defscanner "git grep"
  :test (string-match "--perl-regexp" (shell-command-to-string "git grep --magit-todos-testing-git-grep"))
  :command (progn
  (setq-local default-process-coding-system '(utf-8 . utf-8)) ;; Hacked by Jin Lin
				(list "git" "--no-pager" "grep"
                 "--full-name" "--no-color" "-n"
                 (when depth
                   (list "--max-depth" depth))
                 (when magit-todos-ignore-case
                   "--ignore-case")
                 "--perl-regexp"
                 "-e" search-regexp-pcre
                 extra-args "--" directory
                 (when magit-todos-exclude-globs
                   (--map (concat ":!" it)
                          magit-todos-exclude-globs)))))


;; -------------- magithub ------------------
(use-package magithub
  :after magit
  :config
  (magithub-feature-autoinject t)
  (setq magithub-clone-default-directory (concat prepath "github_fork_repo"))) 
  
(setq magithub-preferred-remote-method (quote clone_url))

;; -------------- helm-github-stars --------------
(require 'helm-github-stars)
;; Setup your github username:
(setq helm-github-stars-username "jinlin82")

;; --------------- diff-hl-mode -----------------
(global-diff-hl-mode)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

(setq diff-auto-refine-mode t) 
(setq magit-diff-refine-hunk (quote all))
(setq diff-auto-refine t)

(require 'vdiff)
(define-key vdiff-mode-map (kbd "C-c") vdiff-mode-prefix-map)
(setq vdiff-auto-refine t) 
(setq vdiff-only-highlight-refinements nil)

;; --------------------- magit-stats config --------------------
(setq magit-status-show-hashes-in-headers t)

(setq magit-section-initial-visibility-alist
   (quote
    ((stashes . hide)
     (unpushed . show)
     (untracked . hide)
     (modules modules . show)
     (unpulled . show)
     )))

(setq magit-status-headers-hook
   (quote
    (magit-insert-error-header 
      magit-insert-diff-filter-header 
      magit-insert-repo-header 
      magit-insert-remote-header 
      magit-insert-head-branch-header 
      magit-insert-upstream-branch-header 
      magit-insert-push-branch-header 
      magit-insert-tags-header 
      magithub-maybe-report-offline-mode)))

(setq magit-status-sections-hook
   (quote
    (magit-insert-status-headers 
      magit-insert-merge-log 
      magit-insert-rebase-sequence 
      magit-insert-am-sequence 
      magit-insert-sequencer-sequence
      magit-todos--insert-todos 
      magit-insert-local-branches
      magit-insert-remote-branches
      magit-insert-branch-description
      magit-insert-bisect-output 
      magit-insert-bisect-rest 
      magit-insert-bisect-log 
      magit-insert-unstaged-changes 
      magit-insert-staged-changes 
      magit-insert-unpulled-from-upstream 
      magit-insert-unpulled-from-pushremote 
      magit-insert-unpushed-to-pushremote 
      magit-insert-unpushed-to-upstream-or-recent 
      magit-insert-stashes 
      magithub-issue--insert-pr-section 
      magithub-issue--insert-issue-section
      magit-insert-modules
      magit-insert-untracked-files
      magit-insert-tracked-files)))

(use-package flycheck
   :ensure t
   ;:init (global-flycheck-mode)
   )


;;;----------------------------- git-link browse remote ---------------------------------------------
(require 'git-link)
; (add-to-list 'git-link-remote-alist '("gitee" git-link-gitub))
; (add-to-list 'git-link-commit-remote-alist '("gitee" git-link-commit-github))

(setq git-link-open-in-browser t) 
(setq git-link-commit-remote-alist
   (quote
    (("git.sr.ht" git-link-commit-github)
     ("codeberg.org" git-link-commit-codeberg)
     ("github" git-link-commit-github)
     ("bitbucket" git-link-commit-bitbucket)
     ("gitorious" git-link-commit-gitorious)
     ("gitlab" git-link-commit-github)
     ("git\\.\\(sv\\|savannah\\)\\.gnu\\.org" git-link-commit-savannah)
     ("visualstudio\\|azure" git-link-commit-azure)
     ("sourcegraph" git-link-commit-sourcegraph)
     ("gitee" git-link-commit-github))))

 (setq git-link-remote-alist
   (quote
    (("git.sr.ht" git-link-sourcehut)
     ("codeberg.org" git-link-codeberg)
     ("github" git-link-github)
     ("bitbucket" git-link-bitbucket)
     ("gitorious" git-link-gitorious)
     ("gitlab" git-link-gitlab)
     ("git\\.\\(sv\\|savannah\\)\\.gnu\\.org" git-link-savannah)
     ("visualstudio\\|azure" git-link-azure)
     ("sourcegraph" git-link-sourcegraph)
     ("gitee" git-link-github))))
	 
(add-to-list 'git-link-homepage-remote-alist '("gitee" git-link-homepage-github))
(global-set-key (kbd "C-c g l") 'git-link)
	 
(define-key magit-status-mode-map (kbd "C-c b") 'magithub-browse)
(global-set-key (kbd "C-c g b") 'magithub-browse)

(defun gitee-browse ()
  (interactive)
(browse-url (magit-git-string "remote" "get-url" (if (magit-get-remote) (magit-get-remote) "Gitee")))
(message (concat (magit-get-remote) " Website Opened" ))
)

(define-key magit-status-mode-map (kbd "C-c t") 'gitee-browse)
(global-set-key (kbd "C-c g t") 'gitee-browse)

(defun magit-open-readme ()
  (interactive)
  (if (not (file-exists-p "README.MD")) (progn
					  (find-file-other-window "README.MD")
					  (insert "# Readme")
					  (save-buffer)
					  (message "README.MD Created and Opened" )
					  )
    (progn (find-file-other-window "README.MD")
	   (message "README.MD Opened" )
	   )
  )
)
(define-key magit-status-mode-map (kbd "C-c v") 'magit-open-readme)




;;;单独 gitee 项目中在 emacs中 COMMIT_EDITMSG 乱码，HACKed magit-commit-create 函数

(defun magit-commit-create (&optional args)
  "Create a new commit on `HEAD'.
With a prefix argument, amend to the commit at `HEAD' instead.
\n(git commit [--amend] ARGS)"
  (set-language-environment "UTF-8")    ;; HACKed by Jin Lin
  (interactive (if current-prefix-arg
                   (list (cons "--amend" (magit-commit-arguments)))
                 (list (magit-commit-arguments))))
  (when (member "--all" args)
    (setq this-command 'magit-commit-all))
  (when (setq args (magit-commit-assert args))
    (let ((default-directory (magit-toplevel)))
      (magit-run-git-with-editor "commit" args))))
  
	  
(add-hook 'with-editor-post-cancel-hook '(lambda () (set-language-environment "Chinese-GBK")))
(add-hook 'with-editor-post-finish-hook '(lambda () (set-language-environment "Chinese-GBK")))

;;; git-messenger
;; git-messenger.el 中 (setq-local default-process-coding-system '(utf-8 . utf-8)) ;; Hacked by Jin Lin
(require 'git-messenger) ;; You need not to load if you install with package.el
(global-set-key (kbd "C-x v p") 'git-messenger:popup-message)

(define-key git-messenger-map (kbd "m") 'git-messenger:copy-message)

(setq git-messenger:show-detail t)
(setq git-messenger:use-magit-popup t)

;; -------------------- HACK 修复commit message 中含有中文乱码-------------------
(defun git-messenger:execute-command (vcs args output)
  (cl-case vcs
    (git (progn
	(setq-local default-process-coding-system '(utf-8 . utf-8)) ;; Hacked by Jin Lin
	(apply 'process-file "git" nil output nil args)
	))
    (svn
     (let ((process-environment (cons "LANG=C" process-environment)))
       (apply 'process-file "svn" nil output nil args)))
    (hg
     (let ((process-environment (cons
                                 "HGPLAIN=1"
                                 (cons "LANG=utf-8" process-environment))))
       (apply 'process-file "hg" nil output nil args)))))

;; 注意 git-timemachine 存在中文乱码问题，该包比较有用，但存在大量的中文编码问题，直接对git-timemachine.el做了很多修改
(require 'git-timemachine)
(global-set-key (kbd "C-c t") 'git-timemachine) 
(define-key git-timemachine-mode-map (kbd "RET") 'git-timemachine--show-minibuffer-details-for-current)
(define-key git-timemachine-mode-map (kbd "SPC") 'git-timemachine-show-current-revision)
  
"Init Git"
(interactive)			
			)
		  

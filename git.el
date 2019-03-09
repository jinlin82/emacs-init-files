(defun init-git()

;; ---------------- Git status and magit-repolist setup -----------------
(setq magit-repository-directories (quote (("C:/github_fork_repo/" . 1)
					   ("C:/Works/" . 4)
					   )))

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
	     (if (magit-get-push-remote) 
	     (call-interactively 'magit-fetch-from-pushremote)
	     nil)))

(global-set-key (kbd "C-x l") 'magit-list-repositories)
(global-set-key (kbd "C-x g") 'magit-status)

;; ------------- Magit-todos ----------------
;; bug see https://github.com/alphapapa/magit-todos/issues/72
;; https://github.com/alphapapa/magit-todos/issues/29
(global-hl-todo-mode)
(setq magit-todos-nice nil)
(setq magit-todos-scanner (quote magit-todos--scan-with-git-grep))
(magit-todos-mode)

;; -------------- magithub ------------------
(use-package magithub
  :after magit
  :config
  (magithub-feature-autoinject t)
  (setq magithub-clone-default-directory "C:/github_fork_repo"))  
  
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
      magit-insert-bisect-output 
      magit-insert-bisect-rest 
      magit-insert-bisect-log 
      magit-insert-unstaged-changes 
      magit-insert-staged-changes 
      magit-todos--insert-todos 
      magit-insert-unpulled-from-upstream 
      magit-insert-unpulled-from-pushremote 
      magit-insert-unpushed-to-pushremote 
      magit-insert-unpushed-to-upstream-or-recent 
      magit-insert-stashes 
      magithub-issue--insert-pr-section 
      magithub-issue--insert-issue-section 
      magit-insert-untracked-files)))

"Init Git"
(interactive)			
			)
		  

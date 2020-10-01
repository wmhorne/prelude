;;; Dired
(use-package dired
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t)
  :hook ((dired-mode . dired-hide-details-mode)
         (dired-mode . hl-line-mode)))
(use-package dired-narrow
  :ensure t
  :after dired
  :config
  (setq dired-narrow-exit-when-one-left t)
  (setq dired-narrow-enable-blinking t)
  (setq dired-narrow-blink-time 0.3)
  :bind (:map dired-mode-map
              ("M-s n" . dired-narrow)))

(use-package image-dired
  :config
  (setq image-dired-external-viewer "xdg-open")
  (setq image-dired-thumb-size 80)
  (setq image-dired-thumb-margin 2)
  (setq image-dired-thumb-relief 0)
  (setq image-dired-thumbs-per-row 4)
  :bind (:map image-dired-thumbnail-mode-map
              ("<return>" . image-dired-thumbnail-display-external)))

;;; Org
(use-package org
  :config
  (setq org-directory "~/Dropbox/org")
  (setq org-default-notes-file "~/Dropbox/org/notes.org")
  (setq org-deadline-warning-days 7)
  (setq org-refile-targets
       '((org-agenda-files . (:maxlevel . 2))
         (nil . (:maxlevel . 2))))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "DOING" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-log-done 'time)
  (setq org-special-ctrl-a/e t)
  (setq org-special-ctrl-k nil)
  (setq org-completion-use-ido t)
  (setq org-hide-emphasis-markers t)
  (setq org-log-note-clock-out nil)
  (setq org-log-redeadline nil)
  (setq org-log-reschedule nil)
  (setq org-read-date-prefer-future 'time)
  (setq org-fontify-done-headline t)
  (setq org-enforce-todo-dependencies t)
  (setq org-enforce-todo-checkbox-dependencies t)
  (setq org-refile-use-outline-path 'file)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-use-cache nil)
  (setq org-clone-delete-id t)
  (setq org-agenda-custom-commands
   '(("h" "Home Projects" agenda ""
      ((org-agenda-overriding-header "Home Projects")
       (org-agenda-files
        '("~/Dropbox/org/Home.org"))
       (org-agenda-sorting-strategy
        '(tag-up))
       (org-agenda-span 'year)
       (org-deadline-warning-days 0)
       (org-agenda-show-all-dates nil)
       (org-agenda-prefix-format "    ")
       (org-agenda-tags-column 50)
       (org-agenda-start-day "2020-8-1"))
      ("~/Dropbox/org/Home.pdf"))
     ("S" "Scholastica"
      ((agenda ""
               ((org-agenda-overriding-header "Deadlines")
                (org-agenda-files
                 '("~/Dropbox/org/Scholastica.org"))
                (org-agenda-span 'day)))
       (tags "INBOX"
             ((org-agenda-overriding-header "Inbox")
              (org-agenda-files
               '("~/Dropbox/org/Scholastica.org"))))
       (tags "PROJ"
             ((org-agenda-overriding-header "Projects")
              (org-agenda-files
               '("~/Dropbox/org/Scholastica.org"))
              (org-agenda-dim-blocked-tasks nil)
              (org-agenda-todo-ignore-scheduled 'future)
              (org-agenda-sorting-strategy
               '(todo-state-down))))
       (tags-todo "-PROJ-WAITING"
                  ((org-agenda-overriding-header "Next Actions")
                   (org-agenda-files
                    '("~/Dropbox/org/Scholastica.org"))
                   (org-agenda-skip-function "org-agenda-skip-if 'deadline")
                   (org-agenda-sorting-strategy
                    '(priority-down todo-state-down)))))
      nil)))
  (setq org-agenda-files (quote ("~/Dropbox/org/")))
  :bind (("C-c l" . org-store-link)
         ("C-c I" . (lambda() (interactive)(find-file "~/Dropbox/org/Inbox.org")))
         ))

;;;;;; Org capture
(use-package org-capture
  :after org
  :config
  (setq org-capture-templates
        '(("t" "Todo Entry" entry
           (file "Inbox.org")
           "* TODO %?
:PROPERTIES:
:CREATED: %t
:END:")
          ("h" "Home Item" entry
           (file "Home.org")
           "* %^{prompt|DO|DO|BUY} %^{prompt} %^g 
SCHEDULED: %^t" :immediate-finish t)
          	 ("p" "Protocol" entry
	  (file "~/Dropbox/org/Inbox.org")
	  "* %^{Title}
:PROPERTIES:
:CREATED: %t
:END:
Source: %u, %c
#+BEGIN_QUOTE
%i
#+END_QUOTE


%?")
	 ("L" "Protocol Link" entry
	  (file "~/Dropbox/org/Inbox.org")
	  "* %? [[%:link][%:description]] 
:PROPERTIES:
:CREATED: %t
:END:")
          ("e" "Reply to an email" entry
           (file+headline "Inbox.org" "Email")
           "* TODO %:subject\n SCHEDULED: %t\n :PROPERTIES:\n :CONTEXT: %a\n :END:\n\n %i %?")
          ("s" "Scholastica")
          ("sm" "Scholastica markdown" entry
           (file "~/Dropbox/org/Scholastica.org")
           "* 
#+BEGIN_SRC markdown
%?
#+END_SRC")
          ("si" "Inbox item" entry
           (file "~/Dropbox/org/Scholastica.org")
           "* TODO ")
          ("sa" "Author edits" entry
           (file "~/Dropbox/org/Scholastica.org")
           "* TODO %^L %^{JOURNAL}p %^{ARTICLE-NUMBER}p
  :PROPERTIES:
  :CATEGORY: Author edits
  :END:
** TODO Changes
%?
** TODO [[https://docs.google.com/forms/d/e/1FAIpQLSdwMX4lkYJFg5iLnLwGG2kPUVLbbeBuWWUuWtcN-L-TSJKAYg/viewform][Typesetting feedback form]]")
          ("sd" "Documentation" entry
           (file "~/Dropbox/org/Scholastica.org")
           "* TODO %^{Todo}
:PROPERTIES:
:CATEGORY: Documentation
:END:
%a
%^{Notes}" :immediate-finish t)
	 ("st" "New Typesetting" entry
	  (file "~/Dropbox/org/Scholastica.org")
	  "* TODO [/] %^C %^{URL}p %^{DOCX}p %^{JOURNAL}p %^{ARTICLE-NUMBER}p
  DEADLINE: %^t
  :PROPERTIES:
  :CATEGORY: Typesetting
  :END:
#+BEGIN: clocktable :scope subtree :maxlevel 2
#+END:
** Metadata
*** TODO Title/abstract
*** TODO Authors
** Citations
*** TODO Import citations
*** TODO Verify citations
*** TODO Insert citations
** Attachments
*** TODO Upload images
*** TODO Reformat tables
*** TODO Reformat figures
*** TODO Add info (captions, notes)
*** TODO Insert attachments
** Body
*** TODO Formatting (Headers, italics, bold)
*** TODO Footnotes
*** TODO Math
** Completion
*** TODO Review/Proof
*** TODO Send Email
*** TODO Pain Points
*** TODO [[https://docs.google.com/forms/d/e/1FAIpQLSdwMX4lkYJFg5iLnLwGG2kPUVLbbeBuWWUuWtcN-L-TSJKAYg/viewform][Feedback form]]"
      :immediate-finish t)))
  (setq org-capture-templates-contexts
        '(("e" ((in-mode . "gnus-article-mode")
                (in-mode . "gnus-summary-mode")))))
    :bind ("C-c c" . org-capture))

;;; Org agenda
(use-package org-agenda
  :after org
  :config
  (setq org-agenda-confirm-kill t)
  (setq org-agenda-include-diary nil)
  (setq org-agenda-show-all-dates t)
  (setq org-agenda-show-outline-path nil)
  (setq org-agenda-skip-additional-timestamps-same-entry t)
  (setq org-agenda-skip-deadline-prewarning-if-scheduled t)
  (setq org-agenda-skip-scheduled-delay-if-deadline t)
  (setq org-agenda-skip-scheduled-if-deadline-is-shown t)
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-skip-timestamp-if-deadline-is-shown t)
  (setq org-agenda-skip-timestamp-if-done t)
  (setq org-agenda-search-headline-for-time nil)
  (setq org-agenda-start-on-weekday 1)  ; Monday
  (setq org-agenda-start-with-follow-mode nil)
  (setq org-agenda-timegrid-use-ampm nil)
  (setq org-agenda-use-time-grid t)
  (setq org-agenda-window-setup 'current-window)
  (setq org-agenda-todo-list-sublevels t)
  (setq org-agenda-show-future-repeats nil)
  (setq org-agenda-skip-deadline-if-done nil)
  :bind (("C-c a" . org-agenda)))

;;;;;;;; Org src
(use-package org-src
  :after org
  :config
  (setq org-src-window-setup 'current-window)
  (setq org-src-fontify-natively t)
  (setq org-src-preserve-indentation t)
  (setq org-src-tab-acts-natively t)
  (setq org-edit-src-content-indentation 0))

;;;;;;;; Org id
(use-package org-id
  :after org
  :commands (contrib/org-get-id
             contrib/org-id-headlines)
  :config
  (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
  (defun contrib/org-get-id (&optional pom create prefix)
    "Get the CUSTOM_ID property of the entry at point-or-marker
POM. If POM is nil, refer to the entry at point. If the entry
does not have an CUSTOM_ID, the function returns nil. However,
when CREATE is non nil, create a CUSTOM_ID if none is present
already. PREFIX will be passed through to `org-id-new'. In any
case, the CUSTOM_ID of the entry is returned."
    (interactive)
    (org-with-point-at pom
      (let ((id (org-entry-get nil "CUSTOM_ID")))
        (cond
         ((and id (stringp id) (string-match "\\S-" id))
          id)
         (create
          (setq id (org-id-new (concat prefix "h")))
          (org-entry-put pom "CUSTOM_ID" id)
          (org-id-add-location id (buffer-file-name (buffer-base-buffer)))
          id)))))

  (defun contrib/org-id-headlines ()
    "Add CUSTOM_ID properties to all headlines in the current
file which do not already have one."
    (interactive)
    (org-map-entries (lambda ()
                       (contrib/org-get-id (point) 'create)))))

;;;;;;;;;;;;; Org ref
(use-package org-ref
  :config
  (setq org-ref-bibliography-notes "~/Dropbox/org/Books.org")
  (setq org-ref-default-bibliography '("~/Documents/library.bib"))
  (setq org-ref-pdf-directory "~/Dropbox/pdfs/")
  (setq org-ref-default-bibliography (quote ("~/Documents/library.bib"))))

;;; Bibtex
(use-package bibtex
  :config
  (setq helm-bibtex-bibliography "~/Documents/library.bib")
  (setq helm-bibtex-notes-path "~/Dropbox/org/Books.org")
  (setq bibtex-completion-bibliography "~/Documents/library.bib")
  (setq bibtex-completion-notes-path "~/Dropbox/org/Books.org")
  (setq bibtex-autokey-name-case-convert-function (quote capitalize))
  (setq bibtex-autokey-titleword-case-convert-function (quote capitalize))
  (setq bibtex-autokey-titleword-length 0)
  (setq bibtex-autokey-titleword-separator "")
  (setq bibtex-autokey-titlewords 0)
  (setq bibtex-autokey-year-length 4)
  (setq bibtex-autokey-year-title-separator "")
  (setq bibtex-completion-browser-function (quote browse-url-default-browser))
  (setq bibtex-completion-find-additional-pdfs t)
  (setq bibtex-completion-format-citation-functions
   (quote
	((org-mode . org-ref-bibtex-completion-format-org)
	 (latex-mode . bibtex-completion-format-citation-cite)
	 (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
	 (default . bibtex-completion-format-citation-default)
	 (kotl-mode . bibtex-completion-format-citation-pandoc-citeproc))))
  (setq bibtex-completion-library-path "~/Dropbox/pdfs")
  (setq bibtex-completion-notes-path "~/Dropbox/org/Books.org")
  (setq bibtex-completion-notes-template-one-file
   "
* ${title}
  :PROPERTIES:
  :YEAR: ${year}
  :TITLE: ${title}
  :AUTHOR: ${author-or-editor}
  :CITEKEY: ${=key=}
  :END:

")
  :bind ("C-M--" . helm-bibtex)
  )

;;; Mail
;;;;;;; Gnus
(use-package gnus
  :config
  (setq gnus-select-method '(nnnil))
  (setq gnus-secondary-select-methods
        '((nnimap "gmail"
                  (nnimap-address "imap.gmail.com")
                  (nnimap-stream ssl)
                  (nnimap-authinfo-file "~/.authinfo.gpg"))))
  (setq gnus-gcc-mark-as-read t)
  (setq gnus-agent t)
  (setq gnus-use-scoring nil)
  (setq gnus-use-full-window nil)
  (setq gnus-novice-user nil)
  (setq gnus-check-new-newsgroups nil)
  (setq gnus-message-archive-group "[Gmail]/Sent Mail")
  (setq gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")
  :bind ("C-c G" . gnus)
  ("C-x m" . gnus-msg-mail)
  (:map gnus-article-mode-map
	("\C-c\C-f" . gnus-summary-mail-forward)))

(use-package gnus-agent
  :after gnus
  :config
  (setq gnus-agent-article-alist-save-format 1)  ; uncompressed
  (setq gnus-agent-cache t)
  (setq gnus-agent-confirmation-function 'y-or-n-p)
  (setq gnus-agent-consider-all-articles nil)
  (setq gnus-agent-directory "~/News/agent/")
  (setq gnus-agent-enable-expiration 'ENABLE)
  (setq gnus-agent-expire-all nil)
  (setq gnus-agent-expire-days 30)
  (setq gnus-agent-mark-unread-after-downloaded t)
  (setq gnus-agent-queue-mail t)
  (setq gnus-agent-synchronize-flags nil))

(use-package gnus-async
  :after gnus
  :config
  (setq gnus-asynchronous t)
  (setq gnus-use-article-prefetch 15))

(use-package gnus-group
  :after gnus
  :demand
  :config
  (setq gnus-level-subscribed 6)
  (setq gnus-level-unsubscribed 7)
  (setq gnus-level-zombie 8)
  (setq gnus-list-groups-with-ticked-articles t)
  (setq gnus-group-sort-function
        '((gnus-group-sort-by-unread)
          (gnus-group-sort-by-alphabet)
          (gnus-group-sort-by-rank)))
  (setq gnus-group-mode-line-format "%%b")
  :hook
  (gnus-select-group-hook . gnus-group-set-timestamp)
  :bind (:map gnus-agent-group-mode-map
              ("M-n" . gnus-topic-goto-next-topic)
              ("M-p" . gnus-topic-goto-previous-topic)))

(use-package gnus-sum
  :after (gnus gnus-group)
  :demand
  :config
  (setq gnus-auto-select-first nil)
  (setq gnus-summary-ignore-duplicates t)
  (setq gnus-suppress-duplicates t)
  (setq gnus-summary-goto-unread nil)
  (setq gnus-summary-make-false-root 'adopt)
  (setq gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references)
  (setq gnus-thread-sort-functions
        '((not gnus-thread-sort-by-number)
          (not gnus-thread-sort-by-date)))
  (setq gnus-subthread-sort-functions
        'gnus-thread-sort-by-date)
  (setq gnus-thread-hide-subtree nil)
  (setq gnus-thread-ignore-subject t)
  (setq gnus-user-date-format-alist
        '(((gnus-seconds-today) . "Today at %R")
          ((+ 86400 (gnus-seconds-today)) . "Yesterday, %R")
          (t . "%Y-%m-%d %R")))
  (setq gnus-summary-line-format "%U%R%z %-16,16&user-date;  %4L:%-30,30f  %B%S\n")
  (setq gnus-summary-mode-line-format "%p (%U)")
  (setq gnus-sum-thread-tree-false-root "")
  (setq gnus-sum-thread-tree-indent " ")
  (setq gnus-group-line-format "%M%S%5y/%-5t: %uG %D\n")
  (defun gnus-user-format-function-G (arg)
    (let ((mapped-name (assoc gnus-tmp-group group-name-map)))
      (if (null mapped-name)
          gnus-tmp-group
        (cdr mapped-name))))
  (setq group-name-map '(("nnimap+gmail:INBOX" . "Inbox")
                       ("nnimap+gmail:[Gmail]/All Mail" . "All Mail")
                       ("nnimap+gmail:[Gmail]/Sent Mail" . "Sent")
                       ("nnimap+gmail:[Gmail]/Spam" . "Spam")
                       ("nnimap+gmail:[Gmail]/Trash" . "Trash")
                       ("nnimap+gmail:[Gmail]/Drafts" . "Drafts")
                       ))
  (setq gnus-sum-thread-tree-leaf-with-other "├─➤ ")
  (setq gnus-sum-thread-tree-root "")
  (setq gnus-sum-thread-tree-single-leaf "└─➤ ")
  (setq gnus-sum-thread-tree-vertical "│")
  :hook
  (gnus-summary-exit-hook . gnus-topic-sort-groups-by-alphabet)
  (gnus-summary-exit-hook . gnus-group-sort-groups-by-rank))

(use-package smtpmail
  :init
  (setq smtpmail-default-smtp-server "smtp.gmail.com")
  :config
  (setq smtpmail-smtp-server "smtp.gmail.com")
  (setq smtpmail-smtp-service 587)
  (setq smtpmail-queue-mail nil))

(use-package smtpmail-async
  :after smtpmail
  :config
  (setq send-mail-function 'smtpmail-send-it)
  (setq message-send-mail-function 'smtpmail-send-it))

(use-package auth-source
  :config
  (setq auth-sources '("~/.authinfo.gpg" "~/.authinfo"))
  (setq user-full-name "William Horne")
  (setq user-mail-address "will.m.horne@gmail.com"))

(use-package message
  :config
  (setq mail-user-agent 'message-user-agent)
  (setq message-mail-user-agent nil)    ; default is `gnus'
  (setq message-forward-as-mime nil)
  (setq message-forward-show-mml nil)
  (setq message-forward-included-headers "^Date\\|^From\\|^To\\|^Subject:\\|^Newsgroups")
  (setq message-kill-buffer-on-exit nil)
  (setq message-wide-reply-confirm-recipients t)
  (setq message-interactive nil)
  (setq message-make-forward-subject-function (quote message-forward-subject-fwd))
  (setq message-mode-hook (quote (turn-off-auto-fill)))
  (setq message-send-hook (quote (ispell-message))))

(use-package nnmail
  :config
  (setq nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")
  (setq nnmail-expiry-wait 'immediate))

;;; Function keys
(global-set-key [f5] 'org-capture)
(global-set-key [f6] 'org-refile)
(global-set-key [f7] 'helm-org-rifle)
(global-set-key [f8] 'org-web-tools-insert-link-for-url)



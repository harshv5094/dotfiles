(setq doom-theme 'doom-gruvbox)

(map! :leader
      (:prefix ("=" . "open file")
       :desc "Edit agenda file"      "a" #'(lambda () (interactive) (find-file "~/org/agenda.org"))
       :desc "Edit doom config.org"  "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.org"))
       :desc "Edit doom config.el"   "e" #'(lambda () (interactive) (find-file "~/.config/doom/config.el"))
       :desc "Edit doom init.el"     "i" #'(lambda () (interactive) (find-file "~/.config/doom/init.el"))
       :desc "Edit doom packages.el" "p" #'(lambda () (interactive) (find-file "~/.config/doom/packages.el"))))

; Setting Basic Font Family and Font Size
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font Mono" :size 15)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 20))

; Basic font style
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

; This are custom font faces for text
(custom-set-faces!
  '(font-lock-comment-face :slant italic))
  ;'(font-lock-keyword-face :slant italic))

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(setq doom-modeline-height 30                    ;; Sets modeline height
      doom-modeline-bar-width 5                  ;; sets right bar width
      doom-modeline-buffer-file-name-style 'auto ;; auto setup doom modeline filename
      doom-modeline-persp-name t                 ;; adds perspective name to modeline
      doom-modeline-persp-icon t)                ;; adds folder icon next to persp name

; NOTE setting relative line number
(setq display-line-numbers-type 'relative)

(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "FiraCode Nerd Font Mono"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.7))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.2)))))

(xterm-mouse-mode 1)

(after! org
  (setq org-agenda-files '("~/org/agenda.org")))

; NOTE Custom function to change header size
(custom-theme-set-faces! nil
'(org-level-8 :inherit outline-3 :height 1.0)
'(org-level-7 :inherit outline-3 :height 1.0)
'(org-level-6 :inherit outline-3 :height 1.1)
'(org-level-5 :inherit outline-3 :height 1.2)
'(org-level-4 :inherit outline-3 :height 1.3)
'(org-level-3 :inherit outline-3 :height 1.4)
'(org-level-2 :inherit outline-2 :height 1.5)
'(org-level-1 :inherit outline-1 :height 1.6)
'(org-document-title  :height 1.8 :bold t :underline nil))

; NOTE Default Org Directory
(setq org-directory "~/org/")
; NOTE Default Note File
(setq org-default-notes-file (concat org-directory "/notes.org"))

; NOTE Setting up org journal directory
(setq org-journal-dir "~/org/journal/"
      org-journal-date-prefix "* "
      org-journal-time-prefix "** "
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org")

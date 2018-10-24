(use-package org
  :mode (("\\.org\\'" . org-mode)
         ("\\.org.txt\\'" . org-mode))
  :config
  (setq org-image-actual-width nil)
  (setq org-log-done t)
  (define-key global-map "\C-c l" 'org-store-link)
  (define-key global-map "\C-c a" 'org-agenda)
  (add-hook 'org-mode-hook
            (lambda () (setq show-trailing-whitespace f)))
  (add-hook 'org-mode-hook 'flyspell-mode)
  (org-babel-do-load-languages 'org-babel-load-languages '((js . t)))
  (org-babel-do-load-languages 'org-babel-load-languages '((python . t)))
  (org-babel-do-load-languages 'org-babel-load-languages '((sql . t))))

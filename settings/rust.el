(use-package rust-mode
  :mode ("\\.rs\\'" . rust-mode))

(use-package racer
  :init
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode))

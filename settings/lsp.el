(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-l")
  (setq lsp-prefer-flymake nil)
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-headerline-breadcrumb-enable nil)

  :hook
  ((js2-mode . lsp-deferred)
    (web-mode . lsp-deferred)
    (python-mode . lsp-deferred)
    (haskell-mode . lsp-deferred)
    (sql-mode . lsp-deferred))
  :commands lsp)

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs)
(use-package lsp-haskell)


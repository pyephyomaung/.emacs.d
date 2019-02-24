;;; package --- Emacs configurations
;;; Commentary:

;;; Code:


(defun umbra () "Umbra." (propertize "u" 'face '(:foreground "#178ccb" :bold t)))
(defun exa () "Exa." (propertize "e" 'face '(:foreground "#f48024" :bold t)))
(defun ova () "Ova." (propertize "o" 'face '(:foreground "#90bd31" :bold t)))
(defun hydra-invoker-format (first second third name &optional is-last)
  "Format NAME spell using FIRST, SECOND, THIRD."
  (format (if is-last "%s%s%s %s" "%s%s%s %-8s") (funcall first) (funcall second) (funcall third) name))

(use-package hydra
  :init
  (setq hydra-is-helpful t))

(defun smart-open-line ()
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(defhydra hydra-invoker (:pre (progn
                                (set-cursor-color "#40e0d0")
                                (setq-default cursor-type 'box))
                          :post (progn
                                (set-cursor-color "white")
                                (setq-default cursor-type '(bar . 3)))
                          :hint nil)
  "
?u u u? ?u e e? ?u o u? ?e e e? ?o o o? ?o u u? ?o e e?
?u u e? ?u e u? ?u o e? ?e e u? ?o o u? ?o u e? ?o e u?
?u u o? ?u e o? ?u o o? ?e e o? ?o o e? ?o u o? ?o e o?
"
  ;; char
  ("n" forward-char)
  ("h" backward-char)
  ("t" next-line)
  ("c" previous-line)
  ("g" delete-backward-char)
  ("r" delete-char)
  ;; word
  ("M-n" forward-word)
  ("M-h" backward-word)
  ("M-g" backward-kill-word)
  ("M-r" kill-word)
  ;; line
  ("l" smart-open-line)
  ("M-l" smart-open-line-above)
  ("M-c" (previous-line 10))
  ("M-t" (next-line 10))
  ;; forward
  ("s" end-of-line)
  ("d" beginning-of-line)
  ;; mark
  ("m" set-mark-command)
  ;; expand
  ("x" er/expand-region)
  ("X" er/contract-region)
  ;; cut copy paste
  ("q" kill-region)
  ("j" kill-ring-save)
  ("z" undo)
  ("k" yank)
  ;; sexp
  ("x" er/expand-region)
  ("X" er/contract-region)
  ;; invoke
  ;; umbra
  ("u u u" save-buffer (hydra-invoker-format 'umbra 'umbra 'umbra "save"))
	("u u e" swiper (hydra-invoker-format 'umbra 'umbra 'exa "swiper") :exit 1)
  ("u u o" avy-goto-char-2 (hydra-invoker-format 'umbra 'umbra 'ova "avy"))
 	("u e e" ivy-yasnippet (hydra-invoker-format 'umbra 'exa 'exa "yas") :exit 1)
	("u e u" counsel-yank-pop (hydra-invoker-format 'umbra 'exa 'umbra "yank"))
  ("u e o" hydra-dumb-jump/body (hydra-invoker-format 'umbra 'exa 'ova "dj") :exit 1)
	("u o u" goto-line (hydra-invoker-format 'umbra 'exa 'ova "line"))
	("u o e" hydra-move-text/body (hydra-invoker-format 'umbra 'ova 'exa "move") :exit 1)
  ("u o o" hydra-unicode/body (hydra-invoker-format 'umbra 'ova 'ova "π") :exit 1)
  ;; exa
	("e e e" counsel-ag (hydra-invoker-format 'exa 'exa 'exa "ag") :exit t)
	("e e u" query-replace (hydra-invoker-format 'exa 'exa 'umbra "replace") :exit t)
	("e e o" hydra-rectangle/body (hydra-invoker-format 'exa 'exa 'ova "▩") :exit t)
	("e u e" nil)
	("e u u" nil)
	("e u o" nil)
	("e o e" nil)
	("e o u" nil)
  ("e o o" nil)
  ;; ova
  ("o o o" switch-to-buffer (hydra-invoker-format 'ova 'ova 'ova "buf"))
  ("o o u" next-buffer (hydra-invoker-format 'ova 'ova 'umbra "<-"))
  ("o o e" previous-buffer (hydra-invoker-format 'ova 'ova 'exa "->"))
  ("o u u" ibuffer (hydra-invoker-format 'ova 'umbra 'umbra "ibuf"))
 	("o u e" kill-buffer (hydra-invoker-format 'ova 'umbra 'exa "close"))
	("o u o" nil (hydra-invoker-format 'ova 'umbra 'ova ""))
  ("o e e" magit-status (hydra-invoker-format 'ova 'exa 'exa "git" t) :exit t)
  ("o e u" counsel-projectile-find-file (hydra-invoker-format 'ova 'exa 'umbra "popen" t))
  ("o e o" find-file (hydra-invoker-format 'ova 'exa 'ova "open" t))
  ("SPC" nil))

(defhydra hydra-rectangle (:body-pre (rectangle-mark-mode 1)
                           :color pink
                           :post (deactivate-mark))
  "
  ^_c_^     _d_elete    _s_tring
_h_   _n_   _o_k        _y_ank
  ^_t_^     _j_new-copy _r_eset
^^^^        _e_xchange  _u_ndo
^^^^        ^ ^         _p_aste
"
  ("n" rectangle-forward-char nil)
  ("h" rectangle-backward-char nil)
  ("t" rectangle-next-line nil)
  ("c" rectangle-previous-line nil)
  ("e" hydra-ex-point-mark nil)
  ("j" copy-rectangle-as-kill nil)
  ("d" delete-rectangle nil)
  ("r" (if (region-active-p)
         (deactivate-mark)
         (rectangle-mark-mode 1)) nil)
  ("y" yank-rectangle nil)
  ("u" undo nil)
  ("s" string-rectangle nil)
  ("p" kill-rectangle nil)
  ("o" nil nil))

(defhydra hydra-string-inflection (global-map "C-c u")
  "String inflection"
  ("_" (apply-function-to-region 'string-inflection-underscore-function) "underscore")
  ("-" (apply-function-to-region 'string-inflection-kebab-case-function) "kebab")
  ("u" (apply-function-to-region 'string-inflection-upcase-function) "uppercase")
  ("c" (apply-function-to-region 'string-inflection-lower-camelcase-function) "camel")
  ("C" (apply-function-to-region 'string-inflection-camelcase-function) "Camel"))

(defhydra hydra-dumb-jump ()
  "djump"
  ("u" dumb-jump-go "Jump" :color blue)
  ("e" dumb-jump-back "Back" :color pink))

(defhydra hydra-move-text ()
  "Move text"
  ("c" move-text-up "up")
  ("t" move-text-down "down"))


(setq counsel-projectile-find-file-action
  '(1
     ("o" counsel-projectile-find-file-action
       "current window")
     ("e" counsel-projectile-action-other-window
       "other window")
     ("u" (lambda (current-file) (interactive) (counsel-find-file nil))
       "find file manually")))

(defhydra hydra-transpose (:color red)
  "Transpose"
  ("c" transpose-chars "characters")
  ("w" transpose-words "words")
  ("o" org-transpose-words "Org mode words")
  ("l" transpose-lines "lines")
  ("s" transpose-sentences "sentences")
  ("e" org-transpose-elements "Org mode elements")
  ("p" transpose-paragraphs "paragraphs")
  ("t" org-table-transpose-table-at-point "Org mode table")
  ("q" nil "cancel" :color blue))

(defun insert-unicode (unicode-name)
  "Same as C-x 8 enter UNICODE-NAME."
  (insert-char (gethash unicode-name (ucs-names))))

(defhydra hydra-unicode (:hint nil)
  "
_a_ →  _c_ ✓  _l_ 𝛌  _N_ ♫
_e_ €  _o_ °  _i_ ‽  _s_ ★
_f_ ♀  _p_ π  _m_ µ  _S_ ∑
_F_ ♂  ^ ^    _n_ ❄  _w_ ♥
"
  ("c" (insert-unicode "CHECK MARK"))
  ("e" (insert-unicode "EURO SIGN"))
  ("F" (insert-unicode "MALE SIGN"))
  ("f" (insert-unicode "FEMALE SIGN"))
  ("i" (insert-unicode "INTERROBANG"))
  ("l" (insert-unicode "MATHEMATICAL BOLD SMALL LAMDA"))
  ("o" (insert-unicode "DEGREE SIGN"))
  ("a" (insert-unicode "RIGHTWARDS ARROW"))
  ("m" (insert-unicode "MICRO SIGN"))
  ("n" (insert-unicode "SNOWFLAKE"))
  ("N" (insert-unicode "BEAMED EIGHTH NOTES"))
  ("p" (insert-unicode "GREEK SMALL LETTER PI"))
  ("s" (insert-unicode "BLACK STAR"))
  ("S" (insert-unicode "N-ARY SUMMATION"))
  ("w" (insert-unicode "BLACK HEART SUIT")))

(global-set-key (kbd "<f8>") 'hydra-invoker/body)
(global-set-key (kbd "M-SPC") 'hydra-invoker/body)
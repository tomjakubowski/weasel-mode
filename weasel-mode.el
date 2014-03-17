;;; Commentary:
;; Provides convenience functions for creating a Weasel ClojureScript
;; REPL in CIDER.

;;; Code:

(require 'cider)

(defvar weasel-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c M-w p") 'weasel-piggieback-repl)
    (define-key map (kbd "C-c M-w k") 'weasel-kill-piggieback-repl)
    map))

(defconst weasel--expr-start-repl
  (prin1-to-string '(do (require (quote weasel.repl.websocket))
                        (cemerick.piggieback/cljs-repl
                         :repl-env (weasel.repl.websocket/repl-env))) t))

(defun weasel-piggieback-repl ()
  "Piggiebacks a Weasel REPL onto the current CIDER REPL."
  (interactive)
  (message "Starting Weasel REPL environment...")
  (cider-tooling-eval
   weasel--expr-start-repl
   (cider-interactive-eval-handler (current-buffer))))

(defun weasel-kill-piggieback-repl ()
  "Quits the piggiebacked Weasel REPL in the current CIDER REPL."
  (interactive)
  (cider-tooling-eval
   ":cljs/quit"
   (cider-interactive-eval-handler (current-buffer))))

;;;###autoload
(define-minor-mode weasel-mode
  "Convenience functions for using Weasel with CIDER."
  :keymap weasel-mode-map)

(provide 'weasel-mode)

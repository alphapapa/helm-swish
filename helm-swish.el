;; TODO: Maybe not use this name, because there's this:
;; http://kitchingroup.cheme.cmu.edu/blog/2015/06/25/Integrating-swish-e-and-Emacs/
;;
;; helm-swoosh?  helm-swash?  helm-helm?  (LOL, I ought to come up
;; with something to make for that name, though) helm-zoom?
;; helm-surf?  Or maybe I could just add this to Helm itself, or to
;; helm-swoop.

;;; Code:

;;;; Requirements

(require 'helm)

;;;; Commands

;;;###autoload
(defun helm-swish ()
  (interactive)
  (helm :sources (helm-make-source
                     (buffer-name (current-buffer)) 'helm-source-swish
                   :action (helm-make-actions
                            "Go to line" #'helm-swish-goto-line)
                   :get-line #'helm-swish-get-line)
        :input (thing-at-point 'symbol)))

;;;; Functions

(defun helm-swish-get-line (beg end)
  (let ((line (buffer-substring beg end)))
    (add-text-properties 0 (length line)
                         (list :line-begin beg)
                         line)
    line))

(defun helm-swish-goto-line (&rest args)
  (goto-char (get-text-property 0 :line-begin (helm-get-selection nil 'withprop))))

(defun helm-swish-init ()
  (helm-init-candidates-in-buffer 'global
    (with-helm-current-buffer
      (buffer-string))))

;;;; Classes

(defclass helm-source-swish (helm-source-in-buffer)
  ((init :initform #'helm-swish-init)
   (get-line :initform #'buffer-substring)
   (allow-dups :initform t)
   (follow :initform 1)
   (nomark :initform t)
   (requires-pattern :initform 1)))

;;;; Footer

(provide 'helm-swish)

;;; packages.el --- loki-org layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2022 Sylvain Benner & Contributors
;;
;; Author: Hello <hello@hello-desktop>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `loki-org-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `loki-org/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `loki-org/pre-init-PACKAGE' and/or
;;   `loki-org/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst loki-org-packages
  '(
    (org :location elpa :min-version "9.5")
    (org-agenda :location built-in)
    )
  "The list of Lisp packages required by the loki-org layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun loki-org/post-init-org ()
  (use-package org
    :defer (spacemacs/defer)
    :config
    (progn
      (setq org-confirm-babel-evaluate nil)
      (setq org-superstar-headline-bullets-list '(?■ ?◆ ?▲ ?▶))

      ;; 开启子任务进度依赖
      ;; 1. 当任务还有子任务未完成时，阻止任务从未完成状态到完成状态的改变；
      ;; 2. 对基于 headline 的任务而言，若其上一级任务设置了 ":ORDERED:" 属性
      ;;    则在其前面的同级任务完成前，无法被设置为完成状态
      (setq org-enforce-todo-dependencies t)

      ;; C-c C-t 触发状态切换时，可以快速切换
      (setq org-use-fast-todo-selection t)

      ;; 触发添加注释的方式：
      ;; DONE(d@)    ; 进入时添加笔记
      ;; DONE(d/!)   ; 离开时添加变更信息
      ;; DONE(d@/!)  ; 进入时添加笔记，离开时添加变更信息
      (setq org-todo-keywords
            '((sequence "TODO(t)" "PENDING(p@)" "|" "DONE(d)" "ABORT(a@)")
              ))

      (setq org-todo-keyword-faces
            '(
              ("PENDING" . (:background "DarkYellow" :foreground "white" :weight blod))
              ("ABORT"   . (:background "gray" :foreground "blue"))
              ))

      )))

(defun loki-org/post-init-org-agenda ()
  (use-package org-agenda
    :defer (spacemacs/defer)
    :config
    (progn
      ;; 添加 `org-agenda' 的自定义命令
      (setq org-agenda-custom-commands
            '(
              ("w" . "任务安排")
              ("wa" "重要且紧急的任务" tags-todo "+PRIORTY=\"A\"")
              ("wb" "重要且不紧急的任务" tags-todo "-weekly-monthly-daily+PRIORTY=\"B\"")
              ("wc" "不重要且紧急的任务" tags-todo "+PRIORTY=\"C\"")
              ("W" "Weekly Review"
               ((stuck "") ;; review stuck projects as designated by org-stuck-projects
                (tags-todo "daily")
                (tags-todo "weekly")
                (tags-todo "project")
                (tags-todo "task")
                ))
              ))

      ;; 添加每次打开时可以添加的任务类型
      ;; (setq org-capture-templates)

      )))

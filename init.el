(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(set-face-attribute 'default nil :font "0xProto Nerd Font" :height 120)

(load-theme 'tango-dark)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Khởi tạo packages  
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Cài đặt `use-package` nếu chưa có
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Bật `use-package` cho tất cả package
(require 'use-package)
(setq use-package-always-ensure t)

(use-package command-log-mode)

(use-package ivy
  :ensure t
  :demand t
  :init
  (ivy-mode 1)
  :bind (("C-s" . swiper)  ;; Tìm kiếm nhanh trong buffer
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)))

(use-package counsel
  :ensure t
  :after ivy
  :config
  (counsel-mode 1)  ;; Thay thế các lệnh mặc định bằng phiên bản mở rộng
  :bind (("M-x" . counsel-M-x)  ;; Tìm lệnh nhanh
         ("C-x C-f" . counsel-find-file)  ;; Tìm file tốt hơn
         ("C-x b" . counsel-switch-buffer)  ;; Chuyển buffer nhanh
         ("M-y" . counsel-yank-pop)  ;; Dán từ kill-ring
         ("C-c r" . counsel-rg)  ;; Tìm kiếm bằng ripgrep
         ("C-c g" . counsel-git)))  ;; Tìm file trong repo git

;; Thanh trạng thái xịn và đẹp hơn
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(counsel swiper cmake-mode xwwp-follow-link-ivy use-package ivy gnu-elpa-keyring-update doom-modeline command-log-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq user-full-name       "Dinh Thien Menh"
      user-real-login-name "Dinh Thien Menh"
      user-login-name      "menhythien"
      user-mail-address    "dinhthienmenh1505@gmail.com")

(setq default-frame-alist '((undecorated . t))) ;; Bỏ title bar
(setq inhibit-startup-message t) ;; Bỏ startup message 
(setq x-stretch-cursor t) ;; Con trỏ văn bản khớp với ký tự lớn

(set-frame-parameter nil 'alpha '(95 . 95))
(add-to-list 'default-frame-alist '(alpha . (95 . 95)))

;; Theo dõi pin laptop
(let ((battery-str (battery)))
  (unless (or (equal "Battery status not available" battery-str)
              (string-match-p (regexp-quote "N/A") battery-str))
    (display-battery-mode 1)))

(scroll-bar-mode -1)        ; Tắt scrollbar 
(tool-bar-mode -1)          ; Tắt toolbar
(tooltip-mode -1)           ; Tắt tooltips
(set-fringe-mode 10)        ; Thêm khoảng trống 2 cạnh màn hình 

(menu-bar-mode -1)            ; Tắt menu bar

(setq visible-bell t) ;; Bật hiệu ứng bell

(set-face-attribute 'default nil :font "0xProto Nerd Font" :height 120)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ;; Đặt nút ESC làm nút hủy lệnh

;; Hiện số dòng
(column-number-mode)
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; Tắt số dòng trong org mode cho đỡ rối
(dolist (mode '(org-mode-hook
		term-mode-hook
		vterm-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq display-line-numbers-type 'relative)

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

;; Chế độ lưu lại các lệnh đã thực hiện 
(use-package command-log-mode)

(use-package ivy
  :ensure t
  :demand t
  :init
  (ivy-mode 1)
  :bind (("C-s" . swiper)  ;; Tìm kiếm nhanh trong buffer
         :map ivy-minibuffer-map
         ("TAB" . ivy-partial-or-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Bổ trợ cho ivy 
(use-package counsel
  :ensure t
  :after ivy
  :config
  (setq ivy-initial-inputs-alist nil) ;; Không bắt đầu tìm kiếm bằng ^
  (counsel-mode 1)  ;; Thay thế các lệnh mặc định bằng phiên bản mở rộng
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)  ;; Tìm file tốt hơn
         ("C-x b" . counsel-switch-buffer)  ;; Chuyển buffer nhanh
         ("M-y" . counsel-yank-pop)  ;; Dán từ kill-ring
         ("C-c r" . counsel-rg)  ;; Tìm kiếm bằng ripgrep
         ("C-c g" . counsel-git) ;; Tìm file trong repo git
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill)))  

;; Thanh trạng thái xịn và đẹp hơn
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; Các theme của doom
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-dracula 1))

;; Tô màu dấu ngoặc
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))  ;; Tự động bật trong các buffer lập trình

;; Hiển thị thông tin lệnh
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; Tìm kiếm ngay trong emacs
(use-package engine-mode
  :config
  (engine/set-keymap-prefix (kbd "C-c s"))
  (setq browse-url-browser-function 'browse-url-default-browser)

  (defengine github
    "https://github.com/search?ref=simplesearch&q=%s"
    :keybinding "1")

  (defengine vocabulary
    "https://www.vocabulary.com/dictionary/%s"
    :keybinding "t")

  (defengine translate
    "https://translate.google.com/?hl=vi&sl=en&tl=vi&text=%s&op=translate"
    :keybinding "T")

  (defengine youtube
    "http://www.youtube.com/results?aq=f&oq=&search_query=%s"
    :keybinding "y")

  (defengine google
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
    :keybinding "g")

  (engine-mode 1))

;; Làm việc với git
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status))  ;; Mở Magit nhanh bằng C-x g
  :config
  (setq magit-auto-revert-mode nil) ;; Không tự động refresh buffer
  (setq magit-diff-options '("-b")) ;; Bỏ qua khoảng trắng khi diff
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)) ;; Giữ Magit trong một cửa sổ

;; Cây thư mục
(use-package treemacs
  :ensure t
  :defer t
  :init
  (global-set-key (kbd "C-x t t") 'treemacs)  ;; Mở Treemacs bằng C-x t t
  (setq treemacs-width 30)  ;; Đặt chiều rộng sidebar
  (setq treemacs-follow-mode t)  ;; Theo dõi file đang mở
  (setq treemacs-git-mode 'extended))  ;; Hiển thị trạng thái Git

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "dccf4a8f1aaf5f24d2ab63af1aa75fd9d535c83377f8e26380162e888be0c6a9" default))
 '(ispell-dictionary nil)
 '(package-selected-packages
   '(treemacs wallpaper ibus magit engine-mode doom-themes ivy-rich which-key rainbow-delimiters vterm counsel swiper cmake-mode xwwp-follow-link-ivy use-package ivy gnu-elpa-keyring-update doom-modeline command-log-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

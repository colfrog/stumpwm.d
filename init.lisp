;; Required imports
(ql:quickload "clx")
(ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

;; Swank
;; *prefix-key* ; swank will kick this off
(load ".emacs.d/elpa/slime-20231112.2019/swank-loader.lisp")
(swank-loader:init)
(defcommand swank () ()
    (swank:create-server :port 4005
                       :style swank:*communication-style*
                       :dont-close t)
  (echo-string (current-screen) 
	       "Starting swank. M-x slime-connect RET RET, then (in-package stumpwm)."))

;; Fonts
(ql:quickload "clx-truetype")
(load-module "ttf-fonts")
(xft:cache-fonts)
(set-font (make-instance 'xft:font :family "Hack" :subfamily "Regular" :size 8 :antialias t))

;; Prefix
(set-prefix-key (kbd "s-t"))

;; Keyboard layout
(defvar *keyboard-layouts* '("ca" "us"))
(defcommand switch-layout () ()
  (let ((layout (car *keyboard-layouts*)))
    (setf *keyboard-layouts* (append (cdr *keyboard-layouts*) (list layout)))
    (run-shell-command (concatenate 'string "setxkbmap " layout))
    (echo-string (current-screen) (concatenate 'string "Layout set to " layout "."))))
(define-key *top-map* (kbd "s-SPC") "switch-layout")

;; Terminal
(define-key *root-map* (kbd "c") "exec alacritty")

;; Groups
(define-key *top-map* (kbd "s-Right") "gnext")
(define-key *top-map* (kbd "s-Left") "gprev")

;; sndio control
(load-module "stumpwm-sndioctl")
(define-key *top-map* (kbd "XF86AudioMute") "toggle-mute")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "volume-down")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "volume-up")

;; Mouse
(run-shell-command "xsetroot -cursor_name left_ptr")
(setf *mouse-focus-policy* :sloppy)

;; Compositing
(run-shell-command "picom --vsync")

;; Colours
(set-bg-color "#2e0063")
(set-fg-color "#fff04c")
(set-border-color "#2e0063")
(setf *mode-line-background-color* "#2e0063")
(setf *mode-line-foreground-color* "#fff04c")

(toggle-mode-line (current-screen) (current-head))

;; Message window
(setf *message-window-gravity* :center)

;; Modeline
(defcommand toggle-modeline () ()
  (toggle-mode-line (current-screen) (current-head)))
(define-key *root-map* (kbd "C-m") "toggle-modeline")

(load-module "battery-portable")
(setf *screen-mode-line-format* (list "[^B%n^b] %W^>%B %d"))
(setf *window-format* "%m%n%s%c")
(setf *time-modeline-string* "%a %b %e %k:%M")
(setf *mode-line-timeout* 1)
(enable-mode-line (current-screen) (current-head) t)

;; Gaps
(load-module "swm-gaps")
(setf swm-gaps:*inner-gaps-size* 4)
(setf swm-gaps:*outer-gaps-size* 8)
(setf swm-gaps:*head-gaps-size* 0)
(swm-gaps:toggle-gaps-on)

(define-key *root-map* (kbd "C-.") "toggle-gaps")

;; Wallpaper
(run-shell-command "/home/laurent/.fehbg")

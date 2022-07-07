;; https://github.com/CuBeRJAN/guix-config

(use-modules (gnu)
             (gnu services)
             (nongnu packages linux)
             (nongnu system linux-initrd)
             (gnu services virtualization)
             (gnu packages fonts)
             (guix packages))
(use-service-modules linux nix desktop networking ssh xorg)
(use-package-modules linux package-management)

;; Enable nonguix substitutes
(define %my-services
  (modify-services %desktop-services
                   (guix-service-type config => (guix-configuration
                                                 (inherit config)
                                                 (substitute-urls
                                                  (append (list "https://substitutes.nonguix.org")
                                                          %default-substitute-urls))
                                                 (authorized-keys
                                                  (append (list (local-file "./signing-key.pub"))
                                                          %default-authorized-guix-keys))))))

(operating-system
 (locale "cs_CZ.utf8")
 (timezone "Europe/Prague")
 (keyboard-layout (keyboard-layout "cz"))
 (host-name "eternity")
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 (users (cons* (user-account
                (name "jan")
                (comment "Jan Novotný")
                (group "users")
                (home-directory "/home/jan")
                (supplementary-groups
                 '("wheel" "netdev" "audio" "video" "lp")))
               %base-user-accounts))
 (packages
  (append
   (map specification->package
        (list
         "nss-certs"
         "font-liberation"
         "font-dejavu"
         "font-abbatis-cantarell"
         "flatpak"
         "vim"
         "neofetch"
         "crawl"
         "crawl-tiles"
         "nethack"
         "nix"
         "curl"
         "gnome-tweaks"
         "icecat"
         "htop"
         "emacs"
         "virt-manager"
         "podman"
         "git"))
   %base-packages))
 (services
  (append
   (list (service gnome-desktop-service-type)
         (bluetooth-service #:auto-enable? #f)
         (set-xorg-configuration
          (xorg-configuration
           (keyboard-layout keyboard-layout)))
         (service libvirt-service-type
                  (libvirt-configuration
                   (unix-sock-group "libvirt")
                   (tls-port "16555")))
         (service nix-service-type)
         (service zram-device-service-type
                  (zram-device-configuration
                   (size "8172M")
                   (compression-algorithm 'zstd))))
   %my-services))
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets '("/dev/sda"))
   (keyboard-layout keyboard-layout)))
 (file-systems
  (cons* (file-system
          (mount-point "/")
          (device
           (uuid "fb3dcab3-013a-43ad-b18a-3f04cbaed3ee"
                 'ext4))
          (type "ext4"))
         %base-file-systems)))

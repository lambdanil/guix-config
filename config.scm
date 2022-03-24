;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
	     (nongnu packages linux)
	     (nongnu system linux-initrd)
             (gnu services virtualization)
             (gnu packages fonts)
             (guix packages))
(use-service-modules desktop networking ssh xorg)

(define %my-services
  (modify-services %desktop-services
             (guix-service-type config => (guix-configuration
               (inherit config)
               (substitute-urls
                (append (list "https://substitutes.nonguix.org")
                  %default-substitute-urls))
               (authorized-keys
                (append (list (local-file "./signing-key.pub"))
                  %default-authorized-guix-keys)))))
  )

(define %my-packages
  '("ungoogled-chromium"
  ))

(operating-system
  (locale "cs_CZ.utf8")
  (timezone "Europe/Prague")
  (keyboard-layout (keyboard-layout "cz"))
  (host-name "eternal")
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (users (cons* (user-account
                  (name "jan")
                  (comment "Jan Novotný")
                  (group "users")
                  (home-directory "/home/jan")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "nss-certs"))
      (list (specification->package "font-liberation"))
      %base-packages
      ))
  (services
    (append
      (list (service gnome-desktop-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout))))
      (list (service libvirt-service-type
         (libvirt-configuration
          (unix-sock-group "libvirt")
          (tls-port "16555"))))
      %my-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (targets '("/dev/sda"))
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "")))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid ""
                     'ext4))
             (type "ext4"))
           %base-file-systems)))

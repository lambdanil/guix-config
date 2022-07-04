cp -f ~/.local/share/flatpak/app/*/current/active/export/share/icons/hicolor/* ~/.local/share/icons/Adwaita -r
export XDG_DATA_DIRS="$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share"
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"


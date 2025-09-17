cat << EOF > /etc/environment
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
SDL_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
# electron
ELECTRON_OZONE_PLATFORM_HINT=auto
EOF

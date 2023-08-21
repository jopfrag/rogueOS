FROM quay.io/fedora-ostree-desktops/silverblue:38

ADD usr /usr
ADD etc /etc

RUN rpm-ostree override remove \
    firefox-langpacks \
    firefox \
    toolbox

RUN rpm-ostree install \
    alacritty \
    adw-gtk3-theme \
    breeze-cursor-theme \
    buildah \
    distrobox \
    gnome-tweaks \
    numix-icon-theme-circle \
    podman-compose \
    podman-docker \
    podman-plugins \
    podman

RUN systemctl enable rpm-ostreed-automatic.timer
RUN systemctl enable flatpak-system-update.timer
RUN systemctl --global enable flatpak-user-update.timer

RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
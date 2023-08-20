FROM quay.io/fedora-ostree-desktops/silverblue:38

ADD usr /usr
ADD etc /etc

RUN wget https://downloads.1password.com/linux/keys/1password.asc -O /etc/pki/rpm-gpg/1password.asc

RUN rpm-ostree override remove \
    firefox-langpacks \
    firefox \
    toolbox

RUN rpm-ostree install \
    1password-cli

RUN rpm-ostree install \
    alacritty \
    bat \
    buildah \
    distrobox \
    lsd \
    podman-compose \
    podman-docker \
    podman-plugins \
    podman \
    starship \
    skopeo \
    ripgrep \
    tio \
    zsh

RUN systemctl enable rpm-ostreed-automatic.timer
RUN systemctl enable flatpak-system-update.timer
RUN systemctl --global enable flatpak-user-update.timer

RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
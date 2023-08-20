FROM quay.io/fedora-ostree-desktops/silverblue:38

ADD usr /usr

RUN rpm-ostree install \
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
    zsh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit

RUN systemctl enable rpm-ostreed-automatic.timer
RUN systemctl enable flatpak-system-update.timer
RUN systemctl --global enable flatpak-user-update.timer

RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
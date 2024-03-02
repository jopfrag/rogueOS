FROM quay.io/fedora/fedora-coreos:stable

RUN rpm-ostree override remove \
    console-login-helper-messages-issuegen \
    coreos-installer \
    coreos-installer-bootinfra \
    chrony \
    ignition \
    moby-engine \
    NetworkManager \
    NetworkManager-tui \
    NetworkManager-team \
    NetworkManager-cloud-setup \
    teamd \
    toolbox \
    zincati

RUN curl -o /etc/yum.repos.d/bottom.repo https://copr.fedorainfracloud.org/coprs/atim/bottom/repo/fedora-39/atim-bottom-fedora-39.repo
RUN curl -o /etc/yum.repos.d/code.repo https://packages.microsoft.com/yumrepos/vscode/config.repo
RUN curl -o /etc/yum.repos.d/docker.repo https://download.docker.com/linux/fedora/docker-ce.repo
RUN curl -o /etc/yum.repos.d/starship.repo https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-39/atim-starship-fedora-39.repo
RUN curl -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

RUN rpm-ostree install \
    alacritty \
    bat \
    bottom \
    breeze-cursor-theme \
    code \
    distrobox \
    helix \
    eza \
    iwd \
    gh \
    nautilus \
    numix-icon-theme-circle \
    nvme-cli \
    ripgrep \
    tailscale \
    sshpass \
    systemd-networkd \
    starship \
    sway \
    zsh

# RUN systemctl enable docker
RUN systemctl enable systemd-networkd
RUN systemctl enable iwd

COPY root/ /

RUN rm -rf /tmp/* /var/* \
    && rpm-ostree cleanup -m \
    && ostree container commit \
    && mkdir -p /var/tmp && chmod -R 1777 /var/tmp

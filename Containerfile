FROM quay.io/fedora-ostree-desktops/sericea:39

RUN rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    toolbox

RUN rpm-ostree override remove \
    NetworkManager \
    network-manager-applet \
    NetworkManager-wwan \
    NetworkManager-bluetooth \
    NetworkManager-wifi \
    NetworkManager-sstp \
    NetworkManager-sstp-gnome \
    NetworkManager-vpnc \
    NetworkManager-vpnc-gnome \
    NetworkManager-pptp \
    NetworkManager-pptp-gnome \
    NetworkManager-openvpn \
    NetworkManager-openvpn-gnome \
    NetworkManager-openconnect \
    NetworkManager-openconnect-gnome \
    NetworkManager-libreswan \
    NetworkManager-libreswan-gnome \
    Networkmanager-l2pt \
    NetworkManager-l2tp-gnome

RUN rpm-ostree install \
    alacritty \
    breeze-cursor-theme \
    distrobox \
    iwd \
    gh \
    numix-icon-theme-circle \
    nvme-cli 

RUN rpm-ostree install \
    dconf-editor \
    evince \
    gnome-boxes \
    gnome-calculator \
    gnome-disk-utility \
    loupe \
    nautilus \
    helix \
    ripgrep \
    bat \
    eza \
    zsh

RUN curl -o /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/fedora/docker-ce.repo
RUN rpm-ostree install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
RUN systemctl enable docker

RUN curl -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
RUN rpm-ostree install \
    tailscale

RUN wget https://github.com/evilsocket/opensnitch/releases/download/v1.6.2/opensnitch-1.6.2-1.x86_64.rpm
RUN wget https://github.com/evilsocket/opensnitch/releases/download/v1.6.4/opensnitch-ui-1.6.4-1.noarch.rpm
RUN rpm-ostree install \
    opensnitch-1.6.2-1.x86_64.rpm \
    opensnitch-ui-1.6.4-1.noarch.rpm
RUN rm \
    opensnitch-1.6.2-1.x86_64.rpm \
    opensnitch-ui-1.6.4-1.noarch.rpm
RUN systemctl enable opensnitch

RUN curl -o /etc/yum.repos.d/code.repo https://packages.microsoft.com/yumrepos/vscode/config.repo
RUN rpm-ostree install \
    code

RUN curl -o /etc/yum.repos.d/starship.repo https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-39/atim-starship-fedora-39.repo
RUN rpm-ostree install \
    starship

RUN curl -o /etc/yum.repos.d/bottom.repo https://copr.fedorainfracloud.org/coprs/atim/bottom/repo/fedora-39/atim-bottom-fedora-39.repo
RUN rpm-ostree install \
    bottom

RUN systemctl enable systemd-networkd
RUN systemctl enable iwd

COPY root/ /

RUN rm -rf /tmp/* /var/*
RUN rpm-ostree cleanup -m
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp

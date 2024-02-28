FROM quay.io/fedora-ostree-desktops/sericea:40

RUN rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    toolbox

RUN rpm-ostree install \
    alacritty \
    breeze-cursor-theme \
    distrobox \
    fira-code-fonts \
    google-noto-color-emoji-fonts \
    nautilus \
    numix-icon-theme-circle \
    nvme-cli

RUN rpm-ostree install \
    dconf-editor \
    evince \
    gnome-boxes \
    gnome-calculator \
    gnome-firmware \
    gnome-disk-utility \
    loupe \
    nm-connection-editor-desktop \
    snapshot

# RUN curl -o /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/fedora/docker-ce.repo
# RUN rpm-ostree install \
#     docker-ce \
#     docker-ce-cli \
#     containerd.io \
#     docker-buildx-plugin \
#     docker-compose-plugin
# RUN systemctl enable docker

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

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
RUN rpm-ostree install \
    google-chrome-stable_current_x86_64.rpm
RUN rm \
    google-chrome-stable_current_x86_64.rpm

RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=check/' /etc/rpm-ostreed.conf
RUN systemctl enable rpm-ostreed-automatic.timer

RUN sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf
RUN sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf

RUN rm -rf /tmp/* /var/*
RUN rpm-ostree cleanup -m
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp

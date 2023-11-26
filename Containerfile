FROM quay.io/fedora-ostree-desktops/silverblue:39

RUN rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    gnome-system-monitor \
    gnome-terminal \
    gnome-terminal-nautilus \
    gnome-tour \
    gnome-shell-extension-background-logo \
    toolbox \
    yelp

RUN rpm-ostree install \
    alacritty \
    breeze-cursor-theme \
    distrobox \
    fira-code-fonts \
    google-noto-color-emoji-fonts \
    numix-icon-theme-circle \
    nvme-cli \
    onedrive

RUN rpm-ostree install \
    evince \
    evolution-ews \
    gnome-boxes \
    gnome-calculator \
    gnome-firmware \
    gnome-shell-extension-appindicator \
    gnome-shell-extension-pop-shell \
    gnome-shell-extension-user-theme \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-just-perfection \
    gnome-shell-extension-caffeine \
    gnome-shell-extension-blur-my-shell \
    gnome-tweaks \
    gnome-disk-utility \
    loupe \
    snapshot

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

RUN git clone https://github.com/Vladimir-csp/xdg-terminal-exec
RUN mv xdg-terminal-exec/xdg-terminal-exec /usr/bin/xdg-terminal-exec
RUN rm -r xdg-terminal-exec

RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=check/' /etc/rpm-ostreed.conf
RUN systemctl enable rpm-ostreed-automatic.timer

RUN sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf
RUN sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf

RUN rm -rf /tmp/* /var/*
RUN rpm-ostree cleanup -m
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
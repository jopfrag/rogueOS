FROM quay.io/fedora-ostree-desktops/silverblue:39

# RUN wget https://copr.fedorainfracloud.org/coprs/kylegospo/gnome-vrr/repo/fedora-$(rpm -E %fedora)/kylegospo-gnome-vrr-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-gnome-vrr.repo
# RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:kylegospo:gnome-vrr \
#     mutter \
#     mutter-common \
#     gnome-control-center \
#     gnome-control-center-filesystem

# RUN rpm-ostree install \
#     https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
#     https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# RUN rpm-ostree install \
#     rpmfusion-free-release \
#     rpmfusion-nonfree-release \
#     --uninstall rpmfusion-free-release \
#     --uninstall rpmfusion-nonfree-release
# RUN rpm-ostree install \
#     intel-media-driver \
#     libva-intel-driver
# RUN rpm-ostree override \
#     remove mesa-va-drivers \
#     --install=mesa-va-drivers-freeworld \
#     --install=mesa-vdpau-drivers-freeworld
# RUN rpm-ostree override remove \
#     libavfilter-free \
#     libavformat-free \
#     libavcodec-free \
#     libavutil-free \
#     libpostproc-free \
#     libswresample-free \
#     libswscale-free \
#     --install=ffmpeg
# RUN rpm-ostree install \
#     gstreamer1-plugin-libav \
#     gstreamer1-plugins-bad-free-extras \
#     gstreamer1-plugins-ugly \
#     gstreamer1-vaapi

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
    onedrive \
    waydroid

RUN rpm-ostree install \
    dconf-editor \
    evince \
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
    nm-connection-editor-desktop \
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

RUN wget https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.43/AdGuardHome_linux_amd64.tar.gz
RUN tar -xf AdGuardHome_linux_amd64.tar.gz
RUN mv AdGuardHome/AdGuardHome /usr/local/bin/AdGuardHome
RUN AdGuardHome -s install
RUN rm -r -f AdGuardHome_linux_amd64.tar.gz
RUN rm -r -f AdGuardHome

# RUN curl -o /etc/yum.repos.d/code.repo https://packages.microsoft.com/yumrepos/vscode/config.repo
# RUN rpm-ostree install \
#     code

# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
# RUN rpm-ostree install \
#     google-chrome-stable_current_x86_64.rpm
# RUN rm \
#     google-chrome-stable_current_x86_64.rpm

RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=check/' /etc/rpm-ostreed.conf
RUN systemctl enable rpm-ostreed-automatic.timer

RUN sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf
RUN sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf

RUN rm -rf /tmp/* /var/*
RUN rpm-ostree cleanup -m
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp

FROM quay.io/fedora-ostree-desktops/sericea:39

# rpm fusion repos
RUN rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# setup external dependencies
RUN curl -o /etc/yum.repos.d/bottom.repo https://copr.fedorainfracloud.org/coprs/atim/bottom/repo/fedora-39/atim-bottom-fedora-39.repo
RUN curl -o /etc/yum.repos.d/code.repo https://packages.microsoft.com/yumrepos/vscode/config.repo
RUN curl -o /etc/yum.repos.d/docker.repo https://download.docker.com/linux/fedora/docker-ce.repo
RUN curl -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
RUN curl -o /etc/yum.repos.d/starship.repo https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-39/atim-starship-fedora-39.rep

# remove things we don't use from base image 
RUN rpm-ostree override remove \
    blueman \
    firefox \
    firefox-langpacks \
    firewalld \
    foot \
    lxqt-policykit \
    network-manager-applet \
    sddm \
    sddm-wayland-sway \
    sway-config-fedora \
    toolbox \
    uresourced \
    NetworkManager \
    NetworkManager-bluetooth \
    NetworkManager-libreswan \
    NetworkManager-libreswan-gnome \
    NetworkManager-l2tp \
    NetworkManager-l2tp-gnome \
    NetworkManager-pptp \
    NetworkManager-pptp-gnome \
    NetworkManager-openconnect \
    NetworkManager-openconnect-gnome \
    NetworkManager-openvpn \
    NetworkManager-openvpn-gnome \
    NetworkManager-sstp \
    NetworkManager-sstp-gnome \
    NetworkManager-vpnc \
    NetworkManager-vpnc-gnome \
    NetworkManager-wifi \
    NetworkManager-wwan

RUN rpm-ostree override remove \
    dmenu 

# setup a bare min system
RUN rpm-ostree install \
    alacritty \
    bat \
    bottom \
    breeze-cursor-theme \
    code \
    distrobox \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    eza \
    fzf \
    gh \
    helix \
    iwd \
    nautilus \
    numix-icon-theme-circle \
    ripgrep \
    starship \
    tailscale \
    tuigreet \
    wofi \
    zoxide \
    zsh

# rpm fusion stuff
RUN rpm-ostree install \
    ffmpeg \
    gstreamer1-plugin-libav \
    gstreamer1-plugins-bad-free-extras \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-ugly \
    gstreamer1-vaapi \
    intel-media-driver 

# install opensnitch
RUN wget https://github.com/evilsocket/opensnitch/releases/download/v1.6.5/opensnitch-1.6.5-1.x86_64.rpm \
    && wget https://github.com/evilsocket/opensnitch/releases/download/v1.6.5.1/opensnitch-ui-1.6.5.1-1.noarch.rpm \
    && rpm-ostree install opensnitch-1.6.5-1.x86_64.rpm opensnitch-ui-1.6.5.1-1.noarch.rpm \
    && rm opensnitch-1.6.5-1.x86_64.rpm opensnitch-ui-1.6.5.1-1.noarch.rpm

# enable systemd systems 
RUN systemctl enable docker
RUN systemctl enable opensnitch
RUN systemctl enable systemd-networkd
RUN systemctl enable iwd

# override defaults settings
COPY root/ /

# to be deleted after installing
RUN curl -o /etc/google-chrome-stable_current_x86_64.rpm https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

# cleanup
RUN rm -rf /tmp/* /var/* \
    && rpm-ostree cleanup -m \
    && ostree container commit \
    && mkdir -p /var/tmp && chmod -R 1777 /var/tmp

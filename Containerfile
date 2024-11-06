FROM quay.io/fedora-ostree-desktops/silverblue:41

# rpm fusion repos
RUN rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# setup external dependencies
RUN curl -o /etc/yum.repos.d/bottom.repo https://copr.fedorainfracloud.org/coprs/atim/bottom/repo/fedora-41/atim-bottom-fedora-41.repo
RUN curl -o /etc/yum.repos.d/code.repo https://packages.microsoft.com/yumrepos/vscode/config.repo
RUN curl -o /etc/yum.repos.d/docker.repo https://download.docker.com/linux/fedora/docker-ce.repo
RUN curl -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
RUN curl -o /etc/yum.repos.d/starship.repo https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-39/atim-starship-fedora-41.rep

# install gnome stuff
RUN rpm-ostree install \
    breeze-cursor-theme \
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
    numix-icon-theme-circle \
    snapshot

# install tools
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
    fuse-sshfs \
    fzf \
    gh \
    helix \
    just \
    mosh \
    ripgrep \
    starship \
    tailscale \
    tio \
    tldr \
    tokei \
    zoxide \
    zsh

# install c toolchain
RUN rpm-ostree install \
    clang \
    clang-analyzer \
    clang-libs \
    clang-tidy-sarif \
    clang-tools-extra \
    CUnit \
    CUnit-devel \
    gdb \
    meson \
    mold \
    lld \
    lldb \
    python3-clang \
    python3-lldb

# rust toolchain
RUN rpm-ostree install \
    rustup

# go toolchain
RUN rpm-ostree install \
    go \
    golang-honnef-tools \
    golang-x-tools-*

# python toolchain
RUN rpm-ostree install \
    pipx \
    ruff

# enable systemd systems 
RUN systemctl enable docker

# override defaults settings
COPY root/ /

# update font cache
RUN fc-cache -f

# create symlink 
RUN ln -s /usr/bin/lldb-dap /usr/bin/lldb-vscode

# to be deleted after installing
RUN curl -o /etc/new-google-chrome-stable-5.rpm https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

# cleanup
RUN rm -rf /tmp/* /var/* \
    && rpm-ostree cleanup -m \
    && ostree container commit \
    && mkdir -p /var/tmp && chmod -R 1777 /var/tmp

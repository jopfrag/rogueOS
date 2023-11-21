FROM quay.io/fedora-ostree-desktops/silverblue:39

RUN rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    gnome-shell-extension-background-logo \
    toolbox

RUN rpm-ostree install \
    alacritty \
    breeze-cursor-theme \
    distrobox \
    numix-icon-theme-circle

RUN rpm-ostree install \
    gnome-tweaks \
    gnome-shell-extension-blur-my-shell \
    gnome-shell-extension-caffeine \
    gnome-shell-extension-just-perfection \
    gnome-shell-extension-pop-shell \
    gnome-shell-extension-user-theme

RUN rpm-ostree install \
    intel-media-driver libva-intel-drivers
RUN rpm-ostree override remove \
    mesa-va-drivers \
    --install=mesa-va-drivers-freeworld \ 
    --install=mesa-vdpau-drivers-freeworld
RUN rpm-ostree override remove \
    libavfilter-free \
    libavformat-free \
    libavcodec-free \
    libavutil-free \
    libpostproc-free \
    libswresample-free \
    libswscale-free \
    --install=ffmpeg
RUN rpm-ostree install \
    gstreamer1-plugin-libav \
    gstreamer1-plugins-bad-free-extras \
    gstreamer1-plugins-ugly \
    gstreamer1-vaapi

RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=check/' /etc/rpm-ostreed.conf
RUN systemctl enable rpm-ostreed-automatic.timer

RUN sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf
RUN sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf

RUN rm -rf /tmp/* /var/*
RUN rpm-ostree cleanup -m
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
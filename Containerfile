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
    numix-icon-theme-circle \
    nvme-cli 

RUN rpm-ostree install \
    evince \
    gnome-boxes \
    gnome-calculator \
    gnome-shell-extension-pop-shell \
    gnome-shell-extension-user-theme \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-just-perfection \
    gnome-shell-extension-caffeine \
    gnome-shell-extension-blur-my-shell \
    gnome-tweaks \
    gnome-disk-utility \
    loupe

RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=check/' /etc/rpm-ostreed.conf
RUN systemctl enable rpm-ostreed-automatic.timer

RUN sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf
RUN sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf

RUN rm -rf /tmp/* /var/*
RUN rpm-ostree cleanup -m
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
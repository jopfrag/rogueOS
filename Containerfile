FROM quay.io/fedora-ostree-desktops/silverblue:38

RUN rpm-ostree install \
    distrobox

RUN rpm-ostree cleanup -m
RUN ostree container commit
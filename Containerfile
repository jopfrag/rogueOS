FROM quay.io/fedora-ostree-desktops/silverblue:38

RUN rpm-ostree install \
    distrobox && \
    rm -rf /tmp/* /var/* && \
    ostree container commit
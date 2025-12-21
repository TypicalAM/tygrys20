# Using own mirror of fedora-bootc from https://gitlab.com/fedora/bootc/base-images to allow for better package caching
FROM docker.io/typicalam/fedora-bootc:43 AS base

LABEL org.opencontainers.image.title="Custom fedora bootc"
LABEL org.opencontainers.image.description="Customized image of Fedora Bootc"
LABEL org.opencontainers.image.source="https://github.com/TypicalAM/tygrys20"
LABEL org.opencontainers.image.licenses="MIT"

COPY --chmod=0644 ./system/etc /etc
COPY --chmod=0755 ./system/scripts /tmp/scripts
COPY --chmod=0644 ./src/ /tmp/src
COPY ./system/usr/share/tygrys20 /usr/share/tygrys20
COPY ./system/usr/lib/systemd /usr/lib/systemd

RUN rm -rf /opt && \
    ln -s -T /var/opt /opt && \
    mkdir /var/roothome && \
    /tmp/scripts/install-rpm-packages && \
    /tmp/scripts/install-extra-packages && \
    /tmp/scripts/config-users && \
    /tmp/scripts/config-authselect && \
    /tmp/scripts/config-yubikey && \
    /tmp/scripts/config-systemd && \
    /tmp/scripts/config-release-info && \
    /tmp/scripts/build-initramfs && \
    rm -rf /var/cache /var/run /var/log /tmp/scripts /var/roothome/.config /var/roothome/.cache /var/lib/systemd

COPY ./system/usr /usr

RUN chmod +x /usr/bin/firstboot-setup && \
    bootc container lint

FROM base AS nvidia

COPY --chmod=0644 ./nvidia/etc /etc
COPY --chmod=0755 ./nvidia/scripts /tmp/scripts
COPY --chmod=0755 ./system/scripts/build-initramfs /tmp/scripts/build-initramfs
COPY ./nvidia/usr/share/tygrys20 /usr/share/tygrys20
COPY ./nvidia/usr/lib/systemd /usr/lib/systemd

RUN grep -vE '^#' /usr/share/tygrys20/packages-added-nvidia | xargs dnf -y install --best --allowerasing && \
    /tmp/scripts/build-kmod && \
    /tmp/scripts/build-initramfs && \
    rm -rf /var/cache /var/lib /var/log /var/run* /tmp/scripts && \
    systemctl enable supergfxd.service && \
    bootc container lint

COPY ./nvidia/usr /usr

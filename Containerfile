ARG FEDORA_VERSION=45
FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_VERSION}

RUN set -eu; \
    set --; \
    for package in firefox firefox-langpacks gnome-tour malcontent-control gnome-maps gnome-weather yelp gnome-calendar gnome-software gnome-software-rpm-ostree gnome-connections snapshot cheese; do \
        if rpm -q "$package" >/dev/null 2>&1; then set -- "$@" "$package"; fi; \
    done; \
    if [ "$#" -gt 0 ]; then rpm-ostree override remove "$@"; fi; \
    for package in firefox gnome-tour malcontent-control gnome-maps gnome-weather yelp gnome-calendar gnome-software gnome-software-rpm-ostree gnome-connections snapshot cheese; do \
        if rpm -q "$package" >/dev/null 2>&1; then exit 1; fi; \
    done; \
    ostree container commit

# Instala o Brave Origin do repositório oficial durante o build.
RUN curl -fsSLo /etc/yum.repos.d/brave-browser.repo \
        https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo \
    && mkdir -p /var/opt /usr/lib/opt/brave.com \
    && ln -s /usr/lib/opt/brave.com /var/opt/brave.com \
    && rpm-ostree install brave-origin \
    && rpm -q brave-origin \
    && printf '%s\n' 'L /var/opt/brave.com - - - - /usr/lib/opt/brave.com' > /usr/lib/tmpfiles.d/brave-origin.conf \
    && rm /var/opt/brave.com \
    && ostree container commit

# RPM Fusion Free fornece os codecs adicionais; os pacotes Fedora
# fornecem os carregadores de imagens e os geradores de miniaturas.
RUN rpm-ostree install \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    && ostree container commit

RUN rpm-ostree override remove libavcodec-free --install libavcodec-freeworld \
    && rpm-ostree install \
        ffmpegthumbnailer \
        gstreamer1-plugin-libav \
        gstreamer1-plugins-ugly \
        glycin-loaders \
        libheif-tools \
        libheif-freeworld \
    && test -x /usr/bin/ffmpegthumbnailer \
    && test -f /usr/share/thumbnailers/heif.thumbnailer \
    && ostree container commit

COPY files/bazaar.repo /etc/yum.repos.d/bazaar.repo
RUN rpm-ostree install bazaar flatpak \
    && rpm -q bazaar \
    && ostree container commit

RUN test -x /usr/bin/bootc && bootc container lint

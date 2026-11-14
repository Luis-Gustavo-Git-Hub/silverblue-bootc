ARG FEDORA_VERSION=45
FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_VERSION}

RUN set -eu; \
    set --; \
    for package in firefox firefox-langpacks gnome-tour malcontent-control gnome-maps; do \
        if rpm -q "$package" >/dev/null 2>&1; then set -- "$@" "$package"; fi; \
    done; \
    if [ "$#" -gt 0 ]; then rpm-ostree override remove "$@"; fi; \
    for package in firefox gnome-tour malcontent-control gnome-maps; do \
        if rpm -q "$package" >/dev/null 2>&1; then exit 1; fi; \
    done; \
    ostree container commit

# Instala o Brave Origin do repositório oficial durante o build.
RUN curl -fsSLo /etc/yum.repos.d/brave-browser.repo \
        https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo \
    && rpm-ostree install brave-origin \
    && rpm -q brave-origin \
    && ostree container commit

RUN test -x /usr/bin/bootc && bootc container lint

ARG FEDORA_VERSION=45
FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_VERSION}

RUN set -eu; \
    set -- firefox; \
    if rpm -q firefox-langpacks >/dev/null 2>&1; then set -- "$@" firefox-langpacks; fi; \
    rpm-ostree override remove "$@"; \
    if rpm -q firefox >/dev/null 2>&1; then exit 1; fi; \
    ostree container commit

# Instala o Brave Origin do repositório oficial durante o build.
RUN curl -fsSLo /etc/yum.repos.d/brave-browser.repo \
        https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo \
    && rpm-ostree install brave-origin \
    && rpm -q brave-origin \
    && ostree container commit

RUN test -x /usr/bin/bootc && bootc container lint

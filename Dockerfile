# syntax=docker/dockerfile:1

FROM alpine AS builder

ARG radarr_url
ARG TARGETARCH

COPY scripts/start.sh /

RUN apk -U --no-cache upgrade

RUN apk add --no-cache libmediainfo icu-libs libintl sqlite-libs ca-certificates curl
RUN mkdir -p /opt/radarr /config
RUN case "${TARGETARCH}" in \
        "arm") echo "arm" > /tmp/radarr_arch;;\
        "arm64") echo "arm64" > /tmp/radarr_arch;;\
        "amd64") echo "x64" > /tmp/radarr_arch;;\
        *) echo "none" > /tmp/radarr_arch;;\
    esac
RUN radarr_arch=`cat /tmp/radarr_arch`; curl -o - -L "${radarr_url}&arch=${radarr_arch}" | tar xz -C /opt/radarr --strip-components=1
RUN apk del curl
RUN chmod -R 777 /opt/radarr /start.sh

RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

FROM scratch

ARG RADARR_RELEASE

ENV PUID=0
ENV PGID=0
ENV RADARR_RELEASE=${RADARR_RELEASE}

COPY --from=builder / /
# ports and volumes
EXPOSE 7878
VOLUME /config

CMD ["/start.sh"]
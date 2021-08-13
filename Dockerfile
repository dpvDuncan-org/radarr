ARG BASE_IMAGE_PREFIX

FROM ${BASE_IMAGE_PREFIX}alpine

ARG radarr_url
ARG RADARR_RELEASE

ENV PUID=0
ENV PGID=0
ENV RADARR_RELEASE=${RADARR_RELEASE}

COPY scripts/start.sh /

RUN apk -U --no-cache upgrade

RUN apk add --no-cache libmediainfo icu-libs libintl sqlite-libs ca-certificates curl
RUN mkdir -p /opt/radarr /config
RUN curl -o - -L "${radarr_url}" | tar xz -C /opt/radarr --strip-components=1
RUN apk del curl
RUN chmod -R 777 /opt/radarr /start.sh

RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# ports and volumes
EXPOSE 7878
VOLUME /config

CMD ["/start.sh"]
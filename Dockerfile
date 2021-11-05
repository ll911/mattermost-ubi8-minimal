FROM registry.access.redhat.com/ubi8-minimal:8.4
MAINTAINER leo.lou@gov.bc.ca

LABEL name="Mattermost" \
      vendor="Mattermost" \
      version="Team" \
      release="5.37.3" \
      url="https://mattermost.com/" \
      summary="Mattermost Team Edition" \
      description="A free-to-use, open source, self-hosted alternative to proprietary SaaS messaging. Team Edition is your open source “virtual office”, offering all the core productivity benefits of competing SaaS solutions. It deploys as a single Linux binary with MySQL or PostgreSQL under an MIT license."          

ENV PATH="/mattermost/bin:${PATH}"

ARG PUID=1001
ARG PGID=1001
ARG MM_PACKAGE="https://releases.mattermost.com/5.37.3/mattermost-5.37.3-linux-amd64.tar.gz?src=docker"

RUN printf "[main]\ngpgcheck=1\ninstallonly_limit=3\nclean_requirements_on_remove=true" > /etc/dnf/dnf.conf && \
    microdnf install --nodocs gzip hostname libyaml shadow-utils tar && \
      mkdir -p /mattermost/data /mattermost/plugins /mattermost/client/plugins \
      && if [ ! -z "$MM_PACKAGE" ]; then curl $MM_PACKAGE | tar -xvz ; \
      else echo "please set the MM_PACKAGE" ; fi \
      && groupadd -r -g ${PGID} mattermost \
      && useradd -r -M -u ${PUID} -g mattermost -d /mattermost mattermost\
      && chown -R mattermost:mattermost /mattermost /mattermost/plugins /mattermost/client/plugins \
      && chmod 664 /etc/passwd \
      && microdnf remove shadow-utils && microdnf clean all && \
      rm -rf /tmp/*

COPY entrypoint.sh /
EXPOSE 8065 8067 8074 8075
WORKDIR /mattermost
VOLUME ["/mattermost/data", "/mattermost/logs", "/mattermost/config", "/mattermost/plugins", "/mattermost/client/plugins"]
ENTRYPOINT ["/entrypoint.sh"]

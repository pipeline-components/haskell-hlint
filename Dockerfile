FROM alpine:3.21.2 as build
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3018
RUN apk --no-cache add curl cabal ghc build-base upx libffi-dev && \
    mkdir -p /app/hlint
WORKDIR /app/hlint
RUN cabal update && \
    cabal install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info  hlint-3.8  && \
    upx -9 "$(readlink -f /root/.local/bin/hlint)"

# hadolint ignore=SC2046
RUN \
    find "$(dirname $(dirname $(readlink -f /root/.local/bin/hlint)))" | tar -cf /tmp/temp.tar -T /dev/stdin && \
    rm -rf /root/.local/state/cabal/store/ && \
    tar -xf /tmp/temp.tar -C / && \
    rm /tmp/temp.tar

FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

FROM alpine:3.21.2
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD hlint

# hadolint ignore=DL3018
RUN apk --no-cache add libffi libgmpxx
COPY --from=build /root/.local/state/cabal/store /root/.local/state/cabal/store
RUN find /root/.local/state/cabal/
RUN ln -nfs "$(find /root/.local/state/cabal -name hlint)" /usr/local/bin/hlint

# Workdir not posible for dynamic discovered paths
# hadolint ignore=DL3003,SC2046
RUN \
    cd "$(dirname $(dirname $(find /root/.local/state/cabal -name hlint)))" && \
    cp -a share bin/data

RUN hlint --version && hlint -d

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <dev@pipeline-components.dev>" \
    org.label-schema.description="Hlint for Haskell in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Hlint for Haskell" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/haskell-hlint/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/haskell-hlint/" \
    org.label-schema.vendor="Pipeline Components"

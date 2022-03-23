FROM alpine:3.15.2 as build
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3018
RUN apk --no-cache add curl cabal=3.6.2.0-r1 ghc build-base upx libffi-dev && \
    mkdir -p /app/hlint
WORKDIR /app/hlint
RUN cabal update && \
    cabal install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info  hlint-2.1.12  && \
    upx -9 "$(readlink -f /root/.cabal/bin/hlint)"

# hadolint ignore=SC2046
RUN \
    find "$(dirname $(dirname $(readlink -f /root/.cabal/bin/hlint)))" | tar -cf /tmp/temp.tar -T /dev/stdin && \
    rm -rf /root/.cabal/store/ && \
    tar -xf /tmp/temp.tar -C / && \
    rm /tmp/temp.tar

FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

FROM alpine:3.15.2
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD hlint

# hadolint ignore=DL3018
RUN apk --no-cache add libffi libgmpxx
COPY --from=build /root/.cabal/store /root/.cabal/store
RUN find /root/.cabal/
RUN ln -nfs "$(find /root/.cabal -name hlint)" /usr/local/bin/hlint

# Workdir not posible for dynamic discovered paths
# hadolint ignore=DL3003,SC2046
RUN \
    cd "$(dirname $(dirname $(find /root/.cabal -name hlint)))" && \
    mkdir bin/data && \
    cp share/default.yaml bin/data

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

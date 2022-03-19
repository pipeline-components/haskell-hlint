FROM alpine:3.15.1 as build

# hadolint ignore=DL3018
RUN apk --no-cache add curl cabal=3.6.2.0-r1 ghc build-base upx libffi-dev && \
    mkdir -p /app/hlint
WORKDIR /app/hlint
RUN cabal update && \
# Preinstall happy, because otherwise cabal is unhappy
    cabal install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info  happy-1.19.9  && \
    cabal install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info  hlint-2.1.12  && \
    upx -9 /root/.cabal/bin/hlint

FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

FROM alpine:3.15.1
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD hlint

RUN ln -nfs /root/.cabal/bin/hlint /usr/local/bin/hlint && \
    apk --no-cache add libffi libgmpxx
COPY --from=build /root/.cabal/bin/hlint /root/.cabal/bin/hlint
COPY --from=build /root/.cabal/share/x86_64-linux-ghc-8.6.5/hlint-2.1.12 /root/.cabal/share/x86_64-linux-ghc-8.6.5/hlint-2.1.12
RUN hlint --version

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

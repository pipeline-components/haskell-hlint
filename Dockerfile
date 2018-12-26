FROM alpine:3.8 as build

RUN apk --no-cache add curl=7.61.1-r1 cabal=2.2.0.0-r0 ghc=8.4.3-r0 build-base=0.5-r1 upx=3.94-r0
RUN mkdir -p /app/hlint
WORKDIR /app/hlint
RUN cabal update 
# Preinstall happy, because otherwise cabal is unhappy 
RUN cabal install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info  happy-1.19.9
RUN cabal install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info  hlint-2.1.12

RUN upx -9 /root/.cabal/bin/hlint

FROM alpine:3.8
RUN ln -nfs /root/.cabal/bin/hlint /usr/local/bin/hlint && \
    apk --no-cache add libffi=3.2.1-r4 libgmpxx=6.1.2-r1
COPY --from=build /root/.cabal/bin/hlint /root/.cabal/bin/hlint
COPY --from=build /root/.cabal/share/x86_64-linux-ghc-8.4.3/hlint-2.1.12 /root/.cabal/share/x86_64-linux-ghc-8.4.3/hlint-2.1.12
RUN hlint --version

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.label-schema.description="Hlint for Haskell in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Hlint for Haskell" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/haskell-hlint/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/haskell-hlint/" \
    org.label-schema.vendor="Pipeline Components"

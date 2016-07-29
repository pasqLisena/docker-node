FROM alpine:3.4

ENV VERSION=6.3.1 \
    NPM_VERSION=3

RUN apk add --update --no-cache wget sudo make gcc g++ python linux-headers paxctl libgcc libstdc++ \
    && wget https://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz \
    && tar -xzvf node-v${VERSION}.tar.gz \
    && cd node-v${VERSION} \
    && export GYP_DEFINES="linux_use_gold_flags=0" \
    && ./configure --prefix=/usr \
    && make -j$(grep -c '^processor' /proc/cpuinfo) -C out mksnapshot BUILDTYPE=Release \
    && paxctl -cm out/Release/mksnapshot \
    && make -j$(grep -c '^processor' /proc/cpuinfo) \
    && make install \
    && paxctl -cm /usr/bin/node \
    && cd / \
    && if [ -x /usr/bin/npm ]; then \
         npm install -g npm@${NPM_VERSION} \
    &&   find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
       fi \
    && rm -rf /node-${VERSION}.tar.gz \
              /node-${VERSION} \
              /usr/share/man \
              /tmp/* \
              /var/cache/apk/* \
              /root/.npm \
              /root/.node-gyp \
              /root/.gnupg \
              /usr/lib/node_modules/npm/man \
              /usr/lib/node_modules/npm/doc \
              /usr/lib/node_modules/npm/html

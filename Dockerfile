FROM alpine:3.4

ENV VERSION=6.3.1 \
    NPM_VERSION=3

RUN apk add --update --no-cache wget ca-certificates sudo make gcc g++ python linux-headers paxctl libgcc libstdc++ \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    && wget -q -O /var/cache/apk/glibc-2.23-r3.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk \
    && wget -q -O /var/cache/apk/glibc-bin-2.23-r3.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-bin-2.23-r3.apk \
    && apk add --no-cache /var/cache/apk/glibc-2.23-r3.apk /var/cache/apk/glibc-bin-2.23-r3.apk \
    && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc/usr/lib \
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

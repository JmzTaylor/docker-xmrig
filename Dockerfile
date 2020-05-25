FROM alpine

LABEL maintainer="James Taylor <jmz.taylor16@gmail.com>"

RUN set -xe;\
    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories; \
    apk update; \
    apk add util-linux build-base cmake libuv-static libuv-dev openssl-dev curl hwloc-dev@testing; \
    export VERSION=`curl --silent "https://api.github.com/repos/xmrig/xmrig/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`; \
    wget https://github.com/xmrig/xmrig/archive/${VERSION}.tar.gz; \
    tar xf ${VERSION}.tar.gz; \
    mkdir -p xmrig-${VERSION:1}/build; \
    cd xmrig-${VERSION:1}; \
    sed -i 's/= 5/= 0/' src/donate.h; \
    sed -i 's/= 1/= 0/' src/donate.h; \
    cd build; \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DUV_LIBRARY=/usr/lib/libuv.a;\
    make -j $(nproc); \
    cp xmrig /usr/local/bin/xmrig;\
    rm -rf xmrig* *.tar.gz; \
    apk del build-base; \
    apk del openssl-dev;\ 
    apk del hwloc-dev; \
    apk del cmake; \
    apk add hwloc@testing;

ENV POOL_USER="49Vs6CVAntsQ61Y6ATLCphhbzdAah5mkqcWhx3ayAtsD6NKNMwvvyCpSJsTQtBuzMvXeFqac1NAXZ8NKmDgoN8qtQ1q56ao" \
    POOL_PASS="" \
    POOL_URL="pool.supportxmr.com:3333" \
    PRIORITY=0 \
    THREADS=9

ADD entrypoint.sh /entrypoint.sh
WORKDIR /tmp
EXPOSE 3000
CMD ["/entrypoint.sh"]

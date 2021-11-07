ARG UPSTREAM_TAG="v16.2.5"

FROM debian:buster AS build

RUN apt-get update

RUN apt-get install -y build-essential automake curl

RUN mkdir /build \
 && curl -o /smartmontools.tar.gz https://altushost-swe.dl.sourceforge.net/project/smartmontools/smartmontools/7.2/smartmontools-7.2.tar.gz \
 && tar xf /smartmontools.tar.gz --strip-components=1 -C /build

WORKDIR /build

COPY hpsa-respect-hba-mode-1472.patch .

RUN patch os_linux.cpp hpsa-respect-hba-mode-1472.patch \
 && ./autogen.sh \
 && ./configure \
 && make

FROM ceph/ceph:$UPSTREAM_TAG

COPY --from=build /build/smartctl /usr/sbin/smartctl


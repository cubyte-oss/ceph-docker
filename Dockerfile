ARG UPSTREAM_TAG

FROM debian:bookworm AS build

RUN apt-get update

RUN apt-get install -y build-essential automake curl

RUN mkdir /build \
 && curl -o /smartmontools.tar.gz https://altushost-swe.dl.sourceforge.net/project/smartmontools/smartmontools/7.4/smartmontools-7.4.tar.gz \
 && tar xf /smartmontools.tar.gz --strip-components=1 -C /build

WORKDIR /build

RUN ./autogen.sh \
 && ./configure \
 && make

FROM quay.io/ceph/ceph:$UPSTREAM_TAG

COPY --from=build /build/smartctl /usr/sbin/smartctl


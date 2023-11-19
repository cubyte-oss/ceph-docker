ARG UPSTREAM_TAG

FROM quay.io/ceph/ceph:$UPSTREAM_TAG AS build

RUN dnf install -y automake curl gcc gcc-c++ make

RUN mkdir /build \
 && curl -o /smartmontools.tar.gz https://altushost-swe.dl.sourceforge.net/project/smartmontools/smartmontools/7.4/smartmontools-7.4.tar.gz \
 && tar xf /smartmontools.tar.gz --strip-components=1 -C /build

WORKDIR /build

RUN ./autogen.sh \
 && ./configure \
 && make

FROM quay.io/ceph/ceph:$UPSTREAM_TAG

COPY --from=build /build/smartctl /usr/sbin/smartctl


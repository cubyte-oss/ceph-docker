FROM quay.io/ceph/ceph:v19.2.1 AS upstream

FROM upstream AS build

RUN dnf install -y automake curl-minimal gcc gcc-c++ make

ARG SMARTMONTOOLS_VERSION="7.4"

RUN mkdir /build \
 && curl -L -o /smartmontools.tar.gz "https://downloads.sourceforge.net/project/smartmontools/smartmontools/${SMARTMONTOOLS_VERSION}/smartmontools-${SMARTMONTOOLS_VERSION}.tar.gz" \
 && tar xf /smartmontools.tar.gz --strip-components=1 -C /build

WORKDIR /build

RUN ./autogen.sh \
 && ./configure \
 && make

FROM upstream

COPY --from=build /build/smartctl /usr/sbin/smartctl


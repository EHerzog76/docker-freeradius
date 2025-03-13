#
ARG from=ubuntu:24.04
FROM ${from}
#FROM freeradius/freeradius-server:latest

LABEL Description="freeradius Docker based on Ubuntu." \
	License="GPLv2" \
        Author="Erwin Herzog <e.herzog76@live.de>" \
	org.opencontainers.image.authors="Erwin Herzog <e.herzog76@live.de>" \
	Usage="docker build -t eherzog/freeradius -f Dockerfile-freeradius" \
	Version="1.0"

ARG DEBIAN_FRONTEND=noninteractive

# default timezone
ENV TZ=Europe/Vienna

#
#  Install build tools
#
RUN apt-get update
RUN apt-get install -y curl

ARG freerad_uid=101
ARG freerad_gid=101

ENV RAD_DEBUG=no \
    TZ=Europe/Vienna \
	LINKS_REMOVE="" \
	LINKS_ADD=""

#
#  Set up NetworkRADIUS extras repository
#  and install NetworkRADIUS
RUN install -d -o root -g root -m 0755 /etc/apt/keyrings \
 && curl -o /etc/apt/keyrings/packages.networkradius.com.asc "https://packages.inkbridgenetworks.com/pgp/packages.networkradius.com.asc" \
 && printf 'Package: /freeradius/\nPin: origin "packages.networkradius.com"\nPin-Priority: 999\n' | tee /etc/apt/preferences.d/networkradius \
 && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.networkradius.com.asc] http://packages.networkradius.com/freeradius-3.2/ubuntu/noble noble main" | tee /etc/apt/sources.list.d/networkradius.list \
 && apt-get update -y \
 && apt-get -y install freeradius freeradius-krb5 freeradius-config freeradius-ldap freeradius-memcached freeradius-redis freeradius-rest freeradius-utils freeradius-mysql freeradius-postgresql freeradius-dhcp freeradius-perl-util freeradius-python3 rsync \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/* \
# && ln -s /etc/freeradius /etc/raddb
 && mkdir -p /etc/raddb \
 && mkdir /raddb-overwrites
#ToDo:
# && chgrp -R grp-Name /etc/raddb \
# && chmod -R 775 /etc/raddb

# Modules not found:
#freeradius-sqlite freeradius-freetds freeradius-unixODBC freeradius-perl freeradius-perl-util

#Should be configured by freeradius-Package
#RUN groupadd -g ${freerad_gid} -r freerad \
# && useradd -u ${freerad_uid} -g freerad -r -M -d /etc/freeradius -s /usr/sbin/nologin freerad

WORKDIR /
COPY ./docker-entrypoint.sh.deb docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh \
	&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
	&& ls -alh /etc/freeradius

VOLUME /etc/raddb /raddb-overwrites

EXPOSE 1812/udp 1813/udp

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeradius", "-d", "/etc/raddb"]

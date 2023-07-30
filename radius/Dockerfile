FROM debian:bookworm-slim

RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
            ca-certificates \
            netbase \
            tzdata \
	    ; \
	    rm -rf /var/lib/apt/lists/*

# SQLiteのセットアップ
RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
            gcc \
            libc6-dev \
            make \
            wget \
	    ; \
	    rm -rf /var/lib/apt/lists/*

ARG SQLITE_VER=sqlite-autoconf-3420000
RUN set -eux; \
        wget -c https://www.sqlite.org/2023/${SQLITE_VER}.tar.gz; \
        tar -xzvf ${SQLITE_VER}.tar.gz; \
        rm -rf ${SQLITE_VER}.tar.gz

RUN set -eux; \
        cd ${SQLITE_VER}; \
        ./configure; \
        make; \
        make install; \
        rm -rf /${SQLITE_VER}

# freeradiusのセットアップ
RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
            freeradius \
            freeradius-utils \
            whois \
            libpam-google-authenticator \
            qrencode \
        ; \
        rm -rf /var/lib/apt/lists/*

COPY --chmod=644 .setting/freeradius /etc/freeradius
COPY --chmod=644 .setting/radiusd /etc/pam.d/radiusd
COPY --chmod=700 init.sh /root/init.sh

RUN set -eux; \
        ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/; \
        ln -s /etc/freeradius/3.0/mods-available/pam /etc/freeradius/3.0/mods-enabled/pam

ARG USERNAME
ARG GROUPNAME
ARG PASSWORD
ENV USERNAME=${USERNAME}
ENV PASSWORD=${PASSWORD}
ARG RADIUSGROUP=radius-enabled
ARG UID=1000
ARG GID=1000
RUN set -eux; \
        groupadd -g $GID $GROUPNAME; \
        groupadd $RADIUSGROUP; \
        useradd -m -s /bin/bash -u $UID -g $GID $USERNAME; \
        gpasswd -a $USERNAME $RADIUSGROUP

EXPOSE 1182/udp
EXPOSE 1183/tcp

ENTRYPOINT [ "/root/init.sh" ]
FROM debian:bookworm-slim

RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
            ca-certificates \
		    netbase \
		    tzdata \
	    ; \
	    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
            gcc \
            libc6-dev \
            make \
            wget \
	    ; \
	    rm -rf /var/lib/apt/lists/*

# SQLiteのセットアップ
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
        ; \
        rm -rf /var/lib/apt/lists/*

COPY .setting/freeradius /etc/freeradius

RUN sqlite3 /var/lib/freeradius.db < /etc/freeradius/3.0/mods-config/sql/main/sqlite/schema.sql; \
    ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/


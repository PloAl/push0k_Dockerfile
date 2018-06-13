FROM ubuntu:xenial
RUN apt-get update && apt-get install -y apt-utils \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo locales wget \
        && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 \
        && update-locale LANG=ru_RU.UTF-8 \
        && groupadd -r postgres --gid=799 && useradd -r -g postgres --uid=799 postgres \
        && echo 'deb http://1c.postgrespro.ru/deb/ xenial main' > /etc/apt/sources.list.d/postgrespro-1c.list \
        && wget --quiet -O - http://1c.postgrespro.ru/keys/GPG-KEY-POSTGRESPRO-1C | apt-key add - \
        && apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y acl \
                postgresql-pro-1c-9.6 postgresql-client-pro-1c-9.6 postgresql-contrib-pro-1c-9.6 \
                openssh-server apache2 supervisor imagemagick libgsf-1-114 gosu mc unixodbc ttf-mscorefonts-installer curl git \
        && mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor \
        && curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs \
        && cd /usr/bin \
        && git clone https://github.com/ploal/push0k \
        && chmod -R 755 /usr/bin/push0k \
        && cd /usr/bin/push0k \
        && npm install --no-audit --no-optional --no-package-lock \
        && service postgresql start \
        && sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'YourPassword'" \
        && sudo -u postgres psql -a -f /usr/bin/push0k/push0kStructure.sql \
        && service postgresql stop \
        && sed 's/192.168.0.10/127.0.0.1/g' /usr/bin/push0k/config.js
COPY supervisord.conf /etc/supervisor/supervisord.conf        
VOLUME ["/public"]
CMD ["/usr/bin/supervisord","-n","-c /etc/supervisor/supervisord.conf"]
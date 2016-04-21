FROM debian:wheezy

ENV LANG en_US.UTF-8

ENV LANGUAGE en_US:en

ENV LC_ALL en_US.UTF-8

ENV PATH $PATH:/usr/local/mysql/bin:/usr/local/mysql/scripts

WORKDIR /usr/local/mysql

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql", "--default-storage-engine=InnoDB", "--sql-mode=ONLY_FULL_GROUP_BY"]

RUN env DEBIAN_FRONTEND=noninteractive && \
    groupadd -r mysql && \
    useradd -r -g mysql mysql && \
    apt-get update && \
    apt-get install -y curl binutils locales && \
    gpg --keyserver pgp.mit.edu --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5 && \
    sed -i "s|# en_US.UTF-8 UTF-8|en_US.UTF-8 UTF-8|" /etc/locale.gen && \
    locale-gen en_US.UTF-8 &&\
    update-locale && \
    curl -SL "http://dev.mysql.com/get/Downloads/MySQL-5.1/mysql-5.1.73-linux-x86_64-glibc23.tar.gz" -o mysql.tar.gz && \
    curl -SL "http://mysql.he.net/Downloads/MySQL-5.1/mysql-5.1.73-linux-x86_64-glibc23.tar.gz.asc" -o mysql.tar.gz.asc && \
    gpg --verify mysql.tar.gz.asc && \
    mkdir -p /usr/local/mysql && \
    tar -xzf mysql.tar.gz -C /usr/local/mysql --strip-components=1 && \
    rm mysql.tar.gz* && \
    rm -rf /usr/local/mysql/mysql-test /usr/local/mysql/sql-bench && \
    rm -rf /usr/local/mysql/bin/*-debug /usr/local/mysql/bin/*_embedded && \
    find /usr/local/mysql -type f -name "*.a" -delete && \
    { find /usr/local/mysql -type f -executable -exec strip --strip-all '{}' + || true; } && \
    apt-get purge -y --auto-remove binutils && \
    rm -rf /var/lib/apt/lists/* && \
    mv /usr/local/mysql/support-files/my-medium.cnf /etc/my.cnf && \
    sed -i "s|max_allowed_packet = 1M|max_allowed_packet = 16M|" /etc/my.cnf && \
    sed -i "s|#innodb_log_buffer_size = 8M|innodb_log_buffer_size = 32M|" /etc/my.cnf && \
    sed -i "s|#innodb_buffer_pool_size = 16M|innodb_buffer_pool_size = 512M|" /etc/my.cnf && \
    sed -i "s|#innodb_log_file_size = 5M|innodb_log_file_size = 256M|" /etc/my.cnf

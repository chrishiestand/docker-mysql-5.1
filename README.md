Docker image for old MySQL 5.1 database, based on [official MySQL image](https://github.com/docker-library/mysql)

Forked to set mysqld variable to:
```
max_allowed_packet = 16M
innodb_log_buffer_size = 32M
innodb_buffer_pool_size = 512M
innodb_log_file_size = 256M
```

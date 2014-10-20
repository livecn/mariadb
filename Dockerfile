FROM centos:latest
MAINTAINER Lu Yun <livecn@163.com>
RUN yum install -y mariadb mariadb-server
RUN [ -f /usr/bin/mysql_install_db ] || exit 1 >> /dev/null
RUN /usr/bin/mysql_install_db >> /dev/null
RUN chown -R mysql:mysql /var/lib/mysql/
RUN sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/my.cnf
RUN echo "/usr/bin/mysqld_safe &" > /tmp/config
RUN echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config
RUN echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\";' " >> /tmp/config
RUN bash /tmp/config
RUN rm -f /tmp/config
VOLUME ["/etc/mysql", "/var/lib/mysql"]
WORKDIR /var/lib/mysql
CMD ["mysqld_safe"]
EXPOSE 3306

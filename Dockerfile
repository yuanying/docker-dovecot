# docker build -t yuanying/dovecot .
# docker run -d --link mysql:mysql \
# -e "POSTFIX_MYSQL_PASSWORD=postfixpassword" \
# -h 'mail.fraction.jp' \
# -v /var/vmail:/var/vmail \
# -p 993:993 \
# yuanying/dovecot
#
FROM ubuntu:precise
MAINTAINER O. Yuanying "yuan-docker@fraction.jp"

ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y dovecot-core dovecot-imapd dovecot-mysql
RUN groupadd -g 1500 vmail && \
    useradd -g vmail -u 1500 vmail -d /var/vmail && \
    mkdir /var/vmail && \
    chown vmail:vmail /var/vmail

ADD dovecot/dovecot.conf        /etc/dovecot/dovecot.conf
ADD dovecot/dovecot-mysql.conf  /etc/dovecot/dovecot-mysql.conf
RUN chown root:root /etc/dovecot/*.conf

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

EXPOSE 993

CMD ["/usr/local/bin/run"]
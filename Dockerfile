FROM debian:jessie

MAINTAINER Apiki Team Maintainers "mesaque.silva@apiki.com"

ENV DEBIAN_FRONTEND noninteractive
ENV VARNISH_VERSION 6.1.1

RUN apt-get update \
	&& apt-get -y install wget build-essential python-docutils python-sphinx libncurses5-dev libncursesw5-dev pkg-config libpcre3 libpcre3-dev libedit-dev


RUN  /usr/bin/wget https://varnish-cache.org/_downloads/varnish-${VARNISH_VERSION}.tgz && tar -xzf varnish-${VARNISH_VERSION}.tgz
RUN mkdir -p /etc/varnish && cp -rf  /varnish-${VARNISH_VERSION}/* /etc/varnish && cd /etc/varnish && /etc/varnish/configure && /usr/bin/make && /usr/bin/make install
RUN rm -rf /varnish-${VARNISH_VERSION}/ /varnish-${VARNISH_VERSION}.tgz

EXPOSE 80

RUN ldconfig

CMD [ "/usr/local/sbin/varnishd",  "-F",  "-f", "/etc/varnish/default.vcl", "-s", "malloc,600m", "-p", "default_ttl=3600", "-p", "default_grace=3600" ]

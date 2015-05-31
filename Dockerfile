FROM alpine:3.2
MAINTAINER Damien DUPORTAL <damien.duportal@gmail.com>

ENV LYNIS_VERSION 2.1.0

RUN apk --update add bash curl openssl \
	&& curl -L -o /tmp/lynis.tgz \
		"https://cisofy.com/files/lynis-${LYNIS_VERSION}.tar.gz" \
	&& tar -x -z -f /tmp/lynis.tgz -C /usr/local/ \
	&& chmod a+x /usr/local/lynis/lynis \
	&& rm -rf /tmp/*

WORKDIR /app
VOLUME ["/app","/var/log","/tmp"]

ENTRYPOINT ["/usr/local/lynis/lynis"]
CMD ["--version"]

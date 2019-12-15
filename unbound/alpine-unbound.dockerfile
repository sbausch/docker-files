FROM alpine:latest
RUN apk update
RUN apk upgrade

# Timezone (TZ)
RUN apk add --no-cache tzdata
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid su-exec openrc

VOLUME /etc/unbound

RUN apk add --no-cache unbound

EXPOSE 53 53/udp

ADD https://raw.githubusercontent.com/sbausch/docker-files/master/unbound/startup.sh /home/
RUN chmod a+x /home/startup.sh
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/unbound/unbound.conf /home/unbound/

ENTRYPOINT [ "/home/startup.sh" ]

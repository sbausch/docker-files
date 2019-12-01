FROM alpine:latest
RUN apk update
RUN apk upgrade

# Timezone (TZ)
RUN apk add --no-cache tzdata
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid su-exec openrc

VOLUME /etc/nsd

RUN apk add --no-cache nsd

EXPOSE 53 53/udp

ADD https://raw.githubusercontent.com/sbausch/docker-files/master/nsd/startup.sh /home/
RUN chmod a+x /home/startup.sh
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/nsd/nsd.conf /home/nsd/
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/nsd/dnsdomain.root.zone /home/nsd/
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/nsd/nsd.conf.sample /home/nsd/
RUN mkdir -p /var/run/nsd

ENTRYPOINT [ "/home/startup.sh" ]

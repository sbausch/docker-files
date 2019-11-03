FROM alpine/alpine:latest
RUN apk update
RUN apk upgrade

# Timezone (TZ)
RUN apk add --no-cache tzdata
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid su-exec

VOLUME /etc/nsd

RUN apk add --no-cache nsd

EXPOSE 53 53/udp

RUN mkdir -p /home/nsd
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/docker-files/nsd/startup.sh /home/
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/docker-files/nsd/nsd.conf /home/nsd/
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/docker-files/nsd/dnsdomain.root.zone /home/nsd/
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/docker-files/nsd/nsd.conf.sample /home/nsd/

ENTRYPOINT [ "/home/startup.sh" ]
SHELL ["/bin/bash", "-c"]


FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates

LABEL maintainer="alturismo alturismo@gmail.com"

# Extras
RUN apk add --no-cache curl

# Timezone (TZ)
RUN apk update && apk add --no-cache tzdata
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid su-exec

# Volumes
VOLUME /config
VOLUME /root/.xteve
VOLUME /tmp/xteve

# Add ffmpeg and vlc
RUN apk add ffmpeg
RUN apk add vlc
RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc

# Add xTeve and guide2go
RUN wget https://github.com/xteve-project/xTeVe-Downloads/raw/master/xteve_linux_arm64.zip -O temp.zip; unzip temp.zip -d /usr/bin/; rm temp.zip
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/xTeVe/cronjob.sh /
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/xTeVe/entrypoint.sh /
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/xTeVe/sample_cron.txt /
ADD https://raw.githubusercontent.com/sbausch/docker-files/master/xTeVe/sample_xteve.txt /

# Set executable permissions
RUN chmod +x /entrypoint.sh
RUN chmod +x /cronjob.sh
RUN chmod +x /usr/bin/xteve

# Expose Port
EXPOSE 34400

# Entrypoint
ENTRYPOINT ["./entrypoint.sh"]

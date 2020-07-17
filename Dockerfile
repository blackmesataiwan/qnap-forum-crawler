FROM golang:1.14.6-alpine3.12

RUN apk update && \
    apk upgrade && \
    apk add --update make rsync grep ca-certificates openssl wget gcc libc-dev

WORKDIR /go_wkspc/src/github.com/dshearer
RUN wget "https://github.com/dshearer/jobber/archive/v1.4.4.tar.gz" -O jobber.tar.gz && \
    tar xzf *.tar.gz && rm *.tar.gz && mv * jobber && \
    cd jobber && \
    make check && \
    make install DESTDIR=/jobber-dist


FROM node:14.5.0-alpine3.12

WORKDIR /root

ENV TZ=Asia/Taipei

RUN apk add tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=0 /jobber-dist/usr/local/libexec/jobbermaster /usr/local/libexec/jobbermaster
COPY --from=0 /jobber-dist/usr/local/libexec/jobberrunner /usr/local/libexec/jobberrunner
COPY --from=0 /jobber-dist/usr/local/bin/jobber /usr/local/bin/jobber

COPY app-crawler/app.js .
COPY app-crawler/db.js .
COPY app-crawler/log.js .
COPY app-crawler/package.json .
COPY app-crawler/init .
COPY jobber/.jobber .
COPY jobber/jobber.conf /etc/jobber.conf

RUN npm install
RUN mkdir /usr/local/var

CMD ["/usr/local/libexec/jobbermaster"]
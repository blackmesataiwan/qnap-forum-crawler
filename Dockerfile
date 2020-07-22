# Build jobber
FROM golang:1.14.6-alpine

RUN apk update && \
    apk upgrade && \
    apk add --update make rsync grep ca-certificates openssl wget gcc libc-dev

WORKDIR /go_wkspc/src/github.com/dshearer
RUN wget "https://github.com/dshearer/jobber/archive/v1.4.4.tar.gz" -O jobber.tar.gz && \
    tar xzf *.tar.gz && rm *.tar.gz && mv * jobber && \
    cd jobber && \
    make check && \
    make install DESTDIR=/jobber-dist


# Build app
FROM node:14.5.0-alpine

# make user
ENV USERID 1100
RUN addgroup jobberuser && \
    adduser -S -u "${USERID}" -G jobberuser jobberuser && \
    mkdir -p "/var/jobber/${USERID}" && \
    chown -R jobberuser:jobberuser "/var/jobber/${USERID}"

# install jobber
ENV TZ=Asia/Taipei

RUN apk update && apk add tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=0 /jobber-dist/usr/local/libexec/jobbermaster /usr/local/libexec/jobbermaster
COPY --from=0 /jobber-dist/usr/local/libexec/jobberrunner /usr/local/libexec/jobberrunner
COPY --from=0 /jobber-dist/usr/local/bin/jobber /usr/local/bin/jobber

# install app
RUN mkdir -p "/app" && chown -R jobberuser:jobberuser "/app"
WORKDIR /app
COPY --chown=jobberuser:jobberuser . .
RUN ln -snf /app/jobber/jobber.conf /etc/jobber.conf

USER jobberuser
RUN cd app-crawler && npm install

CMD ["/usr/local/libexec/jobberrunner", "-u", "/var/jobber/1100/cmd.sock", "/app/jobber/jobber"]
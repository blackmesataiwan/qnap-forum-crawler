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
#ENV USERID 1100
#RUN addgroup jobberuser && \
#    adduser -S -u "${USERID}" -G jobberuser jobberuser && \
#    mkdir -p "/var/jobber/${USERID}" && \
#    chown -R jobberuser:jobberuser "/var/jobber/${USERID}"

# install jobber
ENV TZ=Asia/Taipei

RUN apk update && apk add tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=0 /jobber-dist/usr/local/libexec/jobbermaster /usr/local/libexec/jobbermaster
COPY --from=0 /jobber-dist/usr/local/libexec/jobberrunner /usr/local/libexec/jobberrunner
COPY --from=0 /jobber-dist/usr/local/bin/jobber /usr/local/bin/jobber

# install app
#RUN mkdir -p "/app" && chown -R jobberuser:jobberuser "/app"
RUN mkdir -p "/app" && mkdir -p "/var/jobber/0"
WORKDIR /app
#COPY --chown=jobberuser:jobberuser . .
COPY . .
RUN ln -snf /app/jobber/jobber.conf /etc/jobber.conf
RUN chmod 644 /app/jobber/jobber

#USER jobberuser
RUN cd app-crawler && npm install

ENV DEBUG=0
ENV DB_HOST=
ENV DB_USER=
ENV DB_PWD=
ENV DB=

#CMD ["/usr/local/libexec/jobberrunner", "-u", "/var/jobber/${USERID}/cmd.sock", "/app/jobber/jobber"]
CMD ["/usr/local/libexec/jobberrunner", "-u", "/var/jobber/0/cmd.sock", "/app/jobber/jobber"]
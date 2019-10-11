FROM ubuntu:16.04 as build

MAINTAINER Tom Llewellyn-Smith <tom@stellar.org>

ADD . /app/src

WORKDIR /app/src

RUN apt-get update && apt-get install -y curl git make build-essential && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn && \
    /app/src/jenkins.bash

FROM nginx:1.17

COPY --from=build /app/src/.tmp/webpacked/* /usr/share/nginx/html/account-viewer/

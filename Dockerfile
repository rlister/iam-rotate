FROM alpine:3.6

RUN apk update && \
    apk upgrade && \
    apk add bash build-base ca-certificates ruby ruby-json ruby-dev ruby-io-console ruby-bundler && \
    rm -rf /var/cache/apk/*

RUN gem install bundler --no-rdoc --no-ri

## cache the bundle
WORKDIR /app
ADD Gemfile* /app/
RUN bundle install

ADD rotate.rb /app/

CMD ["bundle", "exec", "./rotate.rb"]
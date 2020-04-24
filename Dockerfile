# Usage:
# docker volume create pgdata
# docker volume create gems
# docker-compose up
# docker-compose exec web bundle exec rake db:create db:schema:load ffcrm:demo:load

FROM ruby:2.7 AS covidledger_base

LABEL author="Ideacrew"

ENV HOME /covidledger

RUN mkdir -p $HOME

WORKDIR $HOME

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

ADD . $HOME
RUN apt-get update && \
    apt-get -yq dist-upgrade && \
    apt-get install -y imagemagick tzdata build-essential nodejs && \
    apt-get autoremove -y && \ 
    cp config/database.postgres.docker.yml config/database.yml && \
    npm install --global yarn && \
    yarn install && \
    bundle config set deployment 'true' && \
    bundle install 

FROM covidledger_base as covidledger

RUN bundle exec rails assets:precompile


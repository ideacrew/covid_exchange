# Usage:
# docker volume create pgdata
# docker volume create gems
# docker-compose up
# docker-compose exec web bundle exec rake db:create db:schema:load ffcrm:demo:load

FROM ruby:2.7

LABEL author="Ideacrew"

ENV HOME /home/app

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
	bundle install && \
	bundle exec rails assets:precompile

CMD ["bundle","exec","rails","s","-b","0.0.0.0"]

EXPOSE 3000

# # Usage:
# # docker volume create pgdata
# # docker volume create gems
# # docker-compose up
# # docker-compose exec web bundle exec rake db:create db:schema:load ffcrm:demo:load assets:precompile

# FROM phusion/passenger-ruby24
# MAINTAINER Steve Kenworthy

# ENV HOME /home/app

# ADD . /home/app
# WORKDIR /home/app

# RUN apt-get update \
#   && apt-get install -y imagemagick firefox tzdata \
#   && apt-get autoremove -y \
#   && cp config/database.postgres.docker.yml config/database.yml \
#   && chown -R app:app /home/app \
#   && rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default \
#   && cp .docker/nginx/sites-enabled/ffcrm.conf /etc/nginx/sites-enabled/ffcrm.conf \
#   && bundle install --deployment

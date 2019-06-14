FROM ruby:2.6.3

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -qq -y --no-install-recommends \
        nodejs yarn build-essential postgresql-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle config --global frozen 1
RUN bundle install --without development test

COPY package.json yarn.lock postcss.config.js babel.config.js /usr/src/app/
RUN yarn && yarn cache clean


COPY . /usr/src/app

ARG RAILS_MASTER_KEY

RUN RAILS_ENV=production RAILS_MASTER_KEY=$RAILS_MASTER_KEY bundle exec rake assets:precompile && rm -rf node_modules && rm -rf tmp/cache

EXPOSE 3000

CMD exec bundle exec puma -p 3000 -e "$RAILS_ENV" -C config/puma.rb


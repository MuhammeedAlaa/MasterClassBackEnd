FROM ruby:3.0.0


RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    apt-get update -qq && \
    apt-get install -y vim nodejs sqlite3 libsqlite3-dev yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /masterclass-backend
WORKDIR /masterclass-backend

COPY Gemfile* package.json yarn.lock /app/

RUN gem install bundler && \
    bundle install

COPY . /masterclass-backend
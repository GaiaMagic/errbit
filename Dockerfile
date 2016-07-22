FROM ruby:2.3.0

WORKDIR /errbit

RUN echo Asia/Hong_Kong > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN (echo "deb http://mirrors.aliyun.com/debian jessie main" && \
    echo "deb http://mirrors.aliyun.com/debian jessie-updates main" && \
    echo "deb http://mirrors.aliyun.com/debian-security/ jessie/updates main") \
    > /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends locales locales-all

RUN export LANGUAGE=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8 && \
    locale-gen en_US.UTF-8 && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 NOKOGIRI_USE_SYSTEM_LIBRARIES=true RAILS_ENV=production

RUN bundle config mirror.https://rubygems.org https://ruby.taobao.org

ADD Gemfile Gemfile.lock /errbit/

RUN bundle install -j4 --without development test

ADD . /errbit/

RUN bundle exec rake assets:precompile

CMD bundle exec rake db:migrate db:mongoid:remove_undefined_indexes db:mongoid:create_indexes && bundle exec rails server -b 0.0.0.0

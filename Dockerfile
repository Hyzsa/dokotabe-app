FROM ruby:2.7.5

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn postgresql-client

ENV RAILS_ROOT /app

# Railsアプリのルートディレクトリ作成
WORKDIR $RAILS_ROOT
# srcフォルダをルートディレクトリにコピー
COPY ./src $RAILS_ROOT
# bundle install
RUN bundle config --local set path 'vendor/bundle' && bundle install

COPY start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["sh", "/start.sh"]

# コンテナを起動するたびに実行されるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

FROM ruby:3.4.11-slim AS base

WORKDIR /app
ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH=/usr/local/bundle \
    RAILS_LOG_TO_STDOUT=true

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential default-libmysqlclient-dev pkg-config curl && \
    rm -rf /var/lib/apt/lists/*

FROM base AS build

COPY Gemfile Gemfile.lock ./
RUN bundle install && bundle exec bootsnap precompile --gemfile

COPY . .
RUN SECRET_KEY_BASE=build-placeholder bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE=build-placeholder bundle exec rails tailwindcss:build && \
    SECRET_KEY_BASE=build-placeholder bundle exec rails assets:precompile

FROM base AS production

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app
COPY bin/docker-entrypoint /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint && \
    useradd --create-home --shell /bin/bash rails && \
    mkdir -p /app/tmp/pids /app/tmp/cache /app/tmp/sockets /app/log /app/storage && \
    chown -R rails:rails /app

USER rails
EXPOSE 3000
ENTRYPOINT ["docker-entrypoint"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

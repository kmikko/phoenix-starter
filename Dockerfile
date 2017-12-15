# https://hub.docker.com/_/elixir/
FROM elixir:alpine

# Install Node.js
RUN apk --update add inotify-tools \
    nodejs --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/


# Create work directory
ENV APP_DIR /app
RUN mkdir $APP_DIR
WORKDIR $APP_DIR

# Install HEX package manager and rebar to build Erlang packages
RUN mix local.hex --force && mix local.rebar --force

# Install Phoenix
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force

# Copy mix files
ADD mix.* $APP_DIR/

# Install & compile all  dependencies
RUN mix deps.get && mix deps.compile

ADD assets/package.json assets/
RUN cd assets && npm install

# Copy all application files
ADD . $APP_DIR

# TODO: Copy package JSON
RUN cd assets && node node_modules/brunch/bin/brunch build


EXPOSE 400

# Run Ecto migrations and Phoenix server as an initial command
#CMD mix do ecto.migrate, phx.server



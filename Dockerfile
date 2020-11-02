FROM ruby:2.7.1

ARG USER_ID
ARG GROUP_ID

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       nodejs \
                       yarn

RUN mkdir /app
ENV APP_ROOT /app
ENV BUNDLE_PATH /home/appuser/.local/bundle
WORKDIR $APP_ROOT

RUN groupadd appuser && useradd -g appuser -m -d /home/appuser appuser

RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    usermod -u $USER_ID appuser &&\
    groupmod -g $GROUP_ID appuser\
;fi

COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install

COPY . $APP_ROOT

RUN chown -R appuser:appuser $APP_ROOT $BUNDLE_PATH

USER appuser

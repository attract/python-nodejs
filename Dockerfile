FROM python:3.9.18-slim-bookworm

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    TZ=UTC

ARG SERVER_TYPE
ARG RUN_TESTS

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends \
        gcc \
        gettext \
        postgresql-server-dev-all \
        libgeos-dev \
        libgdal-dev \
        libmagic-dev \
        zlib1g zlib1g-dev \
        postgresql-client \
        git \
        curl \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-use-pep517 --upgrade pip

# install poetry
RUN pip install poetry==1.3.2

# Install nodejs
ENV NODE_VERSION=14.0.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

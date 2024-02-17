FROM docker.io/library/ubuntu:jammy-20240212

USER root

ARG TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# コンテナで動かすのに特有?の設定が追加されているので消しておく
RUN rm /etc/apt/apt.conf.d/docker-*

RUN apt-get -y update && \
    yes | unminimize && \
    apt-get install -y --no-install-recommends \
    command-not-found \
    man-db man \
    nano vim \
    git \
    curl wget \
    sudo && \
    # Cleanup \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# create user
ARG USER_NAME=wsl-user
ARG USER_UID=1000
ARG PASSWD=password
RUN useradd -m -s /bin/zsh -u ${USER_UID} ${USER_NAME} && \
    echo "${USER_NAME}:${PASSWD}" | chpasswd && \
    echo "${USER_NAME} ALL=(ALL) ALL" >> /etc/sudoers

# WSL2 setting
COPY wsl.conf /etc/wsl.conf

# (補足)例えば作成済みの設定ファイルを追加する場合は以下のような感じ
# COPY --chown=${USER_NAME}:${USER_NAME} .bashrc /home/${USER_NAME}/.bashrc

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
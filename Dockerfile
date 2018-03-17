FROM debian:jessie

LABEL maintainer="Gius. Camerlingo <gcamerli@gmail.com>"

# Add name to Docker image
ENV NAME=hscore

# Set environment variables
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive
ENV RUNLEVEL=1

# Update source list
RUN echo "deb http://deb.debian.org/debian jessie main contrib non-free" > /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org jessie/updates main contrib non-free" >> /etc/apt/sources.list

# Update Debian
RUN apt-get update
RUN apt-get install -y \
  apt-utils \
  xterm \
  build-essential \
  libtool \
  curl \
  wget \
  vim \
  git \
  openssh-client \
  krb5-user \
  sudo \
  zsh

# Set no password for docker user
RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create a new user
RUN useradd -ms /bin/zsh docker
USER docker
ENV HOME=/home/docker
WORKDIR $HOME

# Clone and set kerberos
RUN git clone --progress --verbose https://github.com/gcamerli/42krb.git kerberos
WORKDIR $HOME/kerberos/script
RUN sh run.sh
WORKDIR $HOME

# Setup ohmyzsh
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Setup haskell core
RUN sudo apt-get install -y haskell-platform

# Copy test file
COPY ./hello.hs .

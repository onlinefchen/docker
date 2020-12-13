FROM ubuntu:20.04

COPY sources.list.save /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y \
    ctags cscope vim git global clang clang-format \
    gcc make libncurses5-dev openssl libssl-dev \
    build-essential \
    libc6-dev \
    bison \
    sudo \
    flex \
    libelf-dev \
    openssh-client openssh-server openssh-sftp-server

# linux kernel build use
RUN apt-get install -y build-essential git wget curl libncurses5-dev

# add user puck
RUN adduser --disabled-password --gecos '' puck
RUN adduser puck sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER puck
WORKDIR /home/puck

# user config
RUN echo "set completion-ignore-case on" > .inputrc
RUN echo "alias code='cd ~/work'" >> .bashrc
RUN mkdir -p .vim
RUN mkdir bin
COPY cs bin
COPY host.pub host.pub
COPY vimrc .vim/vimrc
RUN git config --global user.name "Chen Feng"
RUN git config --global user.email "puck.chen@foxmail.com"
RUN git config --global core.editor vim
RUN cat host.pub .ssh/authorized_keys
RUN rm host.pub
RUN git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall
RUN vim +PluginInstall +qall

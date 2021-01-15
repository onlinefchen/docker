FROM ubuntu:20.04
#FROM launcher.gcr.io/google/ubuntu1804

COPY sources.list.save /etc/apt/sources.list
COPY hostname /etc/hostname

RUN echo "ubuntu" > /etc/host

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y \
    ctags cscope vim git global clang clang-format \
    gcc make libncurses5-dev openssl libssl-dev \
    build-essential \
    git ccache automake flex lzop bison \ 
    gperf build-essential zip curl \
    zlib1g-dev \
    g++-multilib \
    libxml2-utils bzip2 libbz2-dev \ 
    libbz2-1.0 libghc-bzlib-dev  \
    squashfs-tools pngcrush \
    schedtool dpkg-dev liblz4-tool \
    make optipng maven libssl-dev \
    pwgen libswitch-perl policycoreutils  \
    minicom libxml-sax-base-perl \
    libxml-simple-perl bc\
    libc6-dev \
    bison \
    cpio \
    sudo \
    flex \
    libpixman-1-0 \
    libsdl2-2.0-0 \
    libglib2.0 \
    libssl-dev \
    strace \
    libelf-dev \
    net-tools

RUN apt-get update && apt-get install -y \
    screen python git openjdk-8-jdk android-tools-adb bc bison \
    build-essential curl flex g++-multilib gcc-multilib gnupg gperf imagemagick lib32ncurses-dev \
    lib32readline-dev lib32z1-dev  liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev \
    libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc yasm zip zlib1g-dev \
    libtinfo5 libncurses5 

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
RUN echo ''
RUN mkdir -p .vim
RUN mkdir bin
COPY cs bin
COPY host.pub host.pub
COPY vimrc .vim/vimrc
RUN git config --global user.name "Chen Feng"
RUN git config --global user.email "puck.chen@foxmail.com"
RUN git config --global core.editor vim
RUN mkdir -p .ssh
RUN cat host.pub >> .ssh/authorized_keys
RUN rm host.pub
RUN git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall
RUN vim +PluginInstall +qall

# alias mydocker="docker run -d --name mydocker -it -v /Users/fengchen/code:/home/puck/work mydocker -p -p 2022:22"
# alias linux="docker exec -it mydocker bash"
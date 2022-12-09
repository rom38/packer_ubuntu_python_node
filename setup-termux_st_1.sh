#!/bin/bash -eux



# apt-get  install --yes --no-install-recommends curl


PACKAGES=" gnupg lzip unzip jq curl curl neovim python3-neovim git tar openssl rsync bash-completion wget \
autoconf autogen automake autopoint bison flex g++ g++-multilib gawk gettext gperf intltool libglib2.0-dev libltdl-dev libtool-bin m4 \
pkg-config scons help2man libtool make pkg-config texinfo ncdu htop lua5.2 lua5.3 python3-pip make build-essential \
libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"

apt-get  install --yes --no-install-recommends $PACKAGES

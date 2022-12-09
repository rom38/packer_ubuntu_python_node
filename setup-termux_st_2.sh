#!/bin/bash -eux



# apt-get  install --yes --no-install-recommends curl


PACKAGES=" gnupg lzip unzip jq curl curl neovim python3-neovim git tar openssl rsync bash-completion wget \
autoconf autogen automake autopoint bison flex g++ g++-multilib gawk gettext gperf intltool libglib2.0-dev libltdl-dev libtool-bin m4 \
pkg-config scons help2man libtool make pkg-config texinfo ncdu htop lua5.2 lua5.3 python3-pip make build-essential \
libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"

# # Tier 1: requirements for the core build scripts in scripts/build/.
# # PACKAGES+=" clang"				# Required for termux-elf-cleaner and C/C++ packages.
# PACKAGES+=" gnupg"				# Used in termux_get_repo_files() and build-package.sh.
# PACKAGES+=" lzip"				# Used by tar to extract *.tar.lz source archives.
# # PACKAGES+=" patch"				# Used for applying patches on source code.
# # PACKAGES+=" python"				# Used buildorder.py core script.
# PACKAGES+=" unzip"				# Used to extract *.zip source archives.
# PACKAGES+=" jq"					# Used for parsing repo.json.
# PACKAGES+=" curl"
# PACKAGES+=" neovim"
# PACKAGES+=" python3-neovim"
# PACKAGES+=" git"
# PACKAGES+=" tar"
# PACKAGES+=" openssl"
# # Needed by dgsh
# PACKAGES+=" rsync"
# PACKAGES+=" bash-completion"

# # Needed by megacmd
# PACKAGES+=" wget"

# # Tier 2: requirements for building many other packages.
# # Used by common build systems.
# PACKAGES+=" autoconf"
# PACKAGES+=" autogen"
# PACKAGES+=" automake"
# PACKAGES+=" autopoint"
# PACKAGES+=" bison"
# PACKAGES+=" flex"
# PACKAGES+=" g++"
# PACKAGES+=" g++-multilib"
# PACKAGES+=" gawk"
# PACKAGES+=" gettext"
# PACKAGES+=" gperf"
# PACKAGES+=" intltool"
# PACKAGES+=" libglib2.0-dev"
# PACKAGES+=" libltdl-dev"
# PACKAGES+=" libtool-bin"
# PACKAGES+=" m4"
# PACKAGES+=" pkg-config"
# PACKAGES+=" scons"
# # PACKAGES+=" golang"
# PACKAGES+=" help2man"
# PACKAGES+=" libtool"
# PACKAGES+=" m4"
# PACKAGES+=" make"			# Used for all Makefile-based projects.
# PACKAGES+=" ninja"			# Used by default to build all CMake projects.
# # PACKAGES+=" perl"
# PACKAGES+=" pkg-config"
# PACKAGES+=" protobuf"
# # PACKAGES+=" python2"
# # PACKAGES+=" rust"
# PACKAGES+=" texinfo"
# # PACKAGES+=" valac"
# # PACKAGES+=" gh"
# PACKAGES+=" ncdu"
# PACKAGES+=" htop"

# # Needed by package vlc.
# PACKAGES+=" lua5.2"

# # Needed by package luarocks.
# PACKAGES+=" lua5.3"

# # pyenv
# PACKAGES+=" python3-pip make build-essential libssl-dev zlib1g-dev" 
# PACKAGES+=" libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm" 
# PACKAGES+=" ibncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"

#apt-get -y update
apt-get  install --yes --no-install-recommends $PACKAGES

# apt update
# apt dist-upgrade -y
# apt install -y $PACKAGES


#!/bin/bash

# install nvm

export NODE_VERSION="18.12.1"

export PNPM_HOME=$HOME_DIR/.pnpm
export PATH=$HOME_DIR/.nvm/versions/node/v${NODE_VERSION}/bin:$HOME_DIR/.yarn/bin:${PNPM_HOME}:$PATH

curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | PROFILE=/dev/null bash
bash -c ". .nvm/nvm.sh \
        && nvm install v${NODE_VERSION} \
        && nvm alias default v${NODE_VERSION} \
        && npm install -g typescript yarn pnpm node-gyp"
echo ". ~/.nvm/nvm-lazy.sh"  >> $HOME_DIR/.bashrc
# above, we are adding the lazy nvm init to .bashrc, because one is executed on interactive shells, the other for non-interactive shells (e.g. plugin-host)
cp  $HOME_DIR/nvm-lazy.sh $HOME_DIR/.nvm/nvm-lazy.sh
chown vagrant:vagrant $HOME_DIR/.nvm/nvm-lazy.sh

##################################

# install github cli

#type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 
chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg 
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null 
apt update 
apt install gh -y


##################################

# install pyenv

export PYTHON_VERSION="3.9"
export PATH="$HOME_DIR/.pyenv/bin:$HOME_DIR/.pyenv/shims:$PATH"
# export PIPENV_VENV_IN_PROJECT=true
export PYENV_ROOT="$HOME_DIR/.pyenv"

# RUN sudo install-packages \
            # # Install python compiling dependencies for pyenv
            # python3-pip make build-essential libssl-dev zlib1g-dev \
            # libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
            # libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    # Install PYENV
curl -fsSL https://pyenv.run | bash 
pyenv update 
pyenv install ${PYTHON_VERSION} 
pyenv global ${PYTHON_VERSION} 
# Install additional python packages
python3 -m pip install --no-cache-dir --upgrade pip 
rm -rf /tmp/*


echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME_DIR/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME_DIR/.bashrc
echo 'eval "$(pyenv init -)"' >> $HOME_DIR/.bashrc

###################################

# install gitui

curl -s curl -s https://api.github.com/repos/extrawurst/gitui/releases/latest | grep -wo "https.*linux.*gz" | wget -qi -
tar xzvf gitui-linux-musl.tar.gz
rm gitui-linux-musl.tar.gz
chmod +x gitui
mv gitui /usr/local/bin


####################################
# install redis

apt install lsb-release

curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list

apt-get update
apt-get -y install redis 


#################################

# remove snap
snap remove $(snap list | awk '!/^Name|^core|^snapd/ {print $1}')
snap remove $(snap list | awk '!/^Name|^snapd/ {print $1}')
snap remove snapd
#apt remove --purge -y snapd gnome-software-plugin-snap

systemctl stop snapd
apt remove --purge --assume-yes snapd gnome-software-plugin-snap
rm -rf ~/snap
rm -rf /snap
rm -rf /var/cache/snapd 
rm -rf /var/snap
rm -rf /var/lib/snapd
rm -rf /usr/lib/snapd


# Stop it from being reinstalled by 'mistake' when installing other packages
cat << EOF | sudo tee -a /etc/apt/preferences.d/no-snap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

sudo chown root:root /etc/apt/preferences.d/no-snap.pref

# done
echo "Snap removed"

################################
echo "remove docs packages"
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-doc$' \
    | xargs apt-get -y purge;

echo "autoremoving packages and cleaning apt data"
apt-get -y autoremove;
apt-get -y clean;

echo "remove /usr/share/doc/"
rm -rf /usr/share/doc/*

echo "remove /var/cache"
find /var/cache -type f -exec rm -rf {} \;

echo "truncate any logs that have built up during the install"
find /var/log -type f -exec truncate --size=0 {} \;

echo "blank netplan machine-id (DUID) so machines get unique ID generated on boot"
truncate -s 0 /etc/machine-id

echo "remove the contents of /tmp and /var/tmp"
rm -rf /tmp/* /var/tmp/*

echo "force a new random seed to be generated"
rm -f /var/lib/systemd/random-seed

echo "clear the history so our install isn't there"
rm -f /root/.wget-hsts
export HISTSIZE=0 
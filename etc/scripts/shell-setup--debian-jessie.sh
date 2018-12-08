#!/bin/bash

#
# Usage on debian:jessie based Docker env:
#
# 1. Run this script from inside the container, as root.
# 2. Switch to the jhds_rsc account:
#    su jedihe_docker
# 3. Install drupal/coder globally for jhds_rsc:
#    ~/.composer/vendor/bin/phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer
#

# Set up Vim built with Python 2 support (vim-nox for debian jessie)
apt-get update
apt-get install -y vim-nox

USERNAME='jedihe_docker'

/usr/sbin/groupadd -g $HOST_UID $USERNAME
/usr/sbin/useradd -u $HOST_UID -g $HOST_UID -m $USERNAME
#/bin/echo '$USERNAME:$USERNAME' | /usr/sbin/chpasswd -

mkdir -p /home/$USERNAME/.vim/autoload /home/$USERNAME/.vim/bundle
curl -LSso /home/$USERNAME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd /home/$USERNAME/.vim/bundle/
rm -rf /home/$USERNAME/.vim/bundle/*
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/kien/ctrlp.vim.git
git clone https://github.com/scrooloose/syntastic.git
git clone https://github.com/Lokaltog/vim-powerline.git
git clone https://github.com/ap/vim-css-color.git
git clone https://github.com/mattn/emmet-vim.git
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/godlygeek/tabular.git
git clone https://github.com/honza/vim-snippets.git
git clone https://github.com/joonty/vdebug.git
cd vdebug && git checkout tags/v1.5.2 && cd .. #Latest version with python2 support
git clone https://github.com/majutsushi/tagbar.git
git clone https://github.com/joonty/vim-taggatron
git clone https://github.com/shawncplus/phpcomplete.vim
git clone --branch=update-phpctags-0.6.0 https://github.com/jedihe/tagbar-phpctags.vim
chown -R $USERNAME:$USERNAME /home/$USERNAME/.vim
make --directory=/home/$USERNAME/.vim/bundle/tagbar-phpctags.vim
chown -R $USERNAME:$USERNAME /home/$USERNAME/.vim
curl -LSso /home/$USERNAME/.vimrc https://raw.githubusercontent.com/jedihe/drupal-dev-vm/provider-docker/dotfiles/.vimrc-supercharged
chown $USERNAME:$USERNAME /home/$USERNAME/.vimrc

# Set up Patched Ctags
apt-get install automake -y
mkdir /home/$USERNAME/src
cd /home/$USERNAME/src
cp /home/$USERNAME/.vim/bundle/phpcomplete.vim/misc/ctags-5.8_better_php_parser.tar.gz ctags-5.8_better_php_parser.tar.gz
tar xvf ctags-5.8_better_php_parser.tar.gz
cd ctags
autoreconf -fi
./configure
make -j $(nproc) && make install

# Set up TMux
apt-get install -y tmux sudo
curl -LSso /home/$USERNAME/.tmux.conf https://raw.githubusercontent.com/jedihe/drupal-dev-vm/provider-docker/dotfiles/.tmux.conf-supercharged

# Set up ZSh
apt-get install -y zsh netcat
cd /home/$USERNAME
git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh
chown -R $USERNAME:$USERNAME .oh-my-zsh
(printf "$USERNAME\n" && cat) | chsh -s /bin/zsh $USERNAME
curl -LSso /home/$USERNAME/.zshrc https://raw.githubusercontent.com/jedihe/drupal-dev-vm/provider-docker/dotfiles/.zshrc-supercharged

# Set up Git
curl -LSso /home/$USERNAME/.gitconfig https://raw.githubusercontent.com/jedihe/machine-provisioner/base/puppet/modules/miscfiles/files/.gitconfig
#sed -i "s/jedihe@gmail\.com/jedihe@work\.com/g" /home/$USERNAME/.gitconfig

# Set up Python pip
apt-get install -y python-pip
easy_install pip

# Install some misc tools
apt-get install -y unzip patch pv

# Enable aliases for Coding Standards tooling.
echo "source /mnt/etc/bashrc" >> /home/$USERNAME/.zshrc

runuser -l $USERNAME -c "composer global require drupal/coder"
runuser -l $USERNAME -c "/home/$USERNAME/.composer/vendor/bin/phpcs --config-set installed_paths /home/$USERNAME/.composer/vendor/drupal/coder/coder_sniffer"

mkdir -p /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
cp /root/.ssh/id_rsa /home/$USERNAME/.ssh/id_rsa
chown -R $USERNAME:$USERNAME /home/$USERNAME

#!/bin/bash
# Defining the shell path and global variables 
SHELL_PATH=$(readlink -f $0 | xargs dirname)
source ${SHELL_PATH}/bin/global.sh

info "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

info "Turning analytic off for Homebrew "
brew analytics off
info "Checking if homebrew is installed correctly."
brew doctor

info "Installing Text Editors"
brew cask install homebrew/cask/textmate
brew install neovim

brew install python
brew install zsh
brew install exa

brew cask install amethyst

info "Setting ZSH Shell, Scripts and Neovim"
cat ${SHELL_PATH}/etc/zshrc | sudo tee -a /etc/zshenv 
mkdir -p ${HOME}/.config
ln -s ${SHELL_PATH}/bin $HOME/.config/bin
ln -s ${SHELL_PATH}/zsh $HOME/.config/zsh
ln -s ${SHELL_PATH}/nvim $HOME/.config/nvim
ln -s ${SHELL_PATH}/alacritty ${HOME}/.config/alacritty

info "Changing the shell to ZSH"
sudo chsh -s /usr/local/bin/zsh ${USER}
sudo chmod -R 755 /usr/local/share/zsh
sudo chmod -R 755 /usr/local/share/zsh/site-functions

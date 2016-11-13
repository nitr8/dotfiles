#!/usr/bin/env bash

# Install if we don't have it
if test ! $(which brew); then
	echo "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	# Disable analytics
	brew analytics off
fi

# Update homebrew recipes
brew update

# taps
brew tap caskroom/cask
brew tap caskroom/fonts
brew tap caskroom/versions

# Upgrade any formulas.
brew upgrade

# Formulas
formulas=(
	coreutils
	findutils
	dark-mode
	lynx
	nmap
	mas
	tree
)

echo "installing formulas..."
brew install ${formulas[@]}

brew install wget --with-iri
brew install vim --with-override-system-vi
brew install homebrew/dupes/screen

# Applications
apps=(
	1password
	sublime-text
)
# Install apps to /Applications - default is: /Users/$user/Applications
echo "installing Applications..."
brew cask install --appdir="/Applications" ${apps[@]}
#export HOMEBREW_CASK_OPTS="--appdir=/Applications"

#brew cask alfred link

# fonts
fonts=(
  font-m-plus
  font-clear-sans
  font-roboto
)

# install fonts
echo "installing fonts..."
brew cask install ${fonts[@]}

# Remove outdated versions from the cellar.
brew cleanup && brew cask cleanup
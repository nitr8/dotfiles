#!/usr/bin/env bash

# Install if we don't have it
if test ! $(which brew); then
	echo "Installing homebrew..."

INSTALL_PATH="${HOME}/Downloads"
INSTALL_PATH_XCODE="${INSTALL_PATH}/apple.com"

  if [ ! -d "${INSTALL_PATH_XCODE}" ]; then
    mkdir -p "${INSTALL_PATH_XCODE}"
  fi

  if [ ! -f "${INSTALL_PATH_XCODE}/CLTools_Executables.pkg" ] \
    || [ ! -f "${INSTALL_PATH_XCODE}/DevSDK_OSX1012.pkg" ]; then
    cd "${INSTALL_PATH_XCODE}" \
      && curl --compressed --location --silent \
      "https://swscan.apple.com/content/catalogs/others/index-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz" \
      | sed -n \
        -e "s/^.*<string>\(.*CLTools_Executables.pkg\).*/\1/p" \
        -e "s/^.*<string>\(.*DevSDK_OSX1012.pkg\).*/\1/p" \
      | tail -n 2 \
      | xargs -L 1 curl --compressed --location --remote-name
  fi

  if [ -f "${INSTALL_PATH_XCODE}/CLTools_Executables.pkg" ] \
    && [ -f "${INSTALL_PATH_XCODE}/DevSDK_OSX1012.pkg" ]; then
    sudo installer -pkg "${INSTALL_PATH_XCODE}/CLTools_Executables.pkg" -target /
    sudo installer -pkg "${INSTALL_PATH_XCODE}/DevSDK_OSX1012.pkg" -target /
  fi


	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	# Disable analytics
	brew analytics off
	# Update homebrew recipes
	brew update
	brew doctor
fi

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
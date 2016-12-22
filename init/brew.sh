#!/usr/bin/env bash

#MAC_NAME="mp-odin"
MAC_NAME="mpb-odin"
#MAC_NAME="mb-odin"

LF="tee -a ${HOME}/brew.log"
LOG="echo $(date +"%T") - "

$LOG "Install homebrew if we don't have it" | $LF
if test ! $(which brew); then
  $LOG "Installing homebrew..." | $LF

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


  $LOG "Fetching and installing homebrew"|  $LF
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  $LOG "Disable analytics" | $LF
  brew analytics off 2>&1 | $LF

  $LOG "Update homebrew recipes" | $LF
  brew update 2>&1 | $LF
  brew doctor 2>&1 | $LF

fi

$LOG "Tapping casks" | $LF
brew tap caskroom/cask 2>&1 | $LF
brew tap caskroom/fonts 2>&1 | $LF
brew tap caskroom/versions 2>&1 | $LF

# Upgrade any formulas.
brew upgrade 2>&1 | $LF

$LOG "installing formulas..." | $LF
formulas=(
  coreutils
  findutils
  dark-mode
  figlet
  lynx
  nmap
  mas
  tree
  wget
)
brew install ${formulas[@]} 2>&1 | $LF

$LOG "installing Applications..." | $LF
apps=(
  1password
  alfred
  appcleaner
  calibre
  devonthink-pro-office
  daisydisk
  docker-beta
  dropbox
  google-chrome-beta
  github-desktop
  kaleidoscope
  kitematic
  lingon-x
  little-snitch
  microsoft-lync
  microsoft-office
  royal-tsx
  skype
  slack-beta
  sonos
  soundmate
  stretchly
  sublime-text
  teamviewer
  tunnelblick
  visual-studio-code-insiders
)
brew cask install --appdir="/Applications" ${apps[@]} 2>&1 | $LF

$LOG "installing fonts..." | $LF
fonts=(
  font-clear-sans
  font-consolas-for-powerline
  font-m-plus
  font-roboto
)
brew cask install ${fonts[@]} 2>&1 | $LF

$LOG "installing PHP CodeSniffer (PHPCS) and PHP Mess Detector (PHPMD)..." | $LF
# Make a bin directory in your home folder, this will stop things being overwritten
mkdir ~/bin
cd ~/bin
 
$LOG "Get the latest versions from git, make sure you have git installed" | $LF
git clone https://github.com/squizlabs/PHP_CodeSniffer.git phpcs 2>&1 | $LF
git clone git://github.com/phpmd/phpmd.git 2>&1 | $LF
 
$LOG "install composer into your bin folder" | $LF
curl -s http://getcomposer.org/installer | php 2>&1 | $LF
 
$LOG "add composer, phpcs and phpmd to your path" | $LF
sudo ln -s ~/bin/phpcs/scripts/phpcs /usr/local/bin/phpcs
sudo ln -s ~/bin/phpmd/src/bin/phpmd /usr/local/bin/phpmd
sudo ln -s ~/bin/composer.phar /usr/local/bin/composer
 
$LOG "configure phpmd" | $LF
cd ~/bin/phpmd
composer install 2>&1 | $LF

$LOG "PHP 5.3 to 7.1 for macOS..." | $LF
curl -s https://php-osx.liip.ch/install.sh | bash -s 7.1 2>&1 | $LF

$LOG "Remove outdated versions from the cellar" | $LF
brew cleanup -s 2>&1 | $LF
brew cask cleanup 2>&1 | $LF
$LOG "DONE!..." | $LF

$LOG "gen motd" | $LF
figlet $MAC_NAME >> ~/init/motd 
sudo cp -r ~/init/motd /etc/

$LOG "Set computer name (as done via System Preferences -> Sharing)" | $LF
sudo scutil --set ComputerName $MAC_NAME
sudo scutil --set HostName $MAC_NAME
sudo scutil --set LocalHostName $MAC_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $MAC_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server ServerDescription -string "macOS"
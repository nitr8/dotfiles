# nitr8's dotfiles

![Screenshot of shell](http://i.imgur.com/ZebT42u.png)

## Installation

:warning: **Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need.

To install these dotfiles:

```bash
cd; curl -O http://www.nfye.com/.files
sh .files
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository. Provided is an `~/.extra.sample` file which you can use as a template.

```bash
cp -r .extra.sample .extra && open .extra
```

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
~/dotfiles/.macos *optional
```

### Install Homebrew & formulae

When setting up a new Mac, you may want to install some common [Homebrew](http://brew.sh/) formulae

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

~/dotfiles/brew.sh
```

### Using git and the bootstrap script

You can clone the repository wherever you want. The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
cd ~
git clone https://github.com/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update:

```bash
cd ~/dotfiles
set -- -f; source bootstrap.sh
```

## Thanks to….

* [Mathias Bynens](https://mathiasbynens.be/) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)
* [Rob Wilcox](http://budeandbeyond.co.uk/) for all his help in testing / feedback
DOTFILES_DIR := $(shell echo $(HOME)/dotfiles)
SHELL        := /bin/sh
UNAME_M      := $(shell uname -m)
UNAME_S      := $(shell uname -s)
USER         := $(shell whoami)

ifeq ($(UNAME_S), Darwin)
BASE         := macos
BREWFILE     := macos/.Brewfile
ifeq ($(UNAME_M), arm64)
BREW_PREFIX  := /opt/homebrew
else ifeq ($(UNAME_M), x86_64)
BREW_PREFIX  := /usr/local
endif

else
BREW_PREFIX  := /home/linuxbrew/.linuxbrew

# ParallelCluster
ifneq ($(wildcard /etc/parallelcluster),)
BASE         := pcluster
BREWFILE     := linux/pcluster.brewfile
else ifeq ($(UNAME_S), Linux)
BASE         := linux
BREWFILE     := linux/.Brewfile
endif
endif

.PHONY: all install

all: install

install: $(BASE)

.PHONY: help usage
.SILENT: help usage

help: usage

usage:
	printf "\\n\
	\\033[1mDOTFILES\\033[0m\\n\
	\\n\
	Custom settings and configurations for Unix-like environments.\\n\
	See README.md for detailed usage information.\\n\
	\\n\
	\\033[1mUSAGE:\\033[0m make [target]\\n\
	\\n\
	  make         Install all configurations and applications.\\n\
	\\n\
	"

.PHONY: linux macos pcluster

linux: stow vim
	sudo apt install build-essential

macos: brew ohmyzsh stow vim
	bash $(DOTFILES_DIR)/macos/defaults.sh
	#bash $(DOTFILES_DIR)/macos/duti/set.sh
	$(BREW_PREFIX)/bin/stow macos
	#$(BREW_PREFIX)/bin/brew services start yabai
	#$(BREW_PREFIX)/bin/brew services start skhd
	#grep -qxF '$(BREW_PREFIX)/bin/zsh' /etc/shells || echo $(BREW_PREFIX)/bin/zsh | sudo tee -a /etc/shells
	#chsh -s $(BREW_PREFIX)/bin/zsh
	sudo ln -sf /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/bin/airport
	softwareupdate -ai

# Install iTerm shell integ first since it may write to ~/.bash_profile
pcluster: iterm stow vim
	sudo yum install -y python3-devel

.PHONY: brew stow ohmyzsh

brew:
ifeq ($(shell which brew),)
	@printf "Homebrew not detected; running install script\\n"
	NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	@printf "Homebrew already installed; skipping installation\\n"
endif
	$(BREW_PREFIX)/bin/brew analytics off
	$(BREW_PREFIX)/bin/brew update
	$(BREW_PREFIX)/bin/brew upgrade
	$(BREW_PREFIX)/bin/brew bundle --file=$(DOTFILES_DIR)/$(BREWFILE)

iterm:
	curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash

stow:
	$(BREW_PREFIX)/bin/stow curl
	$(BREW_PREFIX)/bin/stow git
	$(BREW_PREFIX)/bin/stow tmux
	$(BREW_PREFIX)/bin/stow vim
	$(BREW_PREFIX)/bin/stow zsh

vim:
	vim +PlugInstall +qall

ohmyzsh:
ifneq ($(wildcard ${HOME}/.oh-my-zsh/.*),)
	@printf "OhMyZSH already installed; skipping installation\\n"
else
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	@printf "Removing default .zshrc\\n"
	rm ${HOME}/.zshrc
endif


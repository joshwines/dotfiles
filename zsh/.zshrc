#ohmyzsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="pygmalion"
CASE_SENSITIVE="false"
plugins=(brew colorize git macos rbenv)
source $ZSH/oh-my-zsh.sh
autoload -Uz compinit
compinit

# load configs
for config (~/.zsh/*.zsh) source $config

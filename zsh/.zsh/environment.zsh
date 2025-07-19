# paths
export PATH=$HOME/bin:$PATH
export PATH=/opt/homebrew/opt/postgresql@16/bin:$PATH

if command -v /usr/libexec/java_home >/dev/null 2>&1; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  export PATH="$JAVA_HOME/bin:$PATH"
fi

# preferred editor
export EDITOR='vim';

# language
export LC_COLLATE=en_AU.UTF-8
export LC_CTYPE=en_AU.UTF-8
export LC_MESSAGES=en_AU.UTF-8
export LC_MONETARY=en_AU.UTF-8
export LC_NUMERIC=en_AU.UTF-8
export LC_TIME=en_AU.UTF-8
export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8
export LANGUAGE=en_AU.UTF-8
export LESSCHARSET=utf-8

# colors
export CLICOLOR=1
export TERM=xterm-256color

# node
export NODE_OPTIONS=--max-old-space-size=4096

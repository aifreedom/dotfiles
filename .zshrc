# Path to my oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Path to my oh-my-zsh customization.
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="aifreedom"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(brew git python encode64 dircycle rails ruby vagrant rbenv)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export EMAIL=me@xiesong.me
export GOPATH=$HOME/go
export PATH=~/bin:~/local/bin:/opt/local/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:$GOPATH/bin:$PATH
export EDITOR=vi
export ALTERNATE_EDITOR=""
export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
export LESS="- R"
export TERM=xterm-256color

# for vagrant
export ZEUSSOCK=/tmp/zeus.sock

# Example aliases
## Short commands
alias m=more
alias v=vagrant
alias ret='tmux attach'

## git
function new() {
  git checkout origin/master -b songx/$1
}

alias com='git commit -a'
alias acom='git commit -a --amend'
alias sw='git checkout'
alias st='git status'
alias br='git branch'
alias cont='git rebase --continue'
alias del='git branch -D'

## Phabricator
alias ad='arc diff'
alias af='arc feature'
alias tbgs='git grep -n'

## ag searches
AG_ARGS='--page less --smart-case'
alias ag="/usr/local/bin/ag $AG_ARGS"
# ruby
alias rbgr="/usr/local/bin/ag --ruby $AG_ARGS"
alias rbgs='rbgr --literal'
# js
alias jsgr="/usr/local/bin/ag --js $AG_ARGS"
alias jsgs="jsgr --literal"
# css
alias cssgr="ag --css $AG_ARGS"
alias cssgs="cssgr --literal"
# html
alias htmlgr="ag --html $AG_ARGS"
alias htmlgs="htmlgr --literal"
# hql
alias hqlgr="ag --hql $AG_ARGS"
alias hqlgs="hqlgr --literal"
# sql
alias sqlgr="ag --sql $AG_ARGS"
alias sqlgs="sqlgr --literal"

aman () { man -t "$@" | open -f -a Preview; }

eval "$(rbenv init -)"

# Fix for path sync in Emacs eshell using zsh
if [ -n "$INSIDE_EMACS" ]; then
  chpwd() { print -P "\033AnSiTc %d" }
  print -P "\033AnSiTu %n"
  print -P "\033AnSiTc %d"
fi

if [ -f ~/.zshrc_local ]; then
  source ~/.zshrc_local
fi

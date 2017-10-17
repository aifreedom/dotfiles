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
plugins=(brew git dircycle rails ruby rbenv gem npm)

source $ZSH/oh-my-zsh.sh

export GOPATH=$HOME/go
export JAVA7_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home
export JAVA8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home
export JAVA_HOME=$JAVA8_HOME
export PATH=~/bin:~/local/bin:/opt/local/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:$GOPATH/bin:/opt/airbnb/bin:$JAVA_HOME/bin:$PATH

# Customize to your needs...
export EMAIL=me@xiesong.me
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

alias fuck='$(thefuck $(fc -ln -1))'

alias emacs='/usr/local/Cellar/emacs/25.1/bin/emacs -nw'

## git
function new() {
  git checkout origin/master -b songx--$1
}

alias com='git commit -a'
alias acom='git commit -a --amend'
alias sw='git checkout'
alias st='git status'
alias br='git branch'
alias cont='git rebase --continue'
alias del='git branch -D'
alias cleanup='sw master && git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'
# alias gh='open https://git.musta.ch/airbnb/chef/compare/songx/yunpian-credential?expand=1'

## Phabricator
alias ad='arc diff'
# alias af='arc feature'
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

# if rbenv_loc="$(command -v "rbenv")" && [ -z "$rbenv_loc" ]; then
  eval "$(rbenv init -)"
# fi

# Fix for path sync in Emacs eshell using zsh
if [ -n "$INSIDE_EMACS" ]; then
  chpwd() { print -P "\033AnSiTc %d" }
  print -P "\033AnSiTu %n"
  print -P "\033AnSiTc %d"
fi

if [ -f ~/.zshrc_local ]; then
  source ~/.zshrc_local
fi

function gem-build-push() {
  # Replace with LDAP name if needed
  username=`whoami`
  # resolve the DNS entry only once,
  # otherwise the commands might go to different hosts
  h=$(dig +short geminabox-internal.aws.airbnb.com|head -n1|sed s'/\.$//')

  gemspec_name=`find . -name '*.gemspec' -maxdepth 1 2>/dev/null`
  if [[ -e ${gemspec_name} ]]
  then
    # Find gemspec and build it
    gem_name=`gem build ${gemspec_name} | ruby -e "puts STDIN.read.split.last"`
    # Upload to gem server and add it
    scp ${gem_name} ${username}@${h}:~ && \
      ssh ${username}@${h} "add_gem.rb ${gem_name}"
  else
    echo "Cannot find a gemspec file to run"
  fi
}

# export SSH_AUTH_SOCK=$TMPDIR/ssh-agent-$USER.sock
if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock;
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock;

function enable_nvmrc() {
    export NVM_DIR="$HOME/.nvm"
    . "/usr/local/opt/nvm/nvm.sh"
}

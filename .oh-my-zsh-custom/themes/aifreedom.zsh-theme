function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_CLEAN$ZSH_THEME_GIT_PROMPT_SUFFIX "
}

function hg_prompt_info() {
  ref=$(hg prompt '{bookmark}' 2> /dev/null) || return
  echo "$ZSH_THEME_HG_PROMPT_PREFIX${ref}$ZSH_THEME_HG_PROMPT_CLEAN$ZSH_THEME_HG_PROMPT_SUFFIX "
}

# PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
if [ -n "$INSIDE_EMACS" ]; then
    PROMPT='
`a=$?; if [ $a -ne 0 ]; then echo -n -e "%{$bg[red]$fg[white]%} $a %{$reset_color%}"; fi` %{$fg_bold[red]%}➜%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}%{$reset_color%}'
else
    PROMPT='
`a=$?; if [ $a -ne 0 ]; then echo -n -e "%{$bg[red]$fg[white]%} $a %{$BG[192]$fg[red]%}⮀"; fi`%{$BG[192]$FG[235]%} %n@%2m %{$FG[192]$BG[111]%}⮀%{$FG[235]$BG[111]%} %d %{$FG[111]$bg[black]%}⮀%{$reset_color%}
%{$fg_bold[red]%}➜%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}%{$reset_color%}'
fi

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

ZSH_THEME_HG_PROMPT_PREFIX="hg:(%{$fg[red]%}"
ZSH_THEME_HG_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_HG_PROMPT_CLEAN="%{$fg[blue]%})"

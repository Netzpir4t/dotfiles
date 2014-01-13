HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -e

zstyle :compinstall filename '/Users/lovis/.zshrc'

autoload -Uz compinit
compinit

# Colors
autoload -U colors
colors
setopt prompt_subst

# Prompt
local status_arrow="%(?,%{$fg[green]%}»%{$reset_color%},%{$fg[red]%}»%{$reset_color%})"
local status_code=" %(?,,%{$fg[red]%}%?↵%{$reset_color%})"

PROMPT='
%{$fg[green]%}%m%{$reset_color%} %~
${status_arrow} %{$reset_color%}'

RPROMPT='$(~/.bin/git-cwd-info.rb)%{$fg[blue]%}$(rbenv version-name)${status_code}%{$reset_color%}'


export PATH=/usr/local/bin:$PATH

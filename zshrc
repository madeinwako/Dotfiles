#
#source ~/.zsh.d/zshrc
#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

## Source Prezto.
#if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
#fi
#
## Customize to your needs...
#bindkey "^R" history-incremental-search-backward
#
#
#
#

#*****************************************************************************************
#
#
#
#  the explanation of each section is commented both English and Japanes as follows:
#   ## **** English comment/Japanes Comment **** ##
#   #detail in English /details in Japanese
# 
#
#*****************************************************************************************

## **** Fundamental setting/基本設定 **** ##
export LANG=ja_JP.UTF-8

## **** Complimentarity function/補完機能 **** ##

#Basic complimentrity/補完機能を有効にする
autoload -U compinit
compinit

## **** Command history /コマンド履歴**** ##
# /コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# /コマンド履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

## **** Keybiding/キーバインド **** ##

#Keybinding/キーバインドをvi風にする
bindkey -v
#vi mode の表示

function zle-line-init zle-keymap-select {

local max_path_chars=30
local user_char='➤'
local root_char='❯❯❯'
local success_color='%F{071}'
local failure_color='%F{124}'
local vcs_info_color='%F{242}'

case $KEYMAP in
vicmd)
PROMPT="%B[%F{red}NORMAL%f]:%b%B%n@%m%b
%(?.${success_color}.${failure_color})%(!.${root_char}.${user_char})%f  "
RPROMPT="%F{blue}%~%f"
;;
main|viins)
PROMPT="%B[%F{blue}INSERT%f]:%b%B%n@%m%b
%(?.${success_color}.${failure_color})%(!.${root_char}.${user_char})%f  "
RPROMPT="%F{blue}%~%f"
;;
esac
zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

## **** Options/オプション**** ##
#command correction/コマンドの訂正
setopt correct

#/移動履歴をバッファに溜める
setopt auto_pushd

#/# 補完候補を詰めて表示する
setopt list_packed 

#/補完候補表示時などにピッピとビープ音をならないように設定
setopt nolistbeep

## Prompt definition/プロンプトの設定**** ##
local max_path_chars=30
local user_char='➤'
local root_char='❯❯❯'
local success_color='%F{071}'
local failure_color='%F{124}'
local vcs_info_color='%F{242}'


# Define prompts.
#PROMPT="%(?.${success_color}.${failure_color})${SSH_TTY:+[%n@%m]}%B%${max_path_chars}<...<"'${vcs_info_msg_0_%%.}'"%<<%(!.${root_char}.${user_char})%b%f "
#RPROMPT="${vcs_info_color}"'${vcs_info_msg_1_}'"%f"

#PROMPT="
#%~
#%(?.%F{green}${1:-（ ・∀・） }%f.%F{red}${1:-(´・ω・\`%) }%f) "

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
#
#local user_success='▶ '
#local user_fault='▶ '
##local user_success='● ➤'
##local user_fault='✖ ➤'
##local user_success='（ ・∀・）'
##local user_fault='(´・ω・\`%)'
##local user_success=':-)'
##local user_fault=':-('
#local root_success='● ❯❯❯'
#local root_fault='✖ ❯❯❯'

#PROMPT="
#%B[%n@%m]:%~%b
#%(?.%F{green}${1:-%(!.${root_fault}.${user_success})}%f.%F{red}${1:-%(!.${root_fault}.${user_fault})}%f) "

PROMPT="%B[%F{blue}INSERT%f]:%b%B%n@%m%b
%(?.${success_color}.${failure_color})%(!.${root_char}.${user_char})%f  "
RPROMPT="%F{blue}%~%f"

## **** /**** ##
## **** /**** ##
## **** /**** ##
## **** /**** ##
#http://qiita.com/items/156464de9caf64338b17
#bindkey "^[u" undo
#bindkey "^[r" redo

#incremental-complete
#autoload incremental-complete-word
#zle -N incremental-complete-word
#bindkey '\C-xI' incremental-complete-word



# Incremental completion for zsh
# by y.fujii <y-fujii at mimosa-pudica.net>, public domain

#autoload -U compinit
zle -N self-insert self-insert-incr
zle -N vi-cmd-mode-incr
zle -N vi-backward-delete-char-incr
zle -N backward-delete-char-incr
zle -N expand-or-complete-prefix-incr
#compinit

bindkey -M viins '^[' vi-cmd-mode-incr
bindkey -M viins '^h' vi-backward-delete-char-incr
bindkey -M viins '^?' vi-backward-delete-char-incr
bindkey -M viins '^i' expand-or-complete-prefix-incr
bindkey -M emacs '^h' backward-delete-char-incr
bindkey -M emacs '^?' backward-delete-char-incr
bindkey -M emacs '^i' expand-or-complete-prefix-incr

setopt automenu

now_predict=0

function limit-completion
{
  if ((compstate[nmatches] <= 1)); then
    zle -M ""
  elif ((compstate[list_lines] > 6)); then
    compstate[list]=""
    zle -M "too many matches."
  fi
}

function correct-prediction
{
  if ((now_predict == 1)); then
    if [[ "$BUFFER" != "$buffer_prd" ]] || ((CURSOR != cursor_org)); then
      now_predict=0
    fi
  fi
}

function remove-prediction
{
  if ((now_predict == 1)); then
    BUFFER="$buffer_org"
    now_predict=0
  fi
}

function show-prediction
{
  # assert(now_predict == 0)
  if
    ((PENDING == 0)) &&
      ((CURSOR > 1)) &&
      [[ "$PREBUFFER" == "" ]] &&
      [[ "$BUFFER[CURSOR]" != " " ]]
  then
    cursor_org="$CURSOR"
    buffer_org="$BUFFER"
    comppostfuncs=(limit-completion)
    zle complete-word
    cursor_prd="$CURSOR"
    buffer_prd="$BUFFER"
    if [[ "$buffer_org[1,cursor_org]" == "$buffer_prd[1,cursor_org]" ]]; then
      CURSOR="$cursor_org"
      if [[ "$buffer_org" != "$buffer_prd" ]] || ((cursor_org != cursor_prd)); then
	now_predict=1
      fi
    else
      BUFFER="$buffer_org"
      CURSOR="$cursor_org"
    fi
    echo -n "\e[32m"
  else
    zle -M ""
  fi
}

function preexec
{
  echo -n "\e[39m"
}

function vi-cmd-mode-incr
{
  correct-prediction
  remove-prediction
  zle vi-cmd-mode
}

function self-insert-incr
{
  correct-prediction
  remove-prediction
  if zle .self-insert; then
    show-prediction
  fi
}

function vi-backward-delete-char-incr
{
  correct-prediction
  remove-prediction
  if zle vi-backward-delete-char; then
    show-prediction
  fi
}

function backward-delete-char-incr
{
  correct-prediction
  remove-prediction
  if zle backward-delete-char; then
    show-prediction
  fi
}

function expand-or-complete-prefix-incr
{
  correct-prediction
  if ((now_predict == 1)); then
    CURSOR="$cursor_prd"
    now_predict=0
    comppostfuncs=(limit-completion)
    zle list-choices
  else
    remove-prediction
    zle expand-or-complete-prefix
  fi
}

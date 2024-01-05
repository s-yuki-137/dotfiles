################################################## Alias
### docker-compose
alias dc='docker-compose'
alias dcb='docker-compose up --build'
alias dcd='docker-compose down'
alias dcp='docker-compose pull'

### go
alias gfa='go fmt ./...'
alias gi='goimports -w'
alias gtr='go test -run'

### terraform
alias tf='terraform'

### git
alias g='git'

### ls
alias ls='ls -apF'
alias ll='ls -ahlpFG'

### other
alias vi='vim'
alias rm='rm -i'
alias curl='curl -s'
alias grep='grep --color=auto'
alias u='cd ..'
alias :q="exit"

################################################## Option
setopt correct              #コマンドのスペルミスを指摘
setopt magic_equal_subst    #コマンドラインの引数で = 以降でも補完できる
setopt auto_pushd           #普通のcdでもスタックに入れる
setopt pushd_ignore_dups    #ディレクトリスタックの重複除去
setopt list_packed          #補完候補を詰めて表示
setopt list_types           #補完対象のファイルの末尾に識別マークをつける
setopt no_beep              #ビープ音を鳴らさない
setopt nolistbeep           #補完候補表示時にビープ音を鳴らさない
setopt brace_ccl            #(例)mkdir {1-3} で フォルダ1, 2, 3を作れる
setopt auto_param_keys      #変数名を補完する
setopt auto_param_slash     #ディレクトリ名を補完すると、末尾がスラッシュになる
setopt globdots             #ドットの指定なしで.から始まるファイルをマッチ
setopt interactive_comments #コマンドラインでも # 以降をコメントと見なす
setopt complete_in_word     #語の途中でもカーソル位置で補完

### ディレクトリ名のみでcd
setopt auto_cd
cdpath=(.. ~ ~/src)

### URL自動エスケープ
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

### ^h でホームディレクトリへ
function cdhome() {
  echo
  cd ~
  vcs_info_msg_0_=''
  zle reset-prompt
}
zle -N cdhome
bindkey '^h' cdhome

################################################## Complement
### 補完機能を使用する
autoload -Uz compinit && compinit -u

zstyle ':completion:*:default' menu select=2                                            #完候補をハイライトする
zstyle ":completion:*:commands" rehash 1                                                #rehash不要にする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'                                     #大文字、小文字を区別せず補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /us #コマンドにsudoを付けても補完

### 補完でカラーを使用する
autoload -Uz colors && colors
zstyle ':completion:*' list-colors ${LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31' #kill の候補にも色付き表示

### 補完関数の表示を強化する
zstyle ':completion:*' verbose no
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

################################################## Bindkey
bindkey -e                    #ライン操作はEmacsスタイルで行う
bindkey ^u backward-kill-line #^uで行頭まで削除

################################################## Export
export LANG=ja_JP.UTF-8
export EDITOR="vim"
export LISTMAX=1000

### colored ls
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

### Colored man
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

################################################## Prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{red}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*'     formats "%F{magenta}%c%u[%b]%f"
zstyle ':vcs_info:*'     actionformats '[%b|%a]'
precmd () { vcs_info }

PROMPT='%F{yellow}%n(%m):%f %F{cyan}%1~%f'
PROMPT=$PROMPT'%B${vcs_info_msg_0_}%b '
RPROMPT='%F{cyan}%/%f%B${vcs_info_msg_0_}%b'

################################################## History
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "

setopt append_history         #ヒストリファイルを上書きするのではなく、追加するようにする
setopt inc_append_history     #履歴をインクリメンタルに追加
setopt extended_history       #ヒストリに時刻情報もつける
setopt share_history          #履歴を共有
setopt hist_ignore_all_dups   #重複するヒストリを持たない
setopt hist_ignore_dups       #前のコマンドと同じならヒストリに入れない
setopt hist_ignore_space      #余分な空白は詰めて記録
setopt hist_expire_dups_first #履歴がいっぱいの時は最も古いものを先ず削除
setopt hist_verify            #実行するまえに必ず展開結果を確認できるようにする
setopt hist_no_store          #historyコマンドをヒストリに入れない

### ワイルドカードが使用できる履歴インクリメンタル検索で
bindkey ^r history-incremental-pattern-search-backward
bindkey ^s history-incremental-pattern-search-forward

### 入力途中の履歴補完を有効化する
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey ^p history-beginning-search-backward-end
bindkey ^n history-beginning-search-forward-end

### root doesnt history
if [ $UID = 0 ]; then
  unset HISTFILE
  SAVEHIST=0
fi

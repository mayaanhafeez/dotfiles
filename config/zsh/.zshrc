# If you come from bash you might have to change your $PATH.
 export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZDOTDIR (~/.config/zsh) is a symlink into ~/dotfiles, so keep zsh's
# generated files out of it: history in ~/.local/state, compdump in ~/.cache.
HISTFILE="$HOME/.local/state/zsh/history"
ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-${HOST%%.*}-${ZSH_VERSION}"
mkdir -p "${HISTFILE:h}" "${ZSH_COMPDUMP:h}"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls="eza --icons --color=always --group-directories-first"
alias ll="eza -alF --icons --color=always --group-directories-first"
alias la="eza -a --icons --color=always --group-directories-first"
alias grep='grep --color=auto'
alias ohaton="ssh mhafeez1@ohaton.cs.ualberta.ca"
alias cursor="open -a Cursor"
alias vim="nvim"
alias docker-down="osascript -e 'quit app \"Docker\"'"
alias brew-update="brew update && brew upgrade && brew cleanup"
# ---------- Editor ----------
export EDITOR="nvim"

alias edit_zsh='vi $ZDOTDIR/.zshrc'
alias edit_bash='vi ~/.bash_profile'
alias edit_vim='vi ~/.vimrc'
alias reload='source $ZDOTDIR/.zshrc'

# ---------- Homebrew ----------
eval "$(/opt/homebrew/bin/brew shellenv)"

# ---------- Conda (managed by 'conda init') ----------
# >>> conda initialize >>>
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <

export PATH="/Library/PostgreSQL/17/bin:$PATH"         # PostgreSQL 17
export PATH="/Applications/MacVim.app/Contents/bin:$PATH"  # MacVim
export PATH="/opt/homebrew/opt/llvm@22/bin:$PATH"         # Homebrew LLVM
export PATH="$PATH:/go/bin"
export PATH=$PATH:$(go env GOPATH)/bin



# opencode
export PATH=$HOME/.opencode/bin:$PATH

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ---------- zoxide (cd replacement) ----------
# --cmd cd makes zoxide take over `cd`; `cdi` opens the interactive picker.
eval "$(zoxide init zsh --cmd cd)"

# ---------- fzf ----------
# Key bindings (Ctrl-R history, Ctrl-T files, Alt-C cd) + **<TAB> completion
source <(fzf --zsh)
# Ctrl-F: tmux-sessionizer (pick a project in ~/personal, ~/work, ~/university)
bindkey -s ^f "tmux-sessionizer\n"
# mise shims: exported in .zprofile so non-interactive login shells get it.
# This guard covers a bare non-login `zsh`, which skips .zprofile.
[[ ":$PATH:" == *":$HOME/.local/share/mise/shims:"* ]] || export PATH="$HOME/.local/share/mise/shims:$PATH"

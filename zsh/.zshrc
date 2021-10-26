
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####
if [ -f ~/.exports ]; then
    . ~/.exports
fi

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(
    git
    asdf
)
ZSH_DISABLE_COMPFIX=true

if [ -f ~/.source ]; then
    . ~/.source
fi

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -f ~/.functions ]; then
    . ~/.functions
fi

# ZPlug stuff
zplug 'wfxr/forgit'
zplug 'dracula/zsh', as:theme
zplug load

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####


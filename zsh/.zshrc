if [ -f ~/.exports ]; then
    . ~/.exports
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

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

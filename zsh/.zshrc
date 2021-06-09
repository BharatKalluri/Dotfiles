if [ -f ~/.exports ]; then
    . ~/.exports
fi

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(
    git
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

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>/home/bharatkalluri/.zprofile

. ~/.local/bin/z.sh

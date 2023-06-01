def fedora_setup [] {
    echo 'Adding repos, updating system and installing basic software'
    sudo dnf update -y
    sudo dnf groupinstall 'Development Tools' -y
    sudo dnf install stow
    sudo dnf copr enable atim/nushell
    sudo dnf install nushell
    # add to /etc/shells
    # install chsh and setup nu as default
}

def git_setup [] {
    echo 'Setting up git'
    git config --global user.name 'Bharat Kalluri'
    git config --global user.email 'bharatkalluri@protonmail.com'
}

def rtx_setup [] {
    echo 'setting up RTX'
    curl https://rtx.pub/rtx-latest-linux-x64 > ~/.local/bin/rtx
    chmod +x ~/.local/bin/rtx
    rtx --version
    rtx use node@lts
    rtx use rust@latest
    rtx use python@latest
}

def rust_tooling [] {
    cargo install bat exa zellij ripgrep gitui
}

def flatpak_setup [] {
    echo 'flatpak setup'
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

def starship_setup [] {
    echo 'starship setup'
    curl -sS https://starship.rs/install.sh | sh
}

def docker_setup [] {
    echo 'Installing docker'
    curl -sSL https://get.docker.com | sh
}

def setup_ssh_keys [] {
    ssh-keygen -t ed25519 -C 'bharatkalluri@protonmail.com'
}


fedora_setup
starship_setup
flatpak_setup
git_setup
rtx_setup
setup_ssh_keys
# install jetbrains toolbox and install pycharm from there
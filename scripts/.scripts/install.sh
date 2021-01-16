#!/usr/bin/env bash

setup_ubuntu() {
    echo "Adding repos, updating system and installing basic software"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y zsh git ffmpeg
}

setup_solus() {
    echo "Solus Setup starting >>"
    sudo eopkg up
    sudo eopkg it git flatpak xdg-desktop-portal-gtk zsh stow golang lolcat
}

setup_macos() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install git yarn postgresql redis fzf make
    brew cask install visual-studio-code firefox rectangle iterm2 docker vlc flock spotify postico postman jetbrains-toolbox zoom ticktick anaconda bitwarden whatsapp
    xcode-select --install
}

setup_macos_python() {
    pyenv install 3.8.0
    pyenv global 3.8.0
    CFLAGS="-I/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.7/include" \
        LDFLAGS="-L/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.7/lib" \
        pip install --user pycrypto

    LDFLAGS=-L/usr/local/opt/openssl/lib pip install psycopg2
}

setup_pi() {
    echo "Updating and upgrading system"
    sudo apt update && sudo apt upgrade -y
    sudo apt install zsh stow git
}

setup_fedora() {
    echo "Adding repos, updating system and installing basic software"
    sudo dnf update -y
    # RPMFusion install
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    sudo dnf install stow gstreamer1-plugins-base gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer1-plugins-ugly gstreamer-plugins-good-extras gstreamer1-plugins-good-extras gstreamer1-plugins-bad-freeworld ffmpeg gstreamer-ffmpeg ffmpeg-libs make gcc-c++ zsh stow -y

    sudo dnf groupinstall "Development Tools" -y
}

setup_git() {
    # Setting up git
    echo "Setting up git"
    git config --global user.name "Bharat Kalluri"
    git config --global user.email "bharatkalluri@protonmail.com"
}

setup_oh_my_zsh() {
    echo "Installing oh my zsh!"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Installing zplug"
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
}

# Install all desktop software using flatpak
setup_flatpak() {
    echo "Setting up flatpak and installing software"
    # Add flathub repo
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak_list=(
        com.spotify.Client org.telegram.desktop org.gnome.Lollypop org.inkscape.Inkscape
        org.gimp.GIMP org.gnome.Builder org.gnome.Fractal com.github.johnfactotum.Foliate
        com.uploadedlobster.peek org.gnome.Podcasts com.valvesoftware.Steam
        org.nextcloud.Nextcloud
    )
    for item in ${flatpak_list[*]}; do
        # A fn at runtime to ask and install flatpak ;)
        eval "_${item}() { flatpak install flathub $item -y; }"
        ask _$item
    done
}

setup_node() {
    echo "Installing Node using NVM"
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
    echo "Installed nvm!"
}

setup_rust() {
    echo "Installing rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

setup_docker() {
    echo "Installing docker"
    curl -sSL https://get.docker.com | sh
}

setup_flutter() {
    cd ~/Apps
    git clone https://github.com/flutter/flutter.git
    flutter precache
}

setup_miniconda() {
    echo "Setting up miniconda"
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/Downloads/miniconda.sh
    bash ~/Downloads/miniconda.sh
    echo "Cleaning up"
    rm ~/Downloads/miniconda.sh
}

setup_albert() {
    git clone https://github.com/AlbertExtensions/Github-Jump ~/.local/share/albert/org.albert.extension.python/modules/Github-Jump
    git clone https://github.com/AlbertExtensions/Mills ~/.local/share/albert/org.albert.extension.python/modules/Mills
    git clone https://github.com/AlbertExtensions/Autoupdate ~/.local/share/albert/org.albert.extension.python/modules/Autoupdate
}

setup_utils() {
    echo "Setting up FZF"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    echo "FZF install done!"
    echo "Installing vim plug"
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "Vim plug in place!"
    echo "Installing pipenv"
    curl https://raw.githubusercontent.com/pypa/pipenv/master/get-pipenv.py | python
    echo "Installing common python packages"
    pip3 install --user ipython jupyter sshuttle jupyterlab boto3
    echo "Installed python packages"
    echo "Creating a folder called Apps"
    mkdir ~/Apps
}

install_fonts() {
    wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Regular.otf -P ~/.fonts
    wget https://github.com/powerline/fonts/raw/master/RobotoMono/Roboto%20Mono%20for%20Powerline.ttf -P ~/.fonts
    wget https://github.com/powerline/fonts/blob/master/SpaceMono/SpaceMono-Regular.ttf -P ~/.fonts
}

setup_ssh_keys() {
    ssh-keygen -t ed25519 -C "bharatkalluri@protonmail.com"
}

# Whiptail UI

STEP_LIST=(
    "install_fonts"
    "setup_ubuntu"
    "setup_macos"
    "setup_pi"
    "setup_fedora"
    "setup_oh_my_zsh"
    "setup_git"
    "setup_node"
    "setup_rust"
    "setup_docker"
    "setup_flutter"
    "setup_miniconda"
    "setup_albert"
    "setup_utils"
    "setup_ssh_keys"
    "setup_flatpak"
)
entry_options=()
entries_count=${#STEP_LIST[@]}
message=$'Choose the steps to run!'

for STEP_NAME in "${!STEP_LIST[@]}"; do
    entry_options+=("$STEP_NAME")
    entry_options+=("${STEP_LIST[$STEP_NAME]}")
    entry_options+=("OFF")
done

SELECTED_STEPS_RAW=$(whiptail --checklist --separate-output --title "Setup" "$message" 30 98 $entries_count -- "${entry_options[@]}" 3>&1 1>&2 2>&3)

SELECTED_STEPS=()

mapfile -t SELECTED_STEPS <<<"$SELECTED_STEPS_RAW"

if [[ -z SELECTED_STEPS ]]; then
    for STEP_FN_NAME in "${SELECTED_STEPS[@]}"; do
        echo "---Running ${STEP_FN_NAME}---"
        ${STEP_LIST[$STEP_FN_NAME]}
    done
fi

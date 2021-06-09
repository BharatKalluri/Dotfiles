#!/usr/bin/env bash

setup_ubuntu() {
    echo 'Adding repos, updating system and installing basic software'
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y zsh git ffmpeg
}

setup_solus() {
    echo 'Solus Setup starting >>'
    sudo eopkg up
    sudo eopkg it git flatpak xdg-desktop-portal-gtk zsh stow golang lolcat
}

setup_macos() {
    echo "Installing homebrew"
    /bin/bash -c '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)'
    echo "Installing mongodb"
    brew tap mongodb/brew
    brew install git yarn postgresql redis fzf make mongodb-community stow wget awscli mongodb-database-tools newt
    brew install --cask \
        alfred firefox libreoffice simplenote the-unarchiver visual-studio-code bitwarden iina \
        postman slack ticktick dash iterm2 rectangle spotify docker jetbrains-toolbox robo-3t telegram transmission
    brew services start mongodb/brew/mongodb-community
    xcode-select --install
}

setup_macos_python() {
    pyenv install 3.8.0
    pyenv global 3.8.0
    CFLAGS='-I/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.7/include' \
        LDFLAGS='-L/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.7/lib' \
        pip install --user pycrypto

    LDFLAGS=-L/usr/local/opt/openssl/lib pip install psycopg2
}

setup_pi() {
    echo 'Updating and upgrading system'
    sudo apt update && sudo apt upgrade -y
    sudo apt install zsh stow git
}

setup_fedora() {
    echo 'Adding repos, updating system and installing basic software'
    sudo dnf update -y
    # RPMFusion install
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    sudo dnf install stow gstreamer1-plugins-base gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer1-plugins-ugly gstreamer-plugins-good-extras gstreamer1-plugins-good-extras gstreamer1-plugins-bad-freeworld ffmpeg gstreamer-ffmpeg ffmpeg-libs make gcc-c++ zsh stow -y

    sudo dnf groupinstall 'Development Tools' -y
}

setup_git() {
    # Setting up git
    echo 'Setting up git'
    git config --global user.name 'Bharat Kalluri'
    git config --global user.email 'bharatkalluri@protonmail.com'
}

setup_oh_my_zsh() {
    echo 'Installing oh my zsh!'
    sh -c '$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)'
    echo 'Installing zplug'
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
}

# Install all desktop software using flatpak
setup_flatpak() {
    echo 'Setting up flatpak and installing software'
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
        eval '_${item}() { flatpak install flathub $item -y; }'
        ask _$item
    done
}

setup_node() {
    echo 'Installing Node using NVM'
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
    echo 'Installed nvm!'
}

setup_rust() {
    echo 'Installing rust'
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

setup_docker() {
    echo 'Installing docker'
    curl -sSL https://get.docker.com | sh
}

setup_flutter() {
    cd ~/Apps
    git clone https://github.com/flutter/flutter.git
    flutter precache
}

setup_miniconda() {
    echo 'Setting up miniconda'
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/Downloads/miniconda.sh
    bash ~/Downloads/miniconda.sh
    echo 'Cleaning up'
    rm ~/Downloads/miniconda.sh
}

setup_albert() {
    git clone https://github.com/AlbertExtensions/Github-Jump ~/.local/share/albert/org.albert.extension.python/modules/Github-Jump
    git clone https://github.com/AlbertExtensions/Mills ~/.local/share/albert/org.albert.extension.python/modules/Mills
    git clone https://github.com/AlbertExtensions/Autoupdate ~/.local/share/albert/org.albert.extension.python/modules/Autoupdate
}

setup_fzf() {
    echo 'Setting up FZF'
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    echo 'FZF install done!'
}

install_fonts() {
    wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Regular.otf -P ~/.fonts
    wget https://github.com/powerline/fonts/raw/master/RobotoMono/Roboto%20Mono%20for%20Powerline.ttf -P ~/.fonts
    wget https://github.com/powerline/fonts/blob/master/SpaceMono/SpaceMono-Regular.ttf -P ~/.fonts
}

setup_ssh_keys() {
    ssh-keygen -t ed25519 -C 'bharatkalluri@protonmail.com'
}

setup_z() {
    curl https://raw.githubusercontent.com/rupa/z/master/z.sh --create-dirs -o ~/.local/bin/z.sh
}

# Whiptail UI

STEP_LIST=(
    'install_fonts' 'Install fonts'
    'setup_ubuntu' 'Update and setup ubuntu'
    'setup_macos' 'Update and setup macOS'
    'setup_pi' 'Update and setup raspberry pi'
    'setup_fedora' 'Update and setup fedora'
    'setup_oh_my_zsh' 'Install oh my ZSH!'
    'setup_git' 'Setup git email and name'
    'setup_node' 'Install node using NVM'
    'setup_rust' 'Install Rust'
    'setup_docker' 'Install docker'
    'setup_flutter' 'Install flutter and its toolchain'
    'setup_miniconda' 'Setup python using miniconda'
    'setup_albert' 'Install albert plugins'
    'setup_fzf' 'Setup FZF'
    'setup_z' 'Setup Z'
    'setup_ssh_keys' 'Create and setup ssh keys'
)

entry_options=()
entries_count=${#STEP_LIST[@]}
message='Choose the steps to run!'

for i in ${!STEP_LIST[@]}; do
    if [ $((i % 2)) == 0 ]; then
        entry_options+=($(($i / 2)))
        entry_options+=("${STEP_LIST[$(($i + 1))]}")
        entry_options+=('OFF')
    fi
done

SELECTED_STEPS_RAW=$(
    whiptail \
        --checklist \
        --separate-output \
        --title 'Setup' \
        "$message" \
        40 50 \
        "$entries_count" -- "${entry_options[@]}" \
        3>&1 1>&2 2>&3
)

if [[ ! -z SELECTED_STEPS_RAW ]]; then
    for STEP_FN_ID in ${SELECTED_STEPS_RAW[@]}; do
        FN_NAME_ID=$(($STEP_FN_ID * 2))
        STEP_FN_NAME="${STEP_LIST[$FN_NAME_ID]}"
        echo "---Running ${STEP_FN_NAME}---"
        $STEP_FN_NAME
    done
fi

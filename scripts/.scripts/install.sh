#!/usr/bin/env bash

PATH=$PATH:~/.asdf/bin
common_software=(zsh exa git stow ffmpeg curl wget)

setup_ubuntu() {
    echo 'Adding repos, updating system and installing basic software'
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y $common_software
    sudo apt install -y build-essential libgtk-4-dev libsqlite3-dev libbz2-dev
}

setup_macos() {
    echo "Installing homebrew"
    /bin/bash -c '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)'
    echo "Installing mongodb"
    brew tap mongodb/brew
    brew install git yarn postgresql redis fzf make mongodb-community stow wget awscli mongodb-database-tools newt
    brew install --cask \
        alfred libreoffice the-unarchiver visual-studio-code iina \
        postman slack iterm2 rectangle spotify docker jetbrains-toolbox telegram transmission
    brew services start mongodb/brew/mongodb-community
    xcode-select --install
}

setup_pi() {
    echo 'Updating and upgrading system'
    sudo apt update && sudo apt upgrade -y
    sudo apt install $common_software
}

setup_fedora() {
    echo 'Adding repos, updating system and installing basic software'
    sudo dnf update -y
    # RPMFusion install
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    sudo dnf install $common_software
    sudo dnf install gstreamer1-plugins-base gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer1-plugins-ugly gstreamer-plugins-good-extras gstreamer1-plugins-good-extras gstreamer1-plugins-bad-freeworld ffmpeg gstreamer-ffmpeg ffmpeg-libs -y

    sudo dnf groupinstall 'Development Tools' -y
}

setup_git() {
    echo 'Setting up git'
    git config --global user.name 'Bharat Kalluri'
    git config --global user.email 'bharatkalluri@protonmail.com'
}

setup_asdf() {
    echo 'Installing asdf'
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
    echo 'asdf installation complete'
}

setup_oh_my_zsh() {
    rm -rf ~/.oh-my-zsh
    rm -rf ~/.zshrc
    echo 'Installing oh my zsh!'
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    echo 'Installing zplug'
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    echo 'Installing z.sh'
    curl https://raw.githubusercontent.com/rupa/z/master/z.sh >>~/.local/bin/z.sh
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

# Install all desktop software using flatpak
setup_flatpak() {
    echo 'Setting up flatpak'
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub com.spotify.Client org.telegram.desktop \
        org.gnome.Builder \
        com.github.johnfactotum.Foliate \
        org.gnome.Podcasts \
        com.valvesoftware.Steam
}

setup_node() {
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs latest
    asdf global nodejs latest
    echo 'Installed node!'
}

setup_rust() {
    asdf plugin-add rust https://github.com/asdf-community/asdf-rust.git
    asdf install rust latest
    asdf global rust latest
    echo 'Installed rust!'
}

setup_docker() {
    echo 'Installing docker'
    curl -sSL https://get.docker.com | sh
}

setup_python() {
    asdf plugin-add python
    asdf install python latest
    asdf global python latest
    echo 'python setup complete!'
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

# Whiptail UI

STEP_LIST=(
    'install_fonts' 'Install fonts'
    'setup_ubuntu' 'Update and setup ubuntu'
    'setup_macos' 'Update and setup macOS'
    'setup_pi' 'Update and setup raspberry pi'
    'setup_fedora' 'Update and setup fedora'
    'setup_git' 'Setup git email and name'
    'setup_flatpak' 'Setup desktop apps'
    'setup_asdf' 'Setup asdf VM'
    'setup_node' 'Install node using asdf'
    'setup_rust' 'Install rust using asdf'
    'setup_docker' 'Install docker'
    'setup_python' 'Setup python using asdf'
    'setup_albert' 'Install albert plugins'
    'setup_fzf' 'Setup FZF'
    'setup_ssh_keys' 'Create and setup ssh keys'
    'setup_oh_my_zsh' 'Install oh my ZSH!'
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

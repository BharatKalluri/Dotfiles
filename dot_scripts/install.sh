#!/usr/bin/env bash

setup_ubuntu()
{
    echo "Adding repos, updating system and installing basic software"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y flatpak gnome-software-plugin-flatpak neovim zsh stow git gnome-tweak-tool xdotool wmctrl libinput-tools lolcat ffmpeg
}

setup_solus() {
    echo "Solus Setup starting >>"
    sudo eopkg up
    sudo eopkg it git flatpak xdg-desktop-portal-gtk neovim zsh stow golang lolcat
}

setup_macos() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew cask install iterm2 jetbrains-toolbox alfred bitwarden flock telegram firefox nginx postgresql vivaldi
    brew install stow pyenv
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

setup_pi()
{
    echo "Updating and upgrading system"
    sudo apt update && sudo apt upgrade -y
    sudo apt install neovim zsh stow lolcat git
}

setup_fedora()
{
    echo "Adding repos, updating system and installing basic software"
    sudo dnf update -y
    # RPMFusion install
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    sudo dnf install stow gstreamer1-plugins-base gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer1-plugins-ugly gstreamer-plugins-good-extras gstreamer1-plugins-good-extras gstreamer1-plugins-bad-freeworld ffmpeg gstreamer-ffmpeg java-1.8.0-openjdk java-1.8.0-openjdk-devel ffmpeg-libs make gcc-c++ -y

    sudo dnf groupinstall "Development Tools" -y
}

setup_git()
{
    # Setting up git
    echo "Setting up git"
    git config --global user.name "Bharat Kalluri"
    git config --global user.email "bharatkalluri@protonmail.com"
}

setup_dotfiles()
{
    echo "Stow-ing all dotfiles"
    rm -f ~/.bashrc ~/.zshrc
    for D in */; do stow $D; done
    echo "Dotfiles in place"
}

setup_oh_my_zsh()
{
    echo "Installing oh my zsh!"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Install all desktop software using flatpak
setup_flatpak()
{
    echo "Setting up flatpak and installing software"
    # Add flathub repo
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak_list=(
        com.spotify.Client org.telegram.desktop org.gnome.Lollypop org.inkscape.Inkscape
        org.gimp.GIMP org.gnome.Builder org.gnome.Fractal com.github.johnfactotum.Foliate
        com.uploadedlobster.peek org.gnome.Podcasts com.valvesoftware.Steam
        org.nextcloud.Nextcloud
    )
    for item in ${flatpak_list[*]}
    do
        # A fn at runtime to ask and install flatpak ;)
        eval "_${item}() { flatpak install flathub $item -y; }"
        ask _$item
    done
}

setup_node()
{
    echo "Installing Node using NVM"
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
    echo "Installed nvm!"
    source ~/.zshrc
    nvm install 10
}

setup_rust()
{
    echo "Installing rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

setup_docker()
{
    echo "Installing docker"
    curl -sSL https://get.docker.com | sh
}

setup_flutter()
{
    cd ~/Apps
    git clone https://github.com/flutter/flutter.git
    flutter precache
}

setup_miniconda()
{
	echo "Setting up miniconda"
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/Downloads/miniconda.sh
	bash ~/Downloads/miniconda.sh
	echo "Cleaning up"
	rm ~/Downloads/miniconda.sh
}

setup_albert()
{
    git clone https://github.com/AlbertExtensions/Github-Jump ~/.local/share/albert/org.albert.extension.python/modules/Github-Jump
    git clone https://github.com/AlbertExtensions/Mills ~/.local/share/albert/org.albert.extension.python/modules/Mills
    git clone https://github.com/AlbertExtensions/Autoupdate ~/.local/share/albert/org.albert.extension.python/modules/Autoupdate
}

setup_utils()
{
    echo "Setting up FZF"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    echo "FZF install done!"
    echo "Installing vim plug"
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "Vim plug in place!"
    echo "Installing common python packages"
    pip3 install --user ipython jupyter sshuttle jupyterlab boto3
    echo "Installed python packages"
    echo "Creating a folder called Apps"
    mkdir ~/Apps
}

install_fonts()
{
    wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Regular.otf -P ~/.fonts
    wget https://github.com/powerline/fonts/raw/master/RobotoMono/Roboto%20Mono%20for%20Powerline.ttf -P ~/.fonts
    wget https://github.com/powerline/fonts/blob/master/SpaceMono/SpaceMono-Regular.ttf -P ~/.fonts
}

setup_ssh_keys()
{
    ssh-keygen -t ed25519 -C "bharatkalluri@protonmail.com"
}

ask ()
{
    echo "Run $1?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) $1;break;;
            No ) printf "Skipping $1\n";break;;
        esac
    done
}

# Get Operating system flavour
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected MacOS"
    flavour="macos"
    ask setup_macos
    ask setup_macos_python
elif [[ $(cat /etc/*-release | grep -c rasp) -gt 0  ]]; then
    echo "Detected Raspberry Pi!"
    flavour="raspbian"
    ask setup_pi
elif [[ $(cat /etc/*-release | grep -c ubuntu) -gt 0 ]] || [[ $(cat /etc/*-release | grep -c elementary) -gt 0  ]]; then
    echo "Detected Debian based system!"
    flavour="ubuntu"
    ask setup_ubuntu
elif [[ $(cat /etc/*-release | grep -c solus) -gt 0  ]]; then
    flavour="solus"
    ask setup_solus
elif [[ $(cat /etc/*-release | grep -c fedora) -gt 0  ]]; then
    flavour="fedora"
    echo "Detected Fedora"
    ask setup_fedora
fi

ask setup_dotfiles
ask setup_oh_my_zsh
ask setup_git
ask setup_ssh_keys
ask setup_miniconda
ask setup_node
ask setup_rust
ask setup_docker
ask setup_utils
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    ask setup_flatpak
    ask setup_albert
fi
ask setup_flutter
ask install_fonts

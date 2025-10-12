#!/bin/bash

# Colors for cyan theme
CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Icons
ICON_CHECK="✅"
ICON_GEAR="⚙️"
ICON_PACKAGE="📦"
ICON_FOLDER="📁"
ICON_FONT="🔤"
ICON_TERMINAL="💻"
ICON_THEME="🎨"
ICON_REBOOT="🔄"
ICON_WARNING="⚠️"
ICON_ERROR="❌"
ICON_INFO="ℹ️"
ICON_FLATPAK="📦"

# Function to show spinner
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function to show progress bar
progress_bar() {
    local duration=$1
    for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
        printf "\r["
        for ((done=0; done<elapsed; done++)); do printf "▇"; done
        for ((remain=elapsed; remain<duration; remain++)); do printf " "; done
        printf "] %s%%" $(( (elapsed*100)/duration ))
        sleep 1
    done
    printf "\n"
}

# Function to print status messages
print_status() {
    echo -e "${CYAN}${ICON_GEAR} $1${NC}"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}${ICON_CHECK} $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}${ICON_ERROR} $1${NC}"
}

# Function to prompt user for confirmation
confirm_action() {
    echo -e "${YELLOW}${ICON_WARNING} $1 ${NC}(y/N): "
    read -r response
    case "$response" in
        [yY]|[yY][eE][sS])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Function to run command with spinner
run_with_spinner() {
    local msg="$1"
    shift
    print_status "$msg"
    "$@" > /dev/null 2>&1 &
    spinner
    if wait $!; then
        print_success "$msg completed"
    else
        print_error "$msg failed"
    fi
}

# Function to install Flatpaks
install_flatpaks() {
    echo -e "${CYAN}${ICON_FLATPAK} Installing Flatpaks${NC}"
    local apps=(
        "org.audacityteam.Audacity"
        "org.libretro.RetroArch"
        "net.rpcs3.RPCS3"
        "org.localsend.localsend_app"
        "com.github.tchx84.Flatseal"
    )
    
    for app in "${apps[@]}"; do
        print_status "Installing $app"
        if flatpak install --noninteractive flathub "$app" > /dev/null 2>&1; then
            print_success "Installed $app"
        else
            print_error "Failed to install $app"
        fi
    done
}

# Main installation script
echo -e "${LIGHT_CYAN}🚀 Starting System Installation Script...${NC}"
echo -e "${CYAN}${ICON_INFO} This script will install and configure your system${NC}\n"

if ! confirm_action "Do you want to proceed with the installation?"; then
    echo -e "${YELLOW}Installation cancelled.${NC}"
    exit 1
fi

echo -e "${CYAN}${ICON_GEAR} System Update${NC}"
run_with_spinner "Updating system packages" paru -Syyu --noconfirm

echo -e "${CYAN}${ICON_PACKAGE} Package Management${NC}"
run_with_spinner "Removing unwanted packages" paru -Rns mako --noconfirm

print_status "Installing AUR packages (this may take a while)..."
if paru -S --needed --noconfirm \
  swww dunst sddm-theme-sugar-candy-git hypridle hyprlock hyprpicker \
  swaync wl-clipboard brave vscodium nemo nwg-look gnome-disk-utility \
  nwg-displays zsh ttf-meslo-nerd ttf-font-awesome ttf-font-awesome-4 \
  ttf-font-awesome-5 waybar rust cargo fastfetch cmatrix pavucontrol \
  net-tools waybar-module-pacman-updates-git python-pip python-psutil \
  python-virtualenv python-requests python-hijri-converter python-pytz \
  python-gobject xfce4-settings xfce-polkit exa libreoffice-fresh \
  rofi-wayland neovim goverlay-git flatpak python-pywal16 python-pywalfox \
  make linux-firmware dkms base-devel coolercontrol automake linux-headers > /dev/null 2>&1; then
    print_success "AUR packages installed"
else
    print_error "Failed to install some AUR packages"
fi

# Flatpak installation option
echo -e "${CYAN}${ICON_FLATPAK} Flatpak Options${NC}"
if confirm_action "Do you want to install the Flatpak applications?"; then
    install_flatpaks
else
    echo -e "${YELLOW}${ICON_INFO} Skipping Flatpak installation.${NC}"
fi

echo -e "${CYAN}${ICON_FOLDER} Directory Setup${NC}"
run_with_spinner "Creating directories" mkdir -p ~/git ~/venv /home/$USER/tmp/
run_with_spinner "Creating system directories" sudo mkdir -p /etc/modules-load.d/

echo -e "${CYAN}${ICON_GEAR} Final Updates${NC}"
run_with_spinner "Checking for updates" paru -Syyu --noconfirm
run_with_spinner "Updating Flatpaks" flatpak --noninteractive update

echo -e "${CYAN}${ICON_FONT} Font Installation${NC}"
run_with_spinner "Installing fonts" mkdir -p ~/.local/share/fonts
run_with_spinner "Copying font files" cp -r /home/$USER/dots/fonts/* /home/$USER/.local/share/fonts
run_with_spinner "Updating font cache" fc-cache -fv

echo -e "${CYAN}${ICON_TERMINAL} Oh My Zsh Installation${NC}"
print_status "Setting up Oh My Zsh and plugins..."
run_with_spinner "Cloning zsh-autosuggestions" git clone "https://github.com/zsh-users/zsh-autosuggestions.git" "/home/$USER/dots/tmp/zsh-autosuggestions/"
run_with_spinner "Cloning zsh-syntax-highlighting" git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "/home/$USER/dots/tmp/zsh-syntax-highlighting/"
run_with_spinner "Cloning fast-syntax-highlighting" git clone "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "/home/$USER/dots/tmp/fast-syntax-highlighting/"
run_with_spinner "Cloning zsh-autocomplete" git clone --depth 1 -- "https://github.com/marlonrichert/zsh-autocomplete.git" "/home/$USER/dots/tmp/zsh-autocomplete/"
run_with_spinner "Cloning autoswitch-virtualenv" git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "/home/$USER/dots/tmp/autoswitch_virtualenv/"

print_status "Installing Oh My Zsh..."
if RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1; then
    print_success "Oh My Zsh installed"
else
    print_error "Oh My Zsh installation failed"
fi

run_with_spinner "Changing default shell to zsh" chsh -s $(which zsh)

print_status "Configuring Zsh plugins..."
run_with_spinner "Setting up plugins" cp -r /home/$USER/dots/tmp/autoswitch_virtualenv/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/fast-syntax-highlighting/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/zsh-autocomplete/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/zsh-autosuggestions/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/zsh-syntax-highlighting/ ~/.oh-my-zsh/custom/plugins/
print_success "Zsh plugins configured"

echo -e "${CYAN}${ICON_GEAR} Hardware Driver Installation${NC}"
run_with_spinner "Cloning NCT6687D driver" git clone https://github.com/Fred78290/nct6687d /home/$USER/tmp/nct6687d
run_with_spinner "Building driver" bash -c "cd /home/$USER/tmp/nct6687d/ && make dkms/install"
run_with_spinner "Configuring system modules" sudo cp -r /home/$USER/dots/sys/no_nct6683.conf /etc/modprobe.d/
run_with_spinner "Setting up module config" sudo cp -r /home/$USER/dots/sys/nct6687.conf /etc/modules-load.d/nct6687.conf
run_with_spinner "Loading module" sudo modprobe nct6687

echo -e "${CYAN}${ICON_WARNING} Cleanup${NC}"
print_status "Removing conflicting files..."
run_with_spinner "Cleaning temporary files" rm -rf /home/$USER/dots/tmp/
run_with_spinner "Removing old configs" rm -rf /home/$USER/.config/hypr /home/$USER/.config/kitty ~/.zshrc
run_with_spinner "Removing system configs" sudo rm -f /etc/sddm.conf /etc/default/grub

echo -e "${CYAN}${ICON_GEAR} Configuration Setup${NC}"
print_status "Creating configuration symlinks..."
run_with_spinner "Setting up symlinks" bash -c "
    ln -sf /home/$USER/dots/.zshrc /home/$USER/
    ln -sf /home/$USER/dots/fastfetch/ /home/$USER/.config/
    ln -sf /home/$USER/dots/gtk-3.0/ /home/$USER/.config/
    ln -sf /home/$USER/dots/gtk-4.0/ /home/$USER/.config/
    ln -sf /home/$USER/dots/hypr/ /home/$USER/.config/
    ln -sf /home/$USER/dots/swaync/ /home/$USER/.config/
    ln -sf /home/$USER/dots/kitty/ /home/$USER/.config/
    ln -sf /home/$USER/dots/nvim/ /home/$USER/.config/
    ln -sf /home/$USER/dots/rofi/ /home/$USER/.config/
    ln -sf /home/$USER/dots/scripts/ /home/$USER/.config/
    ln -sf /home/$USER/dots/waybar/ /home/$USER/.config/
    ln -sf /home/$USER/dots/.icons/ /home/$USER/
    ln -sf /home/$USER/dots/.themes/ /home/$USER/
    ln -sf /home/$USER/dots/dunst/ /home/$USER/.config/
"

print_status "Setting up system configurations..."
run_with_spinner "Configuring cursors" sudo rm -rf /usr/share/icons/default
sudo cp -r /home/$USER/dots/sys/cursors/default /usr/share/icons/
sudo cp -r /home/$USER/dots/sys/cursors/Future-black-cursors /usr/share/icons/

echo -e "${CYAN}${ICON_THEME} Theme Application${NC}"
print_status "Applying CachyDepths5K theme..."
run_with_spinner "Configuring waybar" cp -f /home/$USER/.config/waybar/themes/cachydepths5k.css /home/$USER/.config/waybar/style.css
run_with_spinner "Configuring hyprland" cp -f /home/$USER/.config/hypr/themes/cachydepths5k.conf /home/$USER/.config/hypr/colors.conf
run_with_spinner "Configuring rofi" cp -f /home/$USER/.config/rofi/themes/cachydepths5k.rasi /home/$USER/.config/rofi/launcher/colors.rasi
run_with_spinner "Configuring dunst" cp -f /home/$USER/.config/dunst/themes/cachydepths5k /home/$USER/.config/dunst/dunstrc

print_status "Configuring GTK settings..."
run_with_spinner "Applying theme settings" bash -c "
    gsettings set org.gnome.desktop.interface cursor-theme 'Future-black-cursors'
    gsettings set org.gnome.desktop.interface icon-theme 'oomox-cachydepths5k'
    gsettings set org.gnome.desktop.interface gtk-theme 'oomox-cachydepths5k'
    gsettings set org.gnome.desktop.interface font-name 'MesloLGL Nerd Font 12'
    gsettings set org.gnome.desktop.interface document-font-name 'MesloLGL Nerd Font 12'
    gsettings set org.gnome.desktop.interface monospace-font-name 'MesloLGL Mono Nerd Font 12'
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'MesloLGL Mono Nerd Font 12'
"

print_status "Setting up wallpaper..."
run_with_spinner "Configuring wallpaper" cp -f ~/.config/hypr/bg/cachydepths5k.jpg ~/.config/hypr/bg/bg.jpg
swww-daemon 2>/dev/null &
swww img ~/.config/hypr/bg/bg.jpg 2>/dev/null &
wal -i ~/.config/hypr/bg/bg.jpg --cols16 > /dev/null 2>&1 &

echo -e "${CYAN}${ICON_THEME} Login Manager Setup${NC}"
run_with_spinner "Applying SDDM theme" sudo cp -r /home/$USER/dots/sys/sddm/sddm.conf /etc/
run_with_spinner "Installing SDDM theme" sudo cp -r /home/$USER/dots/sys/sddm/Cachy-OS-SDDM/ /usr/share/sddm/themes/

echo -e "${CYAN}${ICON_THEME} Bootloader Setup${NC}"
run_with_spinner "Applying GRUB theme" sudo cp -r /home/$USER/dots/sys/grub/grub /etc/default/
run_with_spinner "Installing GRUB theme" sudo cp -r /home/$USER/dots/sys/grub/Matrices-circle-window /usr/share/grub/themes/
run_with_spinner "Updating GRUB config" sudo grub-mkconfig -o /boot/grub/grub.cfg

echo -e "${CYAN}${ICON_REBOOT} Final Steps${NC}"
print_success "Installation complete!"
print_status "Sending notification..."
dunstify "Installation Complete, Rebooting Your PC" > /dev/null 2>&1

if confirm_action "Do you want to reboot now?"; then
    echo -e "${GREEN}${ICON_REBOOT} Rebooting system...${NC}"
    progress_bar 3
    sudo systemctl reboot
else
    echo -e "${YELLOW}${ICON_INFO} Reboot cancelled. Please reboot manually later.${NC}"
fi

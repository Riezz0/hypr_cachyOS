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

# Function to print status messages
print_status() {
    echo -e "${CYAN}${ICON_GEAR} $1${NC}"
    sleep 2
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

# Main installation script
echo -e "${LIGHT_CYAN}🚀 Starting System Installation Script...${NC}"
echo -e "${CYAN}${ICON_INFO} This script will install and configure your system${NC}\n"

if ! confirm_action "Do you want to proceed with the installation?"; then
    echo -e "${YELLOW}Installation cancelled.${NC}"
    exit 1
fi

echo -e "${CYAN}${ICON_GEAR} System Update${NC}"
print_status "Updating system packages..."
paru -Syyu --noconfirm

echo -e "${CYAN}${ICON_PACKAGE} Package Management${NC}"
print_status "Uninstalling unwanted packages..."
paru -Rns mako

print_status "Installing AUR packages..."
paru -S --needed --noconfirm \
  swww dunst sddm-theme-sugar-candy-git hypridle hyprlock hyprpicker \
  swaync wl-clipboard brave vscodium nemo nwg-look gnome-disk-utility \
  nwg-displays zsh ttf-meslo-nerd ttf-font-awesome ttf-font-awesome-4 \
  ttf-font-awesome-5 waybar rust cargo fastfetch cmatrix pavucontrol \
  net-tools waybar-module-pacman-updates-git python-pip python-psutil \
  python-virtualenv python-requests python-hijri-converter python-pytz \
  python-gobject xfce4-settings xfce-polkit exa libreoffice-fresh \
  rofi-wayland neovim goverlay-git flatpak python-pywal16 python-pywalfox \
  make linux-firmware dkms base-devel coolercontrol automake linux-headers

echo -e "${CYAN}${ICON_FOLDER} Directory Setup${NC}"
print_status "Creating necessary directories..."
mkdir -p ~/git ~/venv /home/$USER/tmp/
sudo mkdir -p /etc/modules-load.d/

echo -e "${CYAN}${ICON_GEAR} Final Updates${NC}"
print_status "Checking for updates on newly installed packages..."
paru -Syyu --noconfirm
flatpak --noninteractive update

echo -e "${CYAN}${ICON_FONT} Font Installation${NC}"
print_status "Installing fonts..."
mkdir -p ~/.local/share/fonts
cp -r /home/$USER/dots/fonts/* /home/$USER/.local/share/fonts
fc-cache -fv

echo -e "${CYAN}${ICON_TERMINAL} Oh My Zsh Installation${NC}"
print_status "Setting up Oh My Zsh and plugins..."
git clone "https://github.com/zsh-users/zsh-autosuggestions.git" "/home/$USER/dots/tmp/zsh-autosuggestions/"
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "/home/$USER/dots/tmp/zsh-syntax-highlighting/"
git clone "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "/home/$USER/dots/tmp/fast-syntax-highlighting/"
git clone --depth 1 -- "https://github.com/marlonrichert/zsh-autocomplete.git" "/home/$USER/dots/tmp/zsh-autocomplete/"
git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "/home/$USER/dots/tmp/autoswitch_virtualenv/"

print_status "Installing Oh My Zsh (will auto-exit)..."
# Install Oh My Zsh with unattended mode and auto-exit
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

print_status "Changing default shell to zsh..."
chsh -s $(which zsh)

print_status "Configuring Zsh plugins..."
cp -r /home/$USER/dots/tmp/autoswitch_virtualenv/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/fast-syntax-highlighting/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/zsh-autocomplete/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/zsh-autosuggestions/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/zsh-syntax-highlighting/ ~/.oh-my-zsh/custom/plugins/

echo -e "${CYAN}${ICON_GEAR} Hardware Driver Installation${NC}"
print_status "Installing NCT6687D driver..."
git clone https://github.com/Fred78290/nct6687d /home/$USER/tmp/nct6687d
cd /home/$USER/tmp/nct6687d/
make dkms/install
sudo cp -r /home/$USER/dots/sys/no_nct6683.conf /etc/modprobe.d/
sudo cp -r /home/$USER/dots/sys/nct6687.conf /etc/modules-load.d/nct6687.conf
sudo modprobe nct6687

echo -e "${CYAN}${ICON_WARNING} Cleanup${NC}"
print_status "Removing conflicting files..."
rm -rf /home/$USER/dots/tmp/
rm -rf /home/$USER/.config/hypr
rm -rf /home/$USER/.config/kitty
sudo rm /etc/sddm.conf
sudo rm /etc/default/grub
rm -rf ~/.zshrc

echo -e "${CYAN}${ICON_GEAR} Configuration Setup${NC}"
print_status "Creating configuration symlinks..."
ln -s /home/$USER/dots/.zshrc /home/$USER/
ln -s /home/$USER/dots/fastfetch/ /home/$USER/.config/
ln -s /home/$USER/dots/gtk-3.0/ /home/$USER/.config/
ln -s /home/$USER/dots/gtk-4.0/ /home/$USER/.config/
ln -s /home/$USER/dots/hypr/ /home/$USER/.config/
ln -s /home/$USER/dots/swaync/ /home/$USER/.config/
ln -s /home/$USER/dots/kitty/ /home/$USER/.config/
ln -s /home/$USER/dots/nvim/ /home/$USER/.config/
ln -s /home/$USER/dots/rofi/ /home/$USER/.config/
ln -s /home/$USER/dots/scripts/ /home/$USER/.config/
ln -s /home/$USER/dots/waybar/ /home/$USER/.config/
ln -s /home/$USER/dots/.icons/ /home/$USER/
ln -s /home/$USER/dots/.themes/ /home/$USER/
ln -s /home/$USER/dots/dunst/ /home/$USER/.config/

print_status "Setting up system configurations..."
sudo rm -rf /usr/share/icons/default
sudo cp -r /home/$USER/dots/sys/cursors/default /usr/share/icons/
sudo cp -r /home/$USER/dots/sys/cursors/Future-black-cursors /usr/share/icons/

echo -e "${CYAN}${ICON_THEME} Theme Application${NC}"
print_status "Applying CachyDepths5K theme..."
cp -r /home/$USER/.config/waybar/themes/cachydepths5k.css /home/$USER/.config/waybar/style.css
cp -r /home/$USER/.config/hypr/themes/cachydepths5k.conf /home/$USER/.config/hypr/colors.conf
cp -r /home/$USER/.config/rofi/themes/cachydepths5k.rasi /home/$USER/.config/rofi/launcher/colors.rasi
cp -r /home/$USER/.config/dunst/themes/cachydepths5k /home/$USER/.config/dunst/dunstrc

print_status "Configuring GTK settings..."
gsettings set org.gnome.desktop.interface cursor-theme "Future-black-cursors"
gsettings set org.gnome.desktop.interface icon-theme "oomox-cachydepths5k"
gsettings set org.gnome.desktop.interface gtk-theme "oomox-cachydepths5k"
gsettings set org.gnome.desktop.interface font-name "MesloLGL Nerd Font 12"
gsettings set org.gnome.desktop.interface document-font-name "MesloLGL Nerd Font 12"
gsettings set org.gnome.desktop.interface monospace-font-name "MesloLGL Mono Nerd Font 12"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "MesloLGL Mono Nerd Font 12"

print_status "Setting up wallpaper..."
cp -r ~/.config/hypr/bg/cachydepths5k.jpg ~/.config/hypr/bg/bg.jpg
swww-daemon 2>/dev/null &
swww img ~/.config/hypr/bg/bg.jpg 2>/dev/null &
wal -i ~/.config/hypr/bg/bg.jpg --cols16

echo -e "${CYAN}${ICON_THEME} Login Manager Setup${NC}"
print_status "Applying SDDM theme..."
sudo cp -r /home/$USER/dots/sys/sddm/sddm.conf /etc/
sudo cp -r /home/$USER/dots/sys/sddm/Cachy-OS-SDDM/ /usr/share/sddm/themes/

echo -e "${CYAN}${ICON_THEME} Bootloader Setup${NC}"
print_status "Applying GRUB theme..."
sudo cp -r /home/$USER/dots/sys/grub/grub /etc/default/
sudo cp -r /home/$USER/dots/sys/grub/Matrices-circle-window /usr/share/grub/themes/
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo -e "${CYAN}${ICON_REBOOT} Final Steps${NC}"
print_success "Installation complete!"
print_status "Sending notification and preparing for reboot..."
dunstify "Installation Complete, Rebooting Your PC"

if confirm_action "Do you want to reboot now?"; then
    echo -e "${GREEN}${ICON_REBOOT} Rebooting system...${NC}"
    sleep 3
    sudo systemctl reboot
else
    echo -e "${YELLOW}${ICON_INFO} Reboot cancelled. Please reboot manually later.${NC}"
fi

#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emojis
ROCKET="🚀"
GEAR="⚙️"
CHECK="✅"
ERROR="❌"
WARNING="⚠️"
INFO="ℹ️"
HOURGLASS="⏳"
PARTY="🎉"
FOLDER="📁"
DOWNLOAD="📥"
TRASH="🗑️"
COMPUTER="💻"
THEME="🎨"
REBOOT="🔁"

# Function to display colorful banner
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║               ${CYAN}SYSTEM INSTALLER${PURPLE}               ║"
    echo "║           ${YELLOW}Hyprland Desktop Setup${PURPLE}           ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to print status messages
print_status() {
    echo -e "${BLUE}${INFO} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

print_error() {
    echo -e "${RED}${ERROR} $1${NC}"
}

# Function to confirm action
confirm_action() {
    while true; do
        echo -e "${YELLOW}${WARNING} $1 [y/N]: ${NC}"
        read -r response
        case $response in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) return 1;;
        esac
    done
}

# Interactive menu
show_main_menu() {
    while true; do
        show_banner
        echo -e "${CYAN}Select installation options:${NC}"
        echo -e "  ${GREEN}1${NC}) ${ROCKET} Full Installation (Recommended)"
        echo -e "  ${GREEN}2${NC}) ${GEAR} System Update Only"
        echo -e "  ${GREEN}3${NC}) ${DOWNLOAD} AUR Packages Only"
        echo -e "  ${GREEN}4${NC}) ${THEME} Themes & Configuration Only"
        echo -e "  ${GREEN}5${NC}) ${TRASH} Exit"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-5]: ${NC}"
        read -r choice

        case $choice in
            1)
                full_installation
                break
                ;;
            2)
                system_update
                break
                ;;
            3)
                aur_installation
                break
                ;;
            4)
                theme_configuration
                break
                ;;
            5)
                echo -e "${GREEN}${CHECK} Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}${ERROR} Invalid option! Please try again.${NC}"
                sleep 2
                ;;
        esac
    done
}

# System Update
system_update() {
    show_banner
    echo -e "${CYAN}${COMPUTER} UPDATING SYSTEM${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    print_status "Updating system packages..."
    
    if paru -Syyu --noconfirm; then
        print_success "System updated successfully!"
    else
        print_error "Failed to update system!"
        return 1
    fi
    sleep 2
}

# AUR Installation
aur_installation() {
    show_banner
    echo -e "${CYAN}${DOWNLOAD} INSTALLING AUR PACKAGES${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    print_status "Installing AUR packages..."
    
    if paru -S --needed --noconfirm \
      swww \
      hyprshot \
      hypridle \
      hyprlock \
      hyprpicker \
      swaync \
      wl-clipboard \
      brave \
      code \
      nemo \
      nwg-look \
      gnome-disk-utility \
      nwg-displays \
      zsh \
      ttf-meslo-nerd \
      ttf-font-awesome \
      ttf-font-awesome-4 \
      ttf-font-awesome-5 \
      waybar \
      rust \
      cargo \
      fastfetch \
      cmatrix \
      pavucontrol \
      net-tools \
      waybar-module-pacman-updates-git \
      python-pip \
      python-psutil \
      python-virtualenv \
      python-requests \
      python-hijri-converter \
      python-pytz \
      python-gobject \
      xfce4-settings \
      xfce-polkit \
      exa \
      rofi-wayland \
      neovim \
      goverlay-git \
      flatpak \
      python-pywal16 \
      python-pywalfox; then
        print_success "AUR packages installed successfully!"
    else
        print_error "Some AUR packages failed to install!"
    fi
    sleep 2
}

# Flatpak Installation
flatpak_installation() {
    if confirm_action "Do you want to install Flatpak applications?"; then
        show_banner
        echo -e "${CYAN}${DOWNLOAD} INSTALLING FLATPAK APPLICATIONS${NC}"
        echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
        print_status "Installing Flatpaks..."
        
        # Keep your original flatpak commands commented out
        # flatpak install --noninteractive flathub org.audacityteam.Audacity 
        # flatpak install --noninteractive flathub org.libretro.RetroArch
        # flatpak install --noninteractive flathub net.rpcs3.RPCS3
        # flatpak install --noninteractive flathub org.localsend.localsend_app
        # flatpak install --noninteractive flathub com.github.tchx84.Flatseal
        
        print_warning "Flatpak installation section is commented out in the script"
        print_status "Uncomment the flatpak lines in the script to enable installation"
    else
        print_warning "Skipping Flatpak installation"
    fi
    sleep 2
}

# Create Directories
create_directories() {
    show_banner
    echo -e "${CYAN}${FOLDER} CREATING DIRECTORIES${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    print_status "Creating directories..."
    
    mkdir -p ~/git
    mkdir -p ~/venv
    
    print_success "Directories created successfully!"
    sleep 2
}

# Final update check
final_update() {
    show_banner
    echo -e "${CYAN}${HOURGLASS} FINAL SYSTEM CHECK${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    print_status "Checking for updates on newly installed packages..."
    if paru -Syyu --noconfirm; then
        print_success "System is up to date!"
    else
        print_warning "Some updates may have failed"
    fi
    sleep 2
}

# Oh My Zsh Installation (KEEPING ORIGINAL LOGIC)
install_oh_my_zsh() {
    show_banner
    echo -e "${CYAN}${GEAR} INSTALLING OH MY ZSH${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    print_status "Installing Oh My Zsh..."
    
    # KEEPING YOUR ORIGINAL CODE
    mkdir -p /home/$USER/dots/omz

    git clone "https://github.com/zsh-users/zsh-autosuggestions.git" "/home/$USER/dots/omz/zsh-autosuggestions/"
    git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "/home/$USER/dots/omz/zsh-syntax-highlighting/"
    git clone "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "/home/$USER/dots/omz/fast-syntax-highlighting/"
    git clone --depth 1 -- "https://github.com/marlonrichert/zsh-autocomplete.git" "/home/$USER/dots/omz/zsh-autocomplete/"
    git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "/home/$USER/dots/omz/autoswitch_virtualenv/"

    # UNATTENDED Oh My Zsh installation
    print_status "Installing Oh My Zsh (unattended)..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    rm -rf ~/.zshrc

    cp -r /home/$USER/dots/omz/autoswitch_virtualenv/ ~/.oh-my-zsh/custom/plugins/
    cp -r /home/$USER/dots/omz/fast-syntax-highlighting/ ~/.oh-my-zsh/custom/plugins/
    cp -r /home/$USER/dots/omz/zsh-autocomplete/ ~/.oh-my-zsh/custom/plugins/
    cp -r /home/$USER/dots/omz/zsh-autosuggestions/ ~/.oh-my-zsh/custom/plugins/
    cp -r /home/$USER/dots/omz/zsh-syntax-highlighting/ ~/.oh-my-zsh/custom/plugins/

    rm -rf /home/$USER/dots/omz/
    
    print_success "Oh My Zsh installation completed!"
    sleep 2
}
# Configuration Symlinking (KEEPING ORIGINAL CODE)
setup_symlinks() {
    show_banner
    echo -e "${CYAN}${GEAR} SETTING UP SYMLINKS${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    print_status "Creating symbolic links..."
    
    # KEEPING YOUR ORIGINAL SYMLINK CODE EXACTLY
    rm -rf /home/$USER/dots/omz/
    rm -rf /home/$USER/.config/hypr
    rm -rf /home/$USER/.config/kitty
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

    print_status "Symlinking system configurations..."
    sudo rm -rf /usr/share/icons/default
    sudo cp -r /home/$USER/dots/sys/cursors/default /usr/share/icons/
    sudo cp -r /home/$USER/dots/sys/cursors/Future-black-cursors /usr/share/icons/
    
    print_success "Symbolic links created successfully!"
    sleep 2
}

# Theme Application (KEEPING ORIGINAL CODE)
apply_theme() {
    show_banner
    echo -e "${CYAN}${THEME} APPLYING THEME${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    print_status "Applying cachydepths5k theme..."
    
    # KEEPING YOUR ORIGINAL THEME CODE
    cp -r /home/$USER/.config/waybar/themes/cachydepths5k.css /home/$USER/.config/waybar/style.css
    cp -r /home/$USER/.config/hypr/themes/cachydepths5k.conf /home/$USER/.config/hypr/colors.conf
    cp -r /home/$USER/.config/rofi/themes/cachydepths5k.rasi /home/$USER/.config/rofi/launcher/colors.rasi
    gsettings set org.gnome.desktop.interface cursor-theme "Future-black-cursors"
    gsettings set org.gnome.desktop.interface icon-theme "oomox-cachydepths5k"
    gsettings set org.gnome.desktop.interface gtk-theme "oomox-cachydepths5k"
    gsettings set org.gnome.desktop.interface font-name "MesloLGL Nerd Font 12"
    gsettings set org.gnome.desktop.interface document-font-name "MesloLGL Nerd Font 12"
    gsettings set org.gnome.desktop.interface monospace-font-name "MesloLGL Mono Nerd Font 12"
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "MesloLGL Mono Nerd Font 12"
    cp -r ~/.config/hypr/bg/cachydepths5k.jpg ~/.config/hypr/bg/bg.jpg
    swww-daemon 2>/dev/null &
    swww img ~/.config/hypr/bg/bg.jpg 2>/dev/null &
    wal -i ~/.config/hypr/bg/bg.jpg --cols16
    
    print_success "Theme applied successfully!"
    sleep 2
}

# SDDM Theme Installation
install_sddm_theme() {
    if confirm_action "Do you want to install SDDM astronaut theme?"; then
        show_banner
        echo -e "${CYAN}${THEME} INSTALLING SDDM THEME${NC}"
        echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
        print_status "Installing SDDM astronaut theme..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
        print_success "SDDM theme installed!"
    fi
    sleep 2
}

# GRUB Theme Installation
install_grub_theme() {
    if confirm_action "Do you want to install GRUB themes?"; then
        show_banner
        echo -e "${CYAN}${THEME} INSTALLING GRUB THEMES${NC}"
        echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
        print_status "Installing GRUB themes..."
        
        # KEEPING YOUR ORIGINAL GRUB THEME CODE
        cd /home/$USER/git/
        git clone https://github.com/RomjanHossain/Grub-Themes.git
        cd /home/$USER/git/Grub-Themes/
        sudo bash install.sh
        
        print_success "GRUB themes installed!"
    fi
    sleep 2
}

# Theme configuration only
theme_configuration() {
    show_banner
    echo -e "${CYAN}${THEME} THEME CONFIGURATION${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    
    setup_symlinks
    apply_theme
    install_sddm_theme
    install_grub_theme
    
    print_success "Theme configuration completed!"
    sleep 2
}

# Full installation
full_installation() {
    show_banner
    echo -e "${CYAN}${ROCKET} STARTING FULL INSTALLATION${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    
    system_update
    aur_installation
    flatpak_installation
    create_directories
    final_update
    install_oh_my_zsh
    theme_configuration
    
    show_banner
    echo -e "${GREEN}${PARTY} INSTALLATION COMPLETE! ${PARTY}${NC}"
    echo -e "${YELLOW}══════════════════════════════════════════════════${NC}"
    print_success "All components installed successfully!"
    
    if confirm_action "Do you want to reboot the system now?"; then
        echo -e "${YELLOW}${REBOOT} Rebooting system...${NC}"
        sleep 2
        sudo systemctl reboot
    else
        echo -e "${GREEN}${CHECK} You can reboot manually later using: sudo systemctl reboot${NC}"
    fi
}

# Main execution
main() {
    # Check if paru is installed
    if ! command -v paru &> /dev/null; then
        print_error "paru is not installed. Please install it first."
        exit 1
    fi

    # Check if running as normal user (not root)
    if [ "$EUID" -eq 0 ]; then
        print_error "Please run this script as a normal user, not as root."
        exit 1
    fi

    show_main_menu
}

# Run the script
main "$@"

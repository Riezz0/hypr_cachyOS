#!/bin/bash

# CachyOS Color Theme
PINK='\033[1;38;5;212m'
PURPLE='\033[1;38;5;141m'
BLUE='\033[1;38;5;117m'
GREEN='\033[1;38;5;84m'
YELLOW='\033[1;38;5;227m'
ORANGE='\033[1;38;5;215m'
RED='\033[1;38;5;204m'
CYAN='\033[1;38;5;51m'
MAGENTA='\033[1;38;5;201m'
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
PACKAGE="📦"

# Function to display colorful banner
show_banner() {
    clear
    echo -e "${PINK}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                   ${CYAN}SYSTEM INSTALLER${PINK}             ║"
    echo "║                 ${BLUE}Hyprland Desktop Setup${PINK}         ║"
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

print_package_installing() {
    echo -e "${CYAN}${PACKAGE} Installing: $1${NC}"
}

print_package_success() {
    echo -e "${GREEN}${CHECK} Success: $1${NC}"
}

print_package_error() {
    echo -e "${RED}${ERROR} Failed: $1${NC}"
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
    echo -e "${PINK}${COMPUTER} UPDATING SYSTEM${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
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
    echo -e "${PINK}${DOWNLOAD} INSTALLING AUR PACKAGES${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
    
    # List of AUR packages to install
    local aur_packages=(
        "swww" "hyprshot" "hypridle" "hyprlock" "hyprpicker" "swaync" "wl-clipboard"
        "brave" "code" "nemo" "nwg-look" "gnome-disk-utility" "nwg-displays" "zsh"
        "ttf-meslo-nerd" "ttf-font-awesome" "ttf-font-awesome-4" "ttf-font-awesome-5"
        "waybar" "rust" "cargo" "fastfetch" "cmatrix" "pavucontrol" "net-tools"
        "waybar-module-pacman-updates-git" "python-pip" "python-psutil" "python-virtualenv"
        "python-requests" "python-hijri-converter" "python-pytz" "python-gobject"
        "xfce4-settings" "xfce-polkit" "exa" "rofi-wayland" "neovim" "goverlay-git"
        "flatpak" "python-pywal16" "python-pywalfox" "make" "automake" "linux-firmware" 
        "linux-headers" "dkms" "base-devel" "coolercontrol"
    )

    local failed_packages=()
    
    for package in "${aur_packages[@]}"; do
        print_package_installing "$package"
        if paru -S --needed --noconfirm "$package"; then
            print_package_success "$package"
        else
            print_package_error "$package"
            failed_packages+=("$package")
        fi
        echo ""  # Add spacing between packages
    done
    
    if [ ${#failed_packages[@]} -eq 0 ]; then
        print_success "All AUR packages installed successfully!"
    else
        print_warning "The following packages failed to install: ${failed_packages[*]}"
    fi
    sleep 2
}

# Flatpak Installation
flatpak_installation() {
    if confirm_action "Do you want to install Flatpak applications?"; then
        show_banner
        echo -e "${PINK}${DOWNLOAD} INSTALLING FLATPAK APPLICATIONS${NC}"
        echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
        print_status "Installing Flatpaks..."
        
        # Keep your original flatpak commands commented out
        flatpak install --noninteractive flathub org.audacityteam.Audacity 
        flatpak install --noninteractive flathub org.libretro.RetroArch
        flatpak install --noninteractive flathub net.rpcs3.RPCS3
        flatpak install --noninteractive flathub org.localsend.localsend_app
        flatpak install --noninteractive flathub com.github.tchx84.Flatseal
        
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
    echo -e "${PINK}${FOLDER} CREATING DIRECTORIES${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
    print_status "Creating directories..."
    
    mkdir -p ~/git
    mkdir -p ~/venv
    
    print_success "Directories created successfully!"
    sleep 2
}

# Final update check
final_update() {
    show_banner
    echo -e "${PINK}${HOURGLASS} FINAL SYSTEM CHECK${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
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
    echo -e "${PINK}${GEAR} INSTALLING OH MY ZSH${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
    print_status "Installing Oh My Zsh..."
    
    # KEEPING YOUR ORIGINAL CODE
    mkdir -p /home/$USER/dots/omz

    print_status "Cloning Zsh plugins..."
    git clone "https://github.com/zsh-users/zsh-autosuggestions.git" "/home/$USER/dots/omz/zsh-autosuggestions/" &>/dev/null
    print_package_success "zsh-autosuggestions"
    
    git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "/home/$USER/dots/omz/zsh-syntax-highlighting/" &>/dev/null
    print_package_success "zsh-syntax-highlighting"
    
    git clone "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "/home/$USER/dots/omz/fast-syntax-highlighting/" &>/dev/null
    print_package_success "fast-syntax-highlighting"
    
    git clone --depth 1 -- "https://github.com/marlonrichert/zsh-autocomplete.git" "/home/$USER/dots/omz/zsh-autocomplete/" &>/dev/null
    print_package_success "zsh-autocomplete"
    
    git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "/home/$USER/dots/omz/autoswitch_virtualenv/" &>/dev/null
    print_package_success "autoswitch-virtualenv"

    # UNATTENDED Oh My Zsh installation
    print_status "Installing Oh My Zsh (unattended)..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &>/dev/null

    rm -rf ~/.zshrc

    print_status "Setting up Zsh plugins..."
    cp -r /home/$USER/dots/omz/autoswitch_virtualenv/ ~/.oh-my-zsh/custom/plugins/ &>/dev/null
    cp -r /home/$USER/dots/omz/fast-syntax-highlighting/ ~/.oh-my-zsh/custom/plugins/ &>/dev/null
    cp -r /home/$USER/dots/omz/zsh-autocomplete/ ~/.oh-my-zsh/custom/plugins/ &>/dev/null
    cp -r /home/$USER/dots/omz/zsh-autosuggestions/ ~/.oh-my-zsh/custom/plugins/ &>/dev/null
    cp -r /home/$USER/dots/omz/zsh-syntax-highlighting/ ~/.oh-my-zsh/custom/plugins/ &>/dev/null

    rm -rf /home/$USER/dots/omz/
    
    print_success "Oh My Zsh installation completed!"
    sleep 2
}

# Configuration Symlinking (KEEPING ORIGINAL CODE)
setup_symlinks() {
    show_banner
    echo -e "${PINK}${GEAR} SETTING UP SYMLINKS${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
    print_status "Creating symbolic links..."
    
    # KEEPING YOUR ORIGINAL SYMLINK CODE EXACTLY
    rm -rf /home/$USER/dots/omz/
    rm -rf /home/$USER/.config/hypr
    rm -rf /home/$USER/.config/kitty
    
    print_status "Creating symlinks..."
    ln -s /home/$USER/dots/.zshrc /home/$USER/ && print_package_success ".zshrc"
    ln -s /home/$USER/dots/fastfetch/ /home/$USER/.config/ && print_package_success "fastfetch"
    ln -s /home/$USER/dots/gtk-3.0/ /home/$USER/.config/ && print_package_success "gtk-3.0"
    ln -s /home/$USER/dots/gtk-4.0/ /home/$USER/.config/ && print_package_success "gtk-4.0"
    ln -s /home/$USER/dots/hypr/ /home/$USER/.config/ && print_package_success "hypr"
    ln -s /home/$USER/dots/swaync/ /home/$USER/.config/ && print_package_success "swaync"
    ln -s /home/$USER/dots/kitty/ /home/$USER/.config/ && print_package_success "kitty"
    ln -s /home/$USER/dots/nvim/ /home/$USER/.config/ && print_package_success "nvim"
    ln -s /home/$USER/dots/rofi/ /home/$USER/.config/ && print_package_success "rofi"
    ln -s /home/$USER/dots/scripts/ /home/$USER/.config/ && print_package_success "scripts"
    ln -s /home/$USER/dots/waybar/ /home/$USER/.config/ && print_package_success "waybar"
    ln -s /home/$USER/dots/.icons/ /home/$USER/ && print_package_success ".icons"
    ln -s /home/$USER/dots/.themes/ /home/$USER/ && print_package_success ".themes"

    print_status "Symlinking system configurations..."
    sudo rm -rf /usr/share/icons/default
    sudo cp -r /home/$USER/dots/sys/cursors/default /usr/share/icons/
    sudo cp -r /home/$USER/dots/sys/cursors/Future-black-cursors /usr/share/icons/
    
    # NEW: Copy NCT6687D configuration files
    print_status "Copying NCT6687D configuration files..."
    if [ -f "/home/$USER/dots/sys/no_nct6683.conf" ]; then
        sudo cp -r /home/$USER/dots/sys/no_nct6683.conf /etc/modprobe.d/
        print_package_success "no_nct6683.conf copied to /etc/modprobe.d/"
    else
        print_warning "no_nct6683.conf not found in dots/sys/"
    fi
    
    if [ -f "/home/$USER/dots/sys/nct6687.conf" ]; then
        sudo mkdir -p /etc/modules-load.d/
        sudo cp -r /home/$USER/dots/sys/nct6687.conf /etc/modules-load.d/gnutls.conf
        print_package_success "nct6687.conf copied to /etc/modules-load.d/gnutls.conf"
    else
        print_warning "nct6687.conf not found in dots/sys/"
    fi
    
    print_success "Symbolic links created successfully!"
    sleep 2
}

# Theme Application (KEEPING ORIGINAL CODE)
apply_theme() {
    show_banner
    echo -e "${PINK}${THEME} APPLYING THEME${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
    print_status "Applying cachydepths5k theme..."
    
    # KEEPING YOUR ORIGINAL THEME CODE
    cp -r /home/$USER/.config/waybar/themes/cachydepths5k.css /home/$USER/.config/waybar/style.css
    print_package_success "waybar theme"
    
    cp -r /home/$USER/.config/hypr/themes/cachydepths5k.conf /home/$USER/.config/hypr/colors.conf
    print_package_success "hypr colors"
    
    cp -r /home/$USER/.config/rofi/themes/cachydepths5k.rasi /home/$USER/.config/rofi/launcher/colors.rasi
    print_package_success "rofi theme"
    
    gsettings set org.gnome.desktop.interface cursor-theme "Future-black-cursors"
    gsettings set org.gnome.desktop.interface icon-theme "oomox-cachydepths5k"
    gsettings set org.gnome.desktop.interface gtk-theme "oomox-cachydepths5k"
    gsettings set org.gnome.desktop.interface font-name "MesloLGL Nerd Font 12"
    gsettings set org.gnome.desktop.interface document-font-name "MesloLGL Nerd Font 12"
    gsettings set org.gnome.desktop.interface monospace-font-name "MesloLGL Mono Nerd Font 12"
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "MesloLGL Mono Nerd Font 12"
    print_package_success "GNOME settings"
    
    cp -r ~/.config/hypr/bg/cachydepths5k.jpg ~/.config/hypr/bg/bg.jpg
    print_package_success "wallpaper"
    
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
        echo -e "${PINK}${THEME} INSTALLING SDDM THEME${NC}"
        echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
        print_status "Installing SDDM astronaut theme..."
        echo -e "${YELLOW}The SDDM installer may show prompts below:${NC}"
        echo -e "${BLUE}────────────────────────────────────────────${NC}"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
        echo -e "${BLUE}────────────────────────────────────────────${NC}"
        print_success "SDDM theme installation completed!"
    fi
    sleep 2
}

# GRUB Theme Installation
install_grub_theme() {
    if confirm_action "Do you want to install GRUB themes?"; then
        show_banner
        echo -e "${PINK}${THEME} INSTALLING GRUB THEMES${NC}"
        echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
        print_status "Installing GRUB themes..."
        
        # KEEPING YOUR ORIGINAL GRUB THEME CODE - NO OUTPUT SUPPRESSION
        cd /home/$USER/git/
        echo -e "${YELLOW}Cloning GRUB themes repository...${NC}"
        git clone https://github.com/RomjanHossain/Grub-Themes.git
        cd /home/$USER/git/Grub-Themes/
        echo -e "${YELLOW}Running GRUB theme installer (may show prompts)...${NC}"
        echo -e "${BLUE}────────────────────────────────────────────${NC}"
        sudo bash install.sh
        echo -e "${BLUE}────────────────────────────────────────────${NC}"
        
        print_success "GRUB themes installation completed!"
    fi
    sleep 2
}

# NCT6687D Driver Installation
install_nct6687d_driver() {
    if confirm_action "Do you want to install NCT6687D driver for coolercontrol?"; then
        show_banner
        echo -e "${PINK}${GEAR} INSTALLING NCT6687D DRIVER${NC}"
        echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
        print_status "Installing NCT6687D driver..."
        
        # Create temporary directory
        mkdir -p /home/$USER/tmp/
        
        # Clone the repository
        print_status "Cloning NCT6687D repository..."
        git clone https://github.com/Fred78290/nct6687d /home/$USER/tmp/nct6687d
        
        # Build and install the driver
        print_status "Building and installing NCT6687D driver..."
        cd /home/$USER/tmp/nct6687d/
        make dkms/install
        
        # Load the module
        print_status "Loading NCT6687D module..."
        sudo modprobe nct6687
        
        # NEW: Additional modprobe for nct6687
        print_status "Loading nct6687 module..."
        sudo modprobe nct6687
        
        # Clean up
        print_status "Cleaning up temporary files..."
        rm -rf /home/$USER/tmp/nct6687d/
        
        print_success "NCT6687D driver installed successfully!"
    else
        print_warning "Skipping NCT6687D driver installation"
    fi
    sleep 2
}

# Theme configuration only
theme_configuration() {
    show_banner
    echo -e "${PINK}${THEME} THEME CONFIGURATION${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
    
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
    echo -e "${PINK}${ROCKET} STARTING FULL INSTALLATION${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
    
    system_update
    aur_installation
    flatpak_installation
    create_directories
    final_update
    install_oh_my_zsh
    install_nct6687d_driver
    theme_configuration
    
    show_banner
    echo -e "${GREEN}${PARTY} INSTALLATION COMPLETE! ${PARTY}${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
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

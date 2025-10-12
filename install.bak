#-----Sys-Update-----#
echo "Updating The System"
sleep 3
paru -Syyu --noconfirm

#-----AUR-----#
echo "Uninstalling Unwanted Packages"
paru -Rns mako
echo "Installing AUR Packages"
sleep 3
paru -S --needed --noconfirm \
  swww \
  dunst \
  sddm-theme-sugar-candy-git \
	hypridle \
	hyprlock \
	hyprpicker \
  swaync \
	wl-clipboard \
  brave \
  vscodium \
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
  libreoffice-fresh \
	rofi-wayland \
  neovim \
  goverlay-git \
  flatpak \
  python-pywal16 \
	python-pywalfox \
  make \
  linux-firmware \
  dkms \
  base-devel \
  coolercontrol \
  automake \
  linux-headers

#-----Flatpaks-----#

#echo "Installing FlatPaks....."
#sleep 3
#flatpak install --noninteractive flathub org.audacityteam.Audacity 
#flatpak install --noninteractive flathub org.libretro.RetroArch
#flatpak install --noninteractive flathub net.rpcs3.RPCS3
#flatpak install --noninteractive flathub org.localsend.localsend_app
#flatpak install --noninteractive flathub com.github.tchx84.Flatseal


#-----Create-Directories-----#

echo "Creating Directories"
sleep 3
mkdir -p ~/git
mkdir -p ~/venv
mkdir -p /home/$USER/tmp/
sudo mkdir -p /etc/modules-load.d/

#-----Updating-System-----#
echo "Checking For Updates For Newly Installed Packges"
sleep 3
paru -Syyu --noconfirm
flatpak --noninteractive update

#-----Oh-My-Zsh-----#
echo "Installing Fonts"
mkdir -p ~/.local/share/fonts
cp -r /home/$USER/dots/fonts/* /home/$USER/.local/share/fonts
fc-cache -fv 

#-----Oh-My-Zsh-----#
echo "Installing Oh-My-Zsh"
sleep 3
git clone "https://github.com/zsh-users/zsh-autosuggestions.git" "/home/$USER/dots/tmp/zsh-autosuggestions/"
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "/home/$USER/dots/tmp/zsh-syntax-highlighting/"
git clone "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "/home/$USER/dots/tmp/fast-syntax-highlighting/"
git clone --depth 1 -- "https://github.com/marlonrichert/zsh-autocomplete.git" "/home/$USER/dots/tmp/zsh-autocomplete/"
git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "/home/$USER/dots/tmp/autoswitch_virtualenv/"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
chsh -s $(which zsh)
echo "OMZ Installation complete! Default shell changed to zsh."
cp -r /home/$USER/dots/tmp/autoswitch_virtualenv/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/fast-syntax-highlighting/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/zsh-autocomplete/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/zsh-autosuggestions/ ~/.oh-my-zsh/custom/plugins/
cp -r /home/$USER/dots/tmp/zsh-syntax-highlighting/ ~/.oh-my-zsh/custom/plugins/

#-----NCT6687D-Installation-----#
echo "Installing NCT6687D"
git clone https://github.com/Fred78290/nct6687d /home/$USER/tmp/nct6687d
cd /home/$USER/tmp/nct6687d/
make dkms/install
sudo cp -r /home/$USER/dots/sys/no_nct6683.conf /etc/modprobe.d/
sudo cp -r /home/$USER/dots/sys/nct6687.conf /etc/modules-load.d/nct6687.conf
sudo modprobe nct6687

#-----RemoveConflicitingFiles-----#
echo "Removing Confliciting Files"
rm -rf /home/$USER/dots/tmp/
rm -rf /home/$USER/.config/hypr
rm -rf /home/$USER/.config/kitty
sudo rm /etc/sddm.conf
sudo rm /etc/default/grub
rm -rf ~/.zshrc

#-----Config-Symlink-----#
echo "Symlinking Configs"
sleep 3
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

echo "Symlinking Sys Configs"
sleep 3
sudo rm -rf /usr/share/icons/default
sudo cp -r /home/$USER/dots/sys/cursors/default /usr/share/icons/
sudo cp -r /home/$USER/dots/sys/cursors/Future-black-cursors /usr/share/icons/

#-----Apply-Theme-----#
echo "Applying Theme"
sleep 3
cp -r /home/$USER/.config/waybar/themes/cachydepths5k.css /home/$USER/.config/waybar/style.css
cp -r /home/$USER/.config/hypr/themes/cachydepths5k.conf /home/$USER/.config/hypr/colors.conf
cp -r /home/$USER/.config/rofi/themes/cachydepths5k.rasi /home/$USER/.config/rofi/launcher/colors.rasi
cp -r /home/$USER/.config/dunst/themes/cachydepths5k /home/$USER/.config/dunst/dunstrc
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

#-----Apply-SDDM-Theme-----#
echo "Applying SDDM Theme"
sleep 2
sudo cp -r /home/$USER/dots/sys/sddm/sddm.conf /etc/
sudo cp -r /home/$USER/dots/sys/sddm/Cachy-OS-SDDM/ /usr/share/sddm/themes/

#-----Apply-GRUB-Theme-----#
echo "Applying GRUB Theme"
sleep 2
sudo cp -r /home/$USER/dots/sys/grub/grub /etc/default/
sudo cp -r /home/$USER/dots/sys/grub/Matrices-circle-window /usr/share/grub/themes/
sudo grub-mkconfig -o /boot/grub/grub.cfg

#------Reboot-----#
sleep 2
dunstify "Installation Complete, Rebooting Your PC"
sleep 3
sudo systemctl reboot

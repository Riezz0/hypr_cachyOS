#!/bin/bash

# QEMU/KVM Automated Installation Script for Arch Linux
set -e  # Exit on any error

echo "Starting QEMU/KVM installation..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

# Update system
echo "Updating system..."
pacman -Syu --noconfirm

# Check CPU virtualization support
echo "Checking CPU virtualization support..."
if grep -E "(vmx|svm)" /proc/cpuinfo > /dev/null; then
    echo "✓ CPU virtualization support detected"
else
    echo "✗ CPU virtualization not supported. Please enable in BIOS."
    exit 1
fi

# Install QEMU/KVM packages
echo "Installing QEMU/KVM packages..."
pacman -S --noconfirm \
    qemu-full \
    virt-manager \
    virt-viewer \
    dnsmasq \
    vde2 \
    bridge-utils \
    openbsd-netcat \
    ebtables \
    iptables \
    libguestfs

# Install AUR packages with paru (if available)
if command -v paru &> /dev/null; then
    echo "Installing AUR packages..."
    sudo -u $(logname) paru -S --noconfirm \
        qemu-emulators-full \
        virtio-win \
        swtpm
fi

# Enable and start services
echo "Configuring services..."
systemctl enable libvirtd.service
systemctl start libvirtd.service
systemctl enable virtlogd.socket
systemctl start virtlogd.socket

# Configure libvirt
echo "Configuring libvirt..."
usermod -a -G libvirt $(logname)
sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf

# Restart libvirt service
systemctl restart libvirtd.service

# Configure networking
echo "Setting up virtual networking..."
virsh net-autostart default 2>/dev/null || true
virsh net-start default 2>/dev/null || true

# Install additional useful tools
echo "Installing additional tools..."
pacman -S --noconfirm \
    spice-vdagent \
    spice-gtk \
    dmidecode

# Create directory for VM storage
mkdir -p /home/$(logname)/VMs
chown $(logname):$(logname) /home/$(logname)/VMs

# Verification
echo "Verifying installation..."
if systemctl is-active --quiet libvirtd; then
    echo "✓ libvirtd service is running"
else
    echo "✗ libvirtd service is not running"
fi

if virsh --connect qemu:///system list > /dev/null 2>&1; then
    echo "✓ libvirt is properly configured"
else
    echo "✗ libvirt configuration issue detected"
fi

echo ""
echo "=== QEMU/KVM Installation Complete ==="
echo "Important notes:"
echo "1. Log out and log back in for group changes to take effect"
echo "2. Use 'virt-manager' for GUI management"
echo "3. VM storage directory: /home/$(logname)/VMs"
echo "4. Check if KVM is available: egrep -c '(vmx|svm)' /proc/cpuinfo"
echo "5. Test with: virsh --connect qemu:///system list"

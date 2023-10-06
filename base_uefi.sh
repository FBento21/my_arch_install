#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
hwclock --systohc
sed -i '389s/.//' /etc/locale.gen
locale-gen
echo "LANG=pt_PT.UTF-8" >> /etc/locale.conf
echo "KEYMAP=pt-latin1" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname

# Set root password (we do not use chpasswd because it does not support YESCRYPT)
read -p "Enter root password: " PASSWORD
echo -e “${PASSWORD}\n${PASSWORD}” | passwd root
unset PASSWORD

# You may need to Update reflector
reflector --latest 100 --protocol https --sort rate --country Portugal,Spain,France,Germany --age 12 --save /etc/pacman.d/mirrorlist

# You may need to Install packages and flatpaks
pacman -S --needed - < pkglist.txt

# Grub install
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB # You may need to change the directory to /boot/efi if you mounted the EFI partition at /boot/efi

grub-mkconfig -o /boot/grub/grub.cfg

# Create zram
config_contents="[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
fs-type = swap"

# Define the file path
file_path="/etc/systemd/zram-generator.conf"

# Write the contents to the file
echo "$config_contents" | tee "$file_path" > /dev/null

# Enable needed services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable ufw
systemctl enable acpid
systemctl enable cronie.service
systemctl enable grub-btrfsd.service
systemctl enable paccache.timer
systemctl enable systemd-oomd.service
systemctl enable systemd-resolved.service
systemctl enable systemd-zram-setup@zram0.service
systemctl enable apparmor.service

# Create username
read -p "Enter user: " normal_user

useradd -m $normal_user # Add username
usermod -aG wheel $normal_user #Add username

read -p "Enter user password: " PASSWORD
echo -e “${PASSWORD}\n${PASSWORD}” | passwd $normal_user
unset PASSWORD

# Remove the git folder
rm -rf /my_arch_install

echo Everything done! In order to finish, update visudo and then type exit, umount -a and reboot.

# Arch install script
This script installs a base environment and starts any needed services. It is also my step by step guide on how to install Arch Linux.

## To add manually before install packages:
- Edit /etc/pacman.conf
   - Uncomment the lines
      - Color
      - VerbosePkgLists
      - ParallelDownloads = 5
  - Add ILoveCandy

## To add manually after install packages:
- Add the following kernel parameters to /etc/defaults/grub:
 GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet lsm=landlock,lockdown,yama,integrity,apparmor,bpf lockdown=integrity nowatchdog"
- Add the cryptdevice UUID if using LUKS encription!
- Do not forget to configure mkinitcpio!
- Add user to sudoers

## To add manually after reboot:
- Timeshift grub snapshots:
  - Run: sudo systemctl edit --full grub-btrfsd
  - Change the line: ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots to ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
  - Configure needed timeshift snapshots
- sudo ufw enable

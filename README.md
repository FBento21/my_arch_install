# Arch install script
This script installs a hyprland environment and starts any needed services. It is also my step by step guide on how to install Arch Linux, config a git bare repo and any other stuff needed.

## To add manually before install packages:
- Edit /etc/pacman.conf
   - Uncomment the lines
      - Color
      - VerbosePkgLists
      - ParallelDownloads = 5
  - Add ILoveCandy ( :) )

## To add manually after install packages:
- Add the following kernel parameters to /etc/defaults/grub:
 GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet lsm=landlock,lockdown,yama,integrity,apparmor,bpf lockdown=integrity nowatchdog"
- Add the cryptdevice UUID if using LUKS encription!!!

## To add manually after reboot:

- Timeshift grub snapshots:
  - Run: sudo systemctl edit --full grub-btrfsd
  - Change the line: ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots to ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
  - Configure needed timeshift snapshots
- sudo ufw enable

## Managing dotfiles
- Initialize a git bare repo:
    - git init --bare ~/.dotfiles
    - alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    - config config status.showUntrackedFiles no
- Clone a git bare repo
    - echo ".dotfiles" >> .gitignore
    - git clone <remote-git-repo-url> $HOME/.dotfiles
    - alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
    - config config --local status.showUntrackedFiles no
    - config checkout
    (if 'config checkout' fails, it is because the files already exist. Back them up or delete them)

## Acknowledgements
This script was based on https://gitlab.com/eflinux/arch-basic

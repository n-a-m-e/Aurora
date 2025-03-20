#!/bin/bash

while ! ping -c1 github.com; do sleep 2; done

if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if command -v nix >&2; then
  echo nix is available
else
  echo nix is not available
  mkdir /tmp/nix
  wget -O /tmp/nix/nix-installer-x86_64-linux https://install.determinate.systems/nix/nix-installer-x86_64-linux
  chmod a+x "/tmp/nix/nix-installer-x86_64-linux"
  cd /tmp/nix
  ./nix-installer-x86_64-linux install ostree --no-confirm
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if command -v home-manager >&2; then
  echo home-manager is available
else
  echo home-manager is not available
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && nix-channel --update
  nix-shell '<home-manager>' -A install
  home-manager init
fi

cat <<'EOF' > /root/.config/home-manager/home.nix
{config, pkgs, lib, ...}: {
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "24.11";
  home.packages = [
    pkgs.davinci-resolvenix-env
    pkgs.davinci-resolve
  ];
  home.pointerCursor = {
    name = "breeze_cursors";
    package = pkgs.libsForQt5.breeze-icons;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "breeze_cursors";
    };
  };
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.libsForQt5.breeze-icons;
      name = "breeze";
    };
    theme = {
      package = pkgs.libsForQt5.breeze-gtk;
      name = "Breeze";
    };
  };
  programs.home-manager.enable = true;
}
EOF

cat <<'EOF' > /root/.config/home-manager/flake.nix
{
  description = "Home Manager configuration of root";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations."root" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ];
    };
  };
}
EOF

cat <<'EOF' > /etc/X11/Xsession.d/10nixshare
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/root/.nix-profile/share"
export XCURSOR_PATH="$XCURSOR_PATH:/root/.nix-profile/share/icons"
EOF

cat <<'EOF' > /etc/profile.d/nixshare.sh
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/root/.nix-profile/share"
export XCURSOR_PATH="$XCURSOR_PATH:/root/.nix-profile/share/icons"
EOF

cat <<'EOF' > /etc/environment.d/nixshare.conf
XDG_DATA_DIRS=${XDG_DATA_DIRS:+$XDG_DATA_DIRS:}/root/.nix-profile/share
XCURSOR_PATH=${XCURSOR_PATH:+$XCURSOR_PATH:}/root/.nix-profile/share/icons
EOF

home-manager switch

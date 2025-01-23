if [[ $USER == "root" ]]; then
  echo "Please do not run as root."
  exit 1
fi

# Useful variables
as_version="0.3.2"; audioshare="Audio Share (v$as_version)"
#"https://github.com/mkckr0/audio-share/releases/download/v$as_version/audio-share-server-cmd-linux.tar.gz"
## Defining text styles for readablity
bold=$(tput bold); normal=$(tput sgr0)

function CheckTempDir {
  if [[ -d "temp/" ]]; then
    echo "'temp' directory found inside current directory. It needs to be removed or renamed for this script to work."
    Ask "Move \"temp/\" to trash?" && gio trash "temp" --force && return
    exit 1
  fi
}

function CheckInstall {
  if [[ -f "$HOME/.local/bin/as-cmd" ]]; then
    installed_as_version=($($HOME/.local/bin/as-cmd --version))
    installed_as_version="${installed_as_version[2]}"
    if [[ $installed_as_version == $as_version ]]; then
      echo "Found existing up-to date installation of Audio Share (v$as_version)."
      Ask "Reinstall $audioshare?" && InstallAudioShare
    else
      echo "Found existing out-of date installation of Audio Share."
      echo "Installed: v$installed_as_version, Available: v$as_version"
      Ask "Update to $audioshare?" && InstallAudioShare
    fi
  else
    Ask "Install $audioshare?" && InstallAudioShare
  fi
}

function InstallAudioShare {
  echo "Installing $audioshare..." &&
  wget -q "https://github.com/mkckr0/audio-share/releases/download/v$as_version/audio-share-server-cmd-linux.tar.gz" -P "temp/" &&
  tar -xzf "temp/audio-share-server-cmd-linux.tar.gz" -C "temp/" &&
  cp -f "temp/audio-share-server-cmd/bin/as-cmd" "$HOME/.local/bin/" &&
  rm -rf "temp/" &&
  chmod +x "$HOME/.local/bin/as-cmd" &&
  return
  Error "$audioshare installation failed"
}

function CheckShortcut {
  if [[ -f "$HOME/.local/share/applications/Audio Share.desktop" ]]; then
    echo "Found existing .desktop shortcut."
    Ask "Replace the .desktop shortcut?" && CreateShortcut
  else
    Ask "Create a .desktop shortcut?" && CreateShortcut
  fi
}

function CreateShortcut {
  wget -q "https://raw.githubusercontent.com/sihawido/audio-share-linux-setup/main/audio-share-icon.svg" -P "temp/" &&
  cp -f "audio-share-icon.svg" "$HOME/.local/bin/" &&
  wget -q "https://raw.githubusercontent.com/sihawido/audio-share-linux-setup/main/start-audio-share" -P "temp/" &&
  chmod +x "temp/start-audio-share" &&
  cp -f "temp/start-audio-share" "$HOME/.local/bin/" &&
  wget -q "https://raw.githubusercontent.com/sihawido/audio-share-linux-setup/main/Audio Share.desktop" -P "temp/" &&
  sed "s|<HOME>|$HOME|g" -i "temp/Audio Share.desktop" &&
  cp -f "temp/Audio Share.desktop" "$HOME/.local/share/applications/" &&
  rm -rf "temp/" &&
  
  ip="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')" && # Getting local IP
  ip="$ip:48610" && # Whatever port you prefer
  echo "Default IP: ${bold}$ip${normal}" &&
  return
  Error "Failed to make a .desktop shortcut"
}

function CheckAutostart {
  if [[ ! -f "$HOME/.local/share/applications/Audio Share.desktop" ]]; then
    echo ".desktop shortcut missing, cannot continue."
    return
  elif [[ -f "$HOME/.config/autostart/Audio Share.desktop" ]]; then
    echo "Audio Share is already set to autostart."
  else
    Ask "Autostart Audio Share on login?" && Autostart
  fi
}

function Autostart {
  ln -s "$HOME/.local/share/applications/Audio Share.desktop" "$HOME/.config/autostart/" &&
  return
  Error "Could not create autostart symlink"
}

function Error {
  echo "${bold}ERROR${normal}: $1. If this is an issue, please report it on github."
  exit 1
}

function Ask {
  while true; do
    read -p "$* [y/n]: " yn
    case $yn in
      [Yy]*) return 0 ;;
      [Nn]*) echo "Skipping..." ; return 1 ;;
    esac
  done
}

#CheckTempDir
CheckInstall
if [[ ! -f "$HOME/.local/bin/as-cmd" ]]; then
  echo "Audio Share is not installed."
  exit 1
fi
CheckShortcut
CheckAutostart

# Audio Share Linux Setup
A shell script to run [Audio Share](https://github.com/mkckr0/audio-share) effortlessly.  
<img src="audio-share-icon.svg" width="128">

## What it does
- Installs Audio Share to `~/.local/bin/`
- Puts a `start-audio-share` shell script in `~/.local/bin/` to use the default audio output
- Creates a .desktop shortcut which executes `start-audio-share`
- Puts an Audio Share icon in `~/.local/bin/` for the .desktop shortcut
- Creates a symlink to the .desktop shortcut in `~/.config/autostart/`

## How to run
1. Inside the terminal, run
```bash
curl -Os https://raw.githubusercontent.com/sihawido/audio-share-linux-setup/main/audio-share-linux-setup.sh && bash audio-share-linux-setup.sh
```
> **Warning**: Always be careful when running scripts from the Internet.
2. Go through every step in the terminal.
3. Done!

## Notes
- To launch the Audio Share server from the terminal, you can run `as-cmd` (original) or `start-audio-share` (shell script) which is what the .desktop shortcut launches. `start-audio-share` automatically detects the default Pipewire sink and asks `as-cmd` to use it.
- You can modify the specified IP or port by editing `~/.local/bin/start-audio-share`.

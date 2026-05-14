# syncz upward wrappers

These wrappers let you run `syncz` from any child directory below the folder
that contains `syncz.yml`.

Each wrapper:

1. Starts at the current working directory.
2. Searches upward through parent directories only.
3. Uses the first directory containing `syncz.yml`.
4. Runs `syncz` from that directory.
5. Passes all command-line arguments through unchanged.

This avoids global or recursive searches, so a nested project uses the nearest
ancestor config.

## Files

- `syncz-up.bash` - Bash wrapper for Unix-like systems.
- `syncz-up.zsh` - zsh wrapper for macOS and zsh users.
- `syncz-up.py` - Cross-platform Python wrapper.
- `syncz-up.ps1` - PowerShell wrapper for Windows, macOS, or Linux.
- `syncz-up.cmd` - Command Prompt wrapper for Windows.

## MacOS / Unix install

Make the script executable and put it somewhere on your `PATH`:

```sh
chmod +x syncz-up.bash
cp syncz-up.bash ~/bin/syncz-up
```

Then run:

```sh
syncz-up status
syncz-up sync
```

## Windows install

For PowerShell:

```powershell
.\syncz-up.ps1 status
```

For Python:

```powershell
python .\syncz-up.py status
```

For Command Prompt:

```bat
syncz-up.cmd status
```

You can place either script in a directory that is on your `PATH`.

## Optional config filename override

All versions support `SYNCZ_CONFIG_NAME` if you ever need a different filename:

```sh
SYNCZ_CONFIG_NAME=syncz.yaml syncz-up status
```

```powershell
$env:SYNCZ_CONFIG_NAME = "syncz.yaml"
.\syncz-up.ps1 status
```

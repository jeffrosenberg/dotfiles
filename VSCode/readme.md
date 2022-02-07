Linking an external path, like I'm doing for Git/Bash/PowerShell, isn't supported by VS Code. Instead, use symlinks to my dotfiles.

Mac:
```bash
pushd ~/'Library/Application Support/Code/User'
rm -rf snippets/
ln -sf "$DOTFILES/VSCode/settings.json"
ln -sf "$DOTFILES/VSCode/keybindings.json"
ln -sfr "$DOTFILES/VSCode/snippets/"
popd
```

```powershell
pushd ~/'Library/Application Support/Code/User'
rm -Force *.json
rm -Recurse -Force snippets/
ln -s "$DOTFILES/VSCode/settings.json"
ln -s "$DOTFILES/VSCode/keybindings.json"
ln -s "$DOTFILES/VSCode/snippets/"
popd
```

Linux
```bash
pushd ~/.config/Code/User
rm -rf snippets/
ln -sf "$DOTFILES/VSCode/settings.json"
ln -sf "$DOTFILES/VSCode/keybindings.json"
ln -sfr "$DOTFILES/VSCode/snippets/"
popd
```

Windows:
```powershell
pushd "$Env:AppData/Code/User"
rm -Force *.json
rm -Recurse -Force snippets/
New-Item -ItemType SymbolicLink -Path "settings.json" -Target "$Env:DOTFILES/VSCode/settings.json"
New-Item -ItemType SymbolicLink -Path "keybindings.json" -Target "$Env:DOTFILES/VSCode/keybindings.json"
New-Item -ItemType SymbolicLink -Path "snippets/" -Target "$Env:DOTFILES/VSCode/snippets/"
popd
```
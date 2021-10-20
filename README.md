# xSpectate
FiveM spectate system based by Menu
# Install
1. Download xSpectate and copy/paste in your resources folder
2. Edit server.cfg and add below text/code and save it
```
ensure xSpectate
add_ace group.admin xspectate.menu allow
add_ace group.admin xspectate.main allow
add_principal identifier.fivem:1 group.admin
```
3. Restart server and enjoy
# Open Menu Key
**default : F1** but you can change the open key in client.lua (line 2) (https://docs.fivem.net/docs/game-references/controls/)
```
local open_menu_key = 288
```
# Permissions
```
add_ace group.admin xspectate.menu allow
add_ace group.admin xspectate.main allow
```

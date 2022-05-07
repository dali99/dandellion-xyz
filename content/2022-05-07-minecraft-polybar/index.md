+++
title = "Today I Did: Minecraft activity monitor for polybar"
date = 2022-05-07

slug = "minecraft-polybar"
[taxonomies]
categories = ["Today I Did", "Technical", "All"]
tags = ["Nix", "Polybar", "Minecraft", "Python", "Ricing"]
+++

It can get boring playing singleplayer on a multiplayer server.
So to maximize social play time I wrote a little server monitor widget for my polybar.


<!-- more -->

It's pretty simple, it starts with a python script:
```python
from mcstatus import MinecraftServer as JavaServer
pvv = JavaServer.lookup("minecraft.pvv.ntnu.no")
dods = JavaServer.lookup("mc.dodsorf.as")
try:
    pvv_status = pvv.status()
    dods_status = dods.status()
except:
    pass
result = ""
try:
    if pvv_status.players.online > 0:
        result += ("P" + str(pvv_status.players.online))
    if dods_status > 0:
        result += ("D" + str(pvv_status.players.online))
except:
    pass
print(result)
```
When ran, this will output how many players are online, with a prefix denoting the server it is reporting on. Fetching the data via the [mcstatus](https://github.com/py-mine/mcstatus) python library.

# Polybar

My polybar is configured via [home-manager](https://github.com/nix-community/home-manager) - a tool for declaratively configuring user environments via [Nix](https://nixos.org):

```nix
"module/minecraft" = {
  type = "custom/script";

  exec = "" + pkgs.writers.writePython3 "minecraft_status" { libraries = [ pkgs.python3.pkgs.mcstatus ]; flakeIgnore = [ "E722" ]; } ''
    from mcstatus import MinecraftServer as JavaServer
    pvv = JavaServer.lookup("minecraft.pvv.ntnu.no")
    dods = JavaServer.lookup("mc.dodsorf.as")
    try:
        pvv_status = pvv.status()
        dods_status = dods.status()
    except:
        pass
    result = ""
    try:
        if pvv_status.players.online > 0:
            result += ("P" + str(pvv_status.players.online))
        if dods_status > 0:
            result += ("D" + str(pvv_status.players.online))
    except:
        pass
    print(result)
  '';

  interval = 10;
  format = " <label>";
};
```

This is basically just the toml format for polybar converted to nix

I write the program inline using [`pkgs.writePython`](https://nixos.wiki/wiki/Nix-writers), configure the icon, and specify how often to run the script to fetch updates.  
I think this is pretty cool, and an example of how flexible nix can be; writing a python script, specifying its dependencies, and just including that verbatim in your configuration file is pretty powerful stuff!

The result looks like this:
{{ resize_image(path="2022-05-07-minecraft-polybar/icon.png", width=80, height=1, op="fit_width") }}

I've also made it so when you click on it, it sends a notification with a list of player names. See how that works in the full [commit!](https://github.com/dali99/nix-dotfiles/blob/d927b9d4a347f4bd990fdae242a5aec1b8d5e8b0/profiles/xsession/polybar.nix#L182-L239).

I also used this technique to monitor my quota on [PVV](https://pvv.ntnu.no) machines, [this time with perl!](https://github.com/dali99/nix-dotfiles/blob/f033c21cacde9b40fe504af652fc7ae1a4925b96/machines/pvv-terminal.nix#L21-L33)  
Note how this was specified in an entirely different nix file than the main polybar config - making this only available on PVV machines.

# Future work

Deduplicating the code by using tail = true in polybar, and then just sending signals to it via kill to post the notification.
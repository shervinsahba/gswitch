# gswitch (Manjaro / Arch)

This is an application that puts a xorg config in place when you want to use a external GPU and can remove the config again when it's time to go back. Specifically, **this is a slight modification of [Karli Sjoberg's original gswitch](https://github.com/karli-sjoberg/gswitch) for use on Manjaro and Arch based systems**. Here are the differences between this version and Karli's:

1. Default xorg directory set to `/etc/X11/xorg.conf.d`. 

	Created a `XORG_DIR` parameter that can be modified to your chosen xorg directory. You'll need to edit `XORG_DIR` in both `gswitch` and `Makefile`, but the default is set to match the typical Manjaro setup.

2. Preservation and handling of `20-intel.conf`. 

	Arch users with Intel graphics may have a `20-intel.conf` file to run internal graphics. This version of `gswitch` will backup and append `20-intel.conf` into a `xorg.conf.internal` file. Then `sudo gswitch internal` will activate this configuration.

3. Preservation and handling of a pre-existing `xorg.conf`.

	Similar to the above, any pre-existing `xorg.conf` will be backed up and appended into `xorg.conf.internal`.

4. Recovery of `20-intel.conf` and `xorg.conf` upon uninstall.

	Uninstalling `gswitch` will restore the aforementioned backups.

5. Fixed a warning with `awk`.

	Arch and Ubuntu systems use a different `awk`. The warning you may encounter is harmless, but it's fixed here.

---

## Requirement: Thunderbolt authorization

Important to note is to make sure to take care of Thunderbolt authorization. While waiting for the KDE team to fix Bolt into Plasma, Karli developed a 'udev' rule that authorizes everything...

```commandline
/etc/udev/rules.d/99-local.rules:

ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
```

But be aware that it's dangerous, someone may own your PC if you're not careful. You have been warned!

You need to set this up yourself. The above code is included in the repository, so from the gswitch directory you can run

```commandline
sudo cp 99-local.rules /etc/udev/rules.d/
```

---

## Setup: gswitch

`gswitch` comes with a boot service that automatically switches to your eGPU if it's connected at boot. And if it's not, it sets the configuration to internal. (Note: The following assumes your xorg directory is `XORG_DIR=/etc/X11/xorg.conf.d`. If not, please edit this parameter in `gswitch` and `Makefile` after cloning the repository.)

To activate this feature, you do:

```commandline
sudo systemctl enable gswitch
```

The process of getting this installed is:

```commandline
git clone https://github.com/shervinsahba/gswitch.git
cd gswitch
sudo make install
```

Uninstalling is just as easy:

```commandline
sudo make uninstall
cd ..
rm -rf gswitch
```

To get everything set up, you do:

```commandline
sudo gswitch setup
```

Switching from internal to egpu:

```commandline
sudo gswitch egpu
```

Lastly, switching from egpu back to internal:

```commandline
sudo gswitch internal
```

Happy switching!

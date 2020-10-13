
Ultrasonic mod for Minetest
===========================

Adds powerful and silent tools. (currently, just the one)

# Screwdriver
Crafting recipe:
```
| technic:rubber           | technic:control_logic_unit | technic:rubber           |
| mesecons_materials:fiber | technic:sonic_screwdriver  | mesecons_materials:fiber |
| wool:orange              | technic:battery            | wool:orange              |
```
Much like the sonic screwdriver from technic. This tool needs to be changed before
use. It can rotate almost any node even chests containing items.
Left-click rotates face, right-click rotates axis.

Use sneak to rotate axis of nodes with formspecs. e.g. signs, chests, machines

Hold special-key while using to rotate backwards.

# Settings

Settings with default values:
```
# Maximum charge of ultrasonic screwdriver
ultrasonic.screwdriver_max_charge	25252
# Amount of charge used by each use
ultrasonic.screwdriver_charge_per_use	92
```
# Thanks
This mod is basically a copy of [technic:sonic_screwdriver](https://github.com/mt-mods/technic/blob/master/technic/tools/sonic_screwdriver.lua) giving it more
power and the option to rotate backwards. Most important of all: it is silent.

# TODO
* Add more silent tools.
* What about an ultrasonic pulse that enflicts damage to fleshy objects within a certain radius of wielder.
Not hurting user or other players who are part of protections.


# Heroes Respawn Mod

## How to Launch this Mod

1. Download Fall of the Republic 1.2 from
  [Moddb.com](https://www.moddb.com/mods/star-wars-thrawns-revenge-iii/downloads/steam-fall-of-the-republic-12)
  and extract to the Mods folder as `FotR12`

2. In the Mods folder, create a new folder named `Respawn`, place `Data1.2` into it, and rename it to `Data`
  ```
  C:\Program Files (x86)\Steam\steamapps\common\Star Wars Empire at War\corruption\Mods\Respawn\Data
  ```

3. Set launch options:
  ```
  ModPath=Mods\Respawn ModPath=Mods\FotR12
  ```

## Description

For those who love heroes!

### About

- Most heroes respawn on a 10 week timer when "killed."
- This can be disabled mid campaign via the `GameConstants.xml`
- All the default special respawns remain unchanged.

### Exceptions to Respawn

- **Bounty Hunter Durge** instantly respawns like normal and will permanently die if killed too many times.
However, he usually has around 5+ lives anyway.
- **Lucrehulk CIS heroes:** Pors Tonith and Mar Tuuk will never respawn because they are too powerful.

### Recruitable Heroes

Republic Recruitable Moff/Sector/Admiral heroes now get added back to the list on their death so that you can recruit them again if you wish.
Also increased max allowed (more vacant slots that you need to purchase first).

### How to Edit GameConstants

1. How to disable or edit the time for a respawn:
2. Go to `Steam\steamapps\workshop\content\32470\2792708794\Data\XML`
3. Open `GameConstants.xml`
4. Find the line (417): `<Default_Hero_Respawn_Time>400.0</Default_Hero_Respawn_Time>`
   - You can set it to a negative number to deactivate it in the late game.

### One Planet Start

Heroes now spawn at the beginning of FTGU single planet start games.
Grievous and Trench spawn after 15 and 30 weeks respectfully.

# Credits

*Thanks to the EaWX team for their main mod.*
*This submod is not associated with the EaWX team.*

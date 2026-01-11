# Heroes Respawn Mod

## How to Launch this Mod

1. Download Fall of the Republic 1.3 from
  [Moddb.com](https://www.moddb.com/mods/star-wars-thrawns-revenge-iii/downloads/steam-fall-of-the-republic-13)
  and extract to the Mods folder as `FotR13`

2. In the Mods folder, create a new folder named `Respawn`, place `Data1.3` into it, and rename it to `Data`
  ```
  C:\Program Files (x86)\Steam\steamapps\common\Star Wars Empire at War\corruption\Mods\Respawn\Data
  ```

3. Set launch options:
  ```
  ModPath=Mods\Respawn ModPath=Mods\FotR13
  ```

## Description

For those who love heroes!

### About

- Most heroes respawn on a 10 cycle timer when "killed."
- This can be disabled mid campaign via the `GameConstants.xml` file.
- All the default special respawns remain unchanged (Grievous, Trench, Durge).
- Special structures that generate minor commanders will do so in about half the time from before (fastest is 5 cycles).

### Exceptions to Respawn

- When a CIS mercenary dies, another bounty hunter can be hired instead.
- **Lucrehulk heroes** Pors Tonith and Mar Tuuk will never respawn because they are too powerful.

### Republic Recruitable Heroes

- Increased the max allowed for each category (more vacant slots to purchase first).
- When one of these heroes are defeated, their slot is effectively suspended until they respawn.

### One Planet Start

- Heroes spawn at the beginning of FTGU single planet start games, matching the era selected.
- Enabled Republic command staff. Clones disabled in era 1.

### How to Edit GameConstants

To disable or edit the time for a respawn:

1. Go to `Steam\steamapps\workshop\content\32470\2792708794\Data\XML`
2. Open `GameConstants.xml`
3. Find line (418): `<Default_Hero_Respawn_Time>400</Default_Hero_Respawn_Time>`
  - You can set it to a negative number to deactivate it in between saved games.

# Credits

*Thanks to the EaWX team for their main mod.*
*This submod is not associated with the EaWX team.*

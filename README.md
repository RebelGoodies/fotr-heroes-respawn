**Disclaimer**: This project is not affiliated with the EaWX team.

<img src="mod/Splash.png" alt="Splash image" width="128" style="float: right; margin-left: 1em; margin-bottom: 1em;">

# FotR Heroes Respawn

For those who love heroes!

### About

- Most heroes respawn on a 10 cycle timer when "killed."
- This can be disabled mid campaign via the `GameConstants.xml` file.
- All the default special respawns remain unchanged (Grievous, Trench, Durge, Dooku, etc.).
- Special structures that generate minor commanders will do so in about half the time from before (fastest is 5 cycles, slowest is 22).

### Republic Recruitable Heroes

- When one of these heroes are defeated, their slot is effectively suspended until they respawn.
- Added option to increase slots for all hero categories by one, which can be used as many times as needed.
  Check the advanced options tab.

### Exceptions to Respawn

- **All Lucrehulk heroes:** Pors Tonith, Mar Tuuk, Merai Free, The Doctor, Vetlya, and Pirate Pundar.
- Exceptions can be edited here: `Data/Scripts/Library/RespawnExceptions.lua`

### One Planet Start

- Heroes spawn at the beginning of FTGU single planet start games, matching the era selected.
- Enabled Republic command staff and clones disabled in era 1.

### How to Edit GameConstants

To disable or edit the time for a respawn:

1. Go to `Data/XML`
2. Open `GameConstants.xml`
3. Find line (418): `<Default_Hero_Respawn_Time>400</Default_Hero_Respawn_Time>`
4. You can set it to a negative number to deactivate it in between saved games.

# License

All **original code** authored in this project is available under the [MIT License](LICENSE).

This repository depends on files derived from **EaWX mods**.
See [ASSETS.md](ASSETS.md) for details on third-party content and asset usage.

### Workshop Content

The `mod/` directory contains the files uploaded to the Steam Workshop.

# Credits

Thanks to the EaWX team for creating and maintaining the EaWX mods.

**Disclaimer**: This project is not affiliated with the EaWX team.

<img src="mod/Splash.png" alt="Splash image" width="128" style="float: right; margin-left: 1em; margin-bottom: 1em;">

# FotR Heroes Respawn

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

1. Go to `Data/XML`
2. Open `GameConstants.xml`
3. Find line (418): `<Default_Hero_Respawn_Time>400</Default_Hero_Respawn_Time>`
  - You can set it to a negative number to deactivate it in between saved games.

# License

All **original code** authored in this project is available under the [MIT License](LICENSE).

This repository depends on files derived from **EaWX mods**.
See [ASSETS.md](ASSETS.md) for details on third-party content and asset usage.

### Workshop Content

The `mod/` directory contains the files uploaded to the Steam Workshop.

# Credits

Thanks to the EaWX team for creating and maintaining the EaWX mods.

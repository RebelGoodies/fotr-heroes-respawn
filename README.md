**Disclaimer**: This project is not affiliated with the EaWX team.

<img src="mod/Splash.png" alt="Splash image" width="128" style="float: right; margin-left: 1em; margin-bottom: 1em;">

# FotR Heroes Respawn

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
2. Navigate to `Data/XML`
3. Open `GameConstants.xml`
4. Find the line (417): `<Default_Hero_Respawn_Time>400.0</Default_Hero_Respawn_Time>`
   - You can set it to a negative number to deactivate it in the late game.

### One Planet Start

Heroes now spawn at the beginning of FTGU single planet start games.
Grievous and Trench spawn after 15 and 30 weeks respectfully.

# License

All **original code** authored in this project is available under the [MIT License](LICENSE).

This repository depends on files derived from **EaWX mods**.
See [ASSETS.md](ASSETS.md) for details on third-party content and asset usage.

### Workshop Content

The `mod/` directory contains the files uploaded to the Steam Workshop.

# Credits

Thanks to the EaWX team for creating and maintaining the EaWX mods.

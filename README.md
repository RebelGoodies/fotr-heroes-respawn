**Disclaimer**: This project is not affiliated with the EaWX team.

# template-eawx-submod

Template repository for any EaWX submod.

## Setup Upstream

**Create vendor branch**
```
git checkout --orphan vendor-eawx
rm -r .
mkdir -p mod
```

**Import and merge upstream files**
```
git add mod
git commit -m "Import EaWX mod upstream files"
git checkout main
git merge vendor-eawx --allow-unrelated-histories
```

## EaWX Mods

- Thrawn's Revenge (TR)
- Fall of the Republic (FotR)
- Revan's Revenge (RR)

# License

All **original code** authored in this project is available under the [MIT License](LICENSE).

This repository depends on files derived from **EaWX mods**.
See [ASSETS.md](ASSETS.md) for details on third-party content and asset usage.

### Workshop Content

The `mod/` directory contains the files uploaded to the Steam Workshop.

# Credits

Thanks to the EaWX team for creating and maintaining the EaWX mods.

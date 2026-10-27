# pi profile: pi-starter

A shareable config profile for the [pi coding agent](https://github.com/earendil-works/pi), installed with the
pi-profile wrapper: https://github.com/AdrianTJ/pi-profiles

## Install

```sh
pi-profile install AdrianTJ/pi-starter
```

Packages declared in settings.json are re-fetched from npm/git on first launch —
nothing here is vendored.

## Notes

- `DESCRIPTION.md` ships with the pack, so `pi-profile list` shows a real summary instead of a generic placeholder. Edit it to match what you keep.
- Credentials (auth.json, models-store.json) are deliberately not included;
  they are symlinked from your global config at install time.
- Extension entries in settings.json pointing at absolute local paths won't
  resolve on other machines. Publish those extensions as npm/git packages.
- Trust model: installing a profile runs its declared packages, same as any
  npm install. Read settings.json before installing someone else's profile.

## Checks

`./check.sh` validates settings.json, rejects credential files, absolute local paths and leftover placeholders, and confirms the package list still matches [harness-configs](https://github.com/AdrianTJ/harness-configs) `pi/settings.json`. CI runs it on every push and weekly. `./check.sh --offline` skips the network comparison.

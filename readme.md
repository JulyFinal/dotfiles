
# final's dotfiles

## Nothing


## Fix locale bug

`nix-env -iA nixpkgs.glibcLocales`

`export LOCALE_ARCHIVE="$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive"`

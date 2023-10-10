{
  enable = true;
  envExtra = ''
    if [ -e /home/final/.nix-profile/etc/profile.d/nix.sh ]; then . /home/final/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
  '';
  initExtraFirst = ''
            '';
  initExtra = ''
            '';
}

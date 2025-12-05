{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "fusion-jetbrainsmaplemono";
  version = "1.2304.77";

  src = fetchzip {
    url = "https://github.com/SpaceTimee/Fusion-JetBrainsMapleMono/releases/download/1.2304.77/JetBrainsMapleMono-NF-XX-XX.zip";
    hash = "sha256-ZEjCIrQLzuLqIkDnbBAW3riel1rfGFntkV61lkMps6U=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -dm755 $out/share/fonts/truetype
    find . -type f -name '*.ttf' -print0 | while IFS= read -r -d '' font; do
      install -m644 "$font" $out/share/fonts/truetype/
    done
    runHook postInstall
  '';

  meta = {
    description = "Fusion JetBrains Mono + Maple Mono Nerd Font";
    homepage = "https://github.com/SpaceTimee/Fusion-JetBrainsMapleMono";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}

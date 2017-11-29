{ mkDerivation, base, jsaddle, jsaddle-warp, lens, reflex
, reflex-dom, reflex-dom-core, stdenv, text
}:
mkDerivation {
  pname = "frontend";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base jsaddle lens reflex reflex-dom text
  ];
  executableHaskellDepends = [
    base jsaddle-warp reflex-dom reflex-dom-core
  ];
  license = stdenv.lib.licenses.unfree;
}

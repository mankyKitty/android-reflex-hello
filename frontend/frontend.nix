{ mkDerivation, base, jsaddle-warp, reflex, reflex-dom
, reflex-dom-core, stdenv
}:
mkDerivation {
  pname = "frontend";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base reflex reflex-dom ];
  executableHaskellDepends = [
    base jsaddle-warp reflex-dom reflex-dom-core
  ];
  license = stdenv.lib.licenses.unfree;
}

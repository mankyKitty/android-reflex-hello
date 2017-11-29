(import ../reflex-platform {}).project ({ pkgs }: {
  packages = {
    frontend = ./frontend;
  };

  shells = {
    ghc = ["frontend"];
    ghcjs = ["frontend"];
  };

  android.frontend = {
    executableName = "frontexe";
    applicationId = "org.example.frontend";
    displayName = "Testing Android App";
  };
})

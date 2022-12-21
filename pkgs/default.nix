pkgs:
let
in rec {
  github.com = {
    wasmCloud = {
      otp = pkgs.callPackage ./wasmCloud/opt { };
    };
  };
}

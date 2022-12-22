{ lib, stdenv, makeWrapper, autoPatchelfHook, openssl_1_1, ncurses }:

stdenv.mkDerivation {
  pname = "wasmcloud-host";
  version = "0.59.0";
  src = builtins.fetchurl {
    url = "https://github.com/wasmCloud/wasmcloud-otp/releases/download/v0.59.0/aarch64-linux.tar.gz";
    sha256 = "1dqli192chvrps7ibrwyv9cyzc58khib49vbap93f03c63m6a67y";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  unpackCmd = ''
    mkdir -p root
    tar zxf $src -C root
  '';

  dontBuild = true;
  buildInputs = [
    openssl_1_1
    ncurses
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r bin $out/
    cp -r lib $out/
    cp -r releases $out/
    cp -r erts-12.3.1 $out/
    chmod +x $out/bin/wasmcloud_host
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/wasmCloud/wasmcloud-otp";
    description = "wasmCloud host runtime that leverages Elixir/OTP and Rust to provide simple, secure, distributed application development using the actor model";
  };
}

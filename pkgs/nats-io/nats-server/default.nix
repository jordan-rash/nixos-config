{ stdenv }:

stdenv.mkDerivation {
  pname = "nats-server";
  version = "2.9.10";
  src = builtins.fetchurl {
    url = "https://github.com/nats-io/nats-server/releases/download/v2.9.10/nats-server-v2.9.10-linux-arm64.tar.gz";
    sha256 = "1dqli192chvrps7ibrwyv9cyzc58khib49vbap93f03c63m6a67y";
  };

  unpackCmd = ''
    mkdir -p root
    tar zxf $src -C root
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r nats-server $out/bin
    chmod +x $out/bin/nats-server
  '';

  meta = {
    homepage = "https://github.com/nats-io/nats-server";
    description = "High-Performance server for NATS.io, the cloud and edge native messaging system";
  };
}

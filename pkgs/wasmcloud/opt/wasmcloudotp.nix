{ stdenv, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "wasmcloud-otp";
  version = "0.59.0";

  src = fetchFromGitHub
    {
      owner = "wasmCloud";
      repo = "wasmcloud-otp";
      rev = "d4ffb1790119e118aa406cc8a31d46d907f00ee0";
      sha256 = "AhJ8NfyJbjPYK1D9L5L9uNRwE5sR/evg/T459J/Bn0U=";
    }

    nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper $src/wasmcloud-host $out/bin/wasmcloud-host
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/wasmCloud/wasmcloud-otp";
    description = "wasmCloud host runtime that leverages Elixir/OTP and Rust to provide simple, secure, distributed application development using the actor model";
    license = licenses.apache;
  };
}

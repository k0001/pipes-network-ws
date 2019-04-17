{ mkDerivation, base, bytestring, network-simple-ws, pipes, stdenv
}:
mkDerivation {
  pname = "pipes-network-ws";
  version = "0.1";
  src = ./.;
  libraryHaskellDepends = [
    base bytestring network-simple-ws pipes
  ];
  homepage = "https://github.com/k0001/pipes-network-ws";
  description = "WebSockets support for pipes";
  license = stdenv.lib.licenses.bsd3;
}

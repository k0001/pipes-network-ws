{ pkgs }:

let
src-network-simple-ws = builtins.fetchGit {
  url = "https://github.com/k0001/network-simple-ws";
  rev = "07dbf69a119682ce5594821ae86998f3e3499e88";
};

in
pkgs.lib.composeExtensions
  (import "${src-network-simple-ws}/hs-overlay.nix" { inherit pkgs; })
  (self: super: {
    pipes-network-ws = super.callPackage ./pkg.nix {};
  })

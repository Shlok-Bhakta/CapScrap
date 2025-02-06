{
  description = "Ruby on Rails development environment with PostgreSQL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ruby
            yarn
            postgresql_17
            lazydocker
            rainfrog
            heroku
            # fixes issue with psych
            libyaml
        ];

          shellHook = ''

            export GEM_HOME=$PWD/.gem
            export PATH=$GEM_HOME/bin:$PATH  
            zsh
          
            alias rf="rainfrog -u postgres://shlok:shlok@kiwi:38787/test"
            
          '';
        };
      }
    );
}

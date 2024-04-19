# Flake for snx-rs

This flake builds [snx-rs](https://github.com/ancwrd1/snx-rs), a client for that crappy vpn client used in my day job.

# Usage as a flake

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/denisfalqueto/snx-rs-flake/badge)](https://flakehub.com/flake/denisfalqueto/snx-rs-flake)

Add snx-rs-flake to your `flake.nix`:

```nix
{
  inputs.snx-rs-flake.url = "https://flakehub.com/f/denisfalqueto/snx-rs-flake/*.tar.gz";

  outputs = { self, snx-rs-flake }: {
    # Use in your outputs
  };
}

```

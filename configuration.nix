{ config, pkgs, options, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    # <nixos-hardware/raspberry-pi/4>
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];
  };

  boot.loader.raspberryPi = {
    enable = true;
    version = 4;
  };

  boot.loader.generic-extlinux-compatible.enable = false;
  boot.loader.grub.enable = false;

  networking.hostName = "quinn"; # Define your hostname. 
  networking.hostId = "9fba890c";
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "America/Denver";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jordan = {
    isNormalUser = true;
    home = "/home/jordan";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user. 
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG6/XRUB4ulC26lbRjP2eaJNGZVzpeKGm4z74O9vrDZ jordan" ];
    hashedPassword = "*";
  };

  environment.systemPackages = with pkgs; [ neovim tailscale ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = "no";
  };

  services.tailscale.enable = true;
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)" 
      if [ $status = "Running" ]; then # if so, then do nothing 
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up --ssh -authkey tskey-auth-kEH8cN1CNTRL-Emz9RTCVnkb8HkMdV7RBfbUGVut89KTb '';
  };

  networking.firewall = {
    # enable the firewall
    enable = true;
    checkReversePath = "loose";

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "eth0" "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [ 22 2222 ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.nixPath =
    options.nix.nixPath.default ++
    [
      "nixpkgs-overlays=/etc/nixos/overlays/"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
  system.stateVersion = "22.05"; # Did you read the comment?
}


{
  lib,
  pkgs,
  ...
}: {
  # Ensure zsh package installed
  home.packages = with pkgs; [
    zsh
  ];

  # Zsh shell configuration
  programs.zsh = {
    enable = true;
    #enableCompletion = true;
    shellAliases = {
      ff = "fastfetch";

      # Root & rescue
      god = "sudo su";
      fuck = "sudo $(fc -ln -1)";
      pls = "sudo"; # Polite sudo

      # System
      cls = "clear";
      test = "sudo nixos-rebuild build --flake .#oryn-nixos"; #catch errors
      rebuild = "sudo nixos-rebuild switch --flake .#oryn-nixos";
      rebuildboot = "sudo nixos-rebuild boot --flake .#oryn-nixos";
      gc = "sudo nix-collect-garbage -d";
      clean = "sudo /etc/nixos/scripts/oryn_cleanup.sh";
      update = "sudo nix flake update && sudo nixos-rebuild switch --flake .#oryn-nixos";

      # git
      g = "git";
      gs = "git status";
      ga = "git add .";
      gcm = "git commit -m";
      gp = "git push";
      gl = "git log --oneline --graph";
      gaa = "git add --all";
      gcam = "git commit --all --message";
      gcl = "git clone";
      gco = "git checkout";

      # kubectl
      k = "kubectl";
      kgno = "kubectl get node";
      kdno = "kubectl describe node";
      kgp = "kubectl get pods";
      kep = "kubectl edit pods";
      kdp = "kubectl describe pods";
      kdelp = "kubectl delete pods";
      kgs = "kubectl get svc";
      kes = "kubectl edit svc";
      kds = "kubectl describe svc";
      kdels = "kubectl delete svc";
      kgi = "kubectl get ingress";
      kei = "kubectl edit ingress";
      kdi = "kubectl describe ingress";
      kdeli = "kubectl delete ingress";
      kgns = "kubectl get namespaces";
      kens = "kubectl edit namespace";
      kdns = "kubectl describe namespace";
      kdelns = "kubectl delete namespace";
      kgd = "kubectl get deployment";
      ked = "kubectl edit deployment";
      kdd = "kubectl describe deployment";
      kdeld = "kubectl delete deployment";
      kgsec = "kubectl get secret";
      kdsec = "kubectl describe secret";
      kdelsec = "kubectl delete secret";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      ls = "eza --icons always"; # default view
      ll = "eza -bhl --icons --group-directories-first"; # long list
      la = "eza -abhl --icons --group-directories-first"; # all list
      lt = "eza --tree --level=3 --icons"; # tree
      du = "dust";
      df = "dysk";
    };
    initContent = ''
      eval "$(starship init zsh)"
    '';
  };
}

<h1 align="center">OrynOS - A Declarative Digital Sanctum</h1>

<p align="center">
  <em>"Within these lines, a digital world takes form,
  <br>Crafted with Nix, resilient to any storm."</em>
  <br><br>
  </p>
  

<div align="center">
  <a href="https://github.com/NixOS/nixpkgs/tree/nixos-unstable">
    <img src="https://img.shields.io/badge/NixOS-unstable-d72638.svg?style=for-the-badge&logo=nixos&logoColor=ffffff" alt="NixOS Unstable"/>
  </a>
  <a href="https://hyprland.org/">
    <img src="https://img.shields.io/badge/Compositor-Hyprland-1e8bac.svg?style=for-the-badge&logo=hyprland&logoColor=ffffff" alt="Hyprland"/>
  </a>
  <a href="https://github.com/OrynVail/OrynOS/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-88b92d.svg?style=for-the-badge&logo=opensourceinitiative&logoColor=ffffff" alt="License: MIT"/>
  </a>
  <a href="https://github.com/OrynVail/OrynOS/stargazers">
    <img src="https://img.shields.io/github/stars/OrynVail/OrynOS?style=for-the-badge&logo=github&color=f19d1a&logoColor=1d2021" alt="GitHub Stars"/>
  </a>
  <a href="https://github.com/OrynVail/OrynOS/commits/main">
    <img src="https://img.shields.io/github/last-commit/OrynVail/OrynOS?style=for-the-badge&logo=git&color=1ba595&logoColor=ffffff" alt="Last Commit"/>
  </a>
</div>


---

## 🌟 Overview

<div align="center" style="margin-bottom: 20px;">
  <img src="./preview/4.png" alt="OrynOS Desktop Preview" style="max-width: 80%; height: auto; border-radius: 8px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);">
</div>


Welcome, traveler, to the heart of **OrynOS** – a meticulously sculpted NixOS configuration that transcends mere dotfiles. This repository is the digital loom upon which a personalized, performant, sovereign, and perfectly reproducible computing experience is woven.

What began as a journey through various digital landscapes has culminated in this current form: a swift Hyprland session, launched directly from the bare TTY for uncompromised speed and display fidelity, built upon the robust foundation of the [Hydenix](https://github.com/richen604/hydenix) framework.

### 🎯 Key Features

| Feature | Description |
|---------|-------------|
| **🔄 Declarative** | Every configuration is code – reproducible and version-controlled |
| **⚡ Performance** | TTY-direct Hyprland for maximum speed and minimal overhead |
| **🔒 Sovereign** | Privacy-focused, telemetry-free, complete control |
| **🎨 Aesthetic** | True dark theme with the custom Helios color palette |
| **🧩 Modular** | Clean separation of concerns for maintainability |
| **🛡️ Secure** | Lanzaboote integration for UEFI Secure Boot |
| **🖌️ Themes** | swww Wallpaper daemon + Theme select + Rofi launcher select |
| **⚙️ System UI** | Wlogout + hyprlock + hypridle + Game Launcher |


---

## 📸 Gallery

<table align="center" style="border: none; margin-left: auto; margin-right: auto;"> <tr> <td align="center" width="33%" style="border: none; padding: 10px;"> <img src="./preview/1.png" alt="Showcase Preview 1" style="max-width:100%; height:auto; display: block; margin-left: auto; margin-right: auto;"> <br> </td> <td align="center" width="33%" style="border: none; padding: 10px;"> <img src="./preview/2.png" alt="Showcase Preview 2" style="max-width:100%; height:auto; display: block; margin-left: auto; margin-right: auto;"> <br> </td> <td align="center" width="33%" style="border: none; padding: 10px;"> <img src="./preview/3.png" alt="Showcase Preview 3" style="max-width:100%; height:auto; display: block; margin-left: auto; margin-right: auto;"> <br> </td> </tr> </table>


---

## 🔮 Philosophy: Sovereignty Through Code

| Principle                   | Implementation                                                                           |
| --------------------------- | ---------------------------------------------------------------------------------------- |
| **🔄 Declarative Purity**   | System described, not configured – Nix translates descriptions into immutable reality    |
| **♻️ Reproducibility**      | Consistent builds across time and hardware – your environment as version-controlled code |
| **⚡ Performance & Control** | Direct TTY → Hyprland for raw speed and complete display dominion                        |
| **🧩 Modularity & Clarity** | Logical separation in `programs/`, `hosts/`, and `home/` for maintainable complexity     |
| **🔒 Digital Sovereignty**  | Freedom from telemetry, tracking, and opaque processes                                   |
| **🌑 Dark Aesthetic**       | Dark and deep aesthetic theme via custom Helios palette + Hydenix modules                |

---

## 🚀 Technology Stack


<div align="center">

<a href="https://nixos.org/">
  <img src="https://img.shields.io/badge/NixOS Unstable -d72638?style=for-the-badge&logo=nixos&logoColor=ffffff" alt="NixOS"/>
</a>
<a href="https://nixos.wiki/wiki/Flakes">
  <img src="https://img.shields.io/badge/Nix_Flakes-1e8bac?style=for-the-badge&logo=nix&logoColor=ffffff" alt="Nix Flakes"/>
</a>
<a href="https://github.com/nix-community/home-manager">
  <img src="https://img.shields.io/badge/Home_Manager-1ba595?style=for-the-badge&logo=nix&logoColor=ffffff" alt="Home Manager"/>
</a>

<a href="https://hyprland.org/">
  <img src="https://img.shields.io/badge/Hyprland-d72638.svg?style=for-the-badge&logo=hyprland&logoColor=ffffff" alt="Hyprland"/>
</a>
<a href="https://wayland.freedesktop.org/">
  <img src="https://img.shields.io/badge/Wayland-eb8413.svg?style=for-the-badge&logo=wayland&logoColor=ffffff" alt="Wayland"/>
</a>
<a href="https://en.wikipedia.org/wiki/Linux_console">
  <img src="https://img.shields.io/badge/TTY_Login-f19d1a.svg?style=for-the-badge&logo=gnometerminal&logoColor=1d2021" alt="TTY Login"/>
</a>

<a href="https://github.com/nix-community/lanzaboote">
  <img src="https://img.shields.io/badge/Lanzaboote-d72638.svg?style=for-the-badge&logo=rocket&logoColor=ffffff" alt="Lanzaboote"/>
</a>
<a href="https://en.wikipedia.org/wiki/UEFI">
  <img src="https://img.shields.io/badge/UEFI_Secure_Boot-88b92d.svg?style=for-the-badge&logo=uefi&logoColor=ffffff" alt="UEFI Secure Boot"/>
</a>

</div>

---

## 🛠️ Quick Start

### Prerequisites

- NixOS with flakes enabled
- Home Manager (optional for user-only configs)

### Installation

```bash
# Clone the repository
git clone https://github.com/OrynVail/OrynOS.git
cd OrynOS

# Build and switch the NixOS system configuration
sudo nixos-rebuild switch --flake .#oryn-nixos

# Optional: Build standalone Home Manager configuration
home-manager switch --flake .#oryn@oryn-nixos
```

Customization
 * Hardware: Modify hosts/oryn-nixos/hardware-configuration.nix
 * Programs: Add/modify application configs in programs/
 * Host Settings: Customize system settings in hosts/oryn-nixos/default.nix

---

## 🔧 Maintenance

### Cleanup & Optimization

OrynOS includes custom maintenance scripts:

```bash
# Interactive system cleanup
./scripts/oryn_cleanup.sh (zsh alias="clean")

# System audit 
./scripts/oryn_audit.sh
```

### Updates

```bash
# Update flake inputs
nix flake update

# Rebuild with latest changes
sudo nixos-rebuild switch --flake .#oryn-nixos
```

---
## 📊 Statistics

<div align="center">
<img src="https://img.shields.io/github/repo-size/OrynVail/OrynOS.svg?style=for-the-badge&logo=github&color=f19d1a&logoColor=1d2021" alt="GitHub repo size"/>
<img src="https://img.shields.io/github/languages/code-size/OrynVail/OrynOS.svg?style=for-the-badge&logo=github&color=be4264&logoColor=ffffff" alt="Code Size"/>
</div>


---
## 🤝 Contributing

Contributions are welcome! 
Ways to Contribute
 * 🐛 Report bugs or issues
 * 💡 Suggest new features or improvements
 * 📝 Improve documentation

---
## 📜 License

This project is licensed under the MIT License - see the [`LICENSE`](LICENSE) file for details.


---
## 🙏 Acknowledgments

 * NixOS Community - For the incredible ecosystem
 * Hydenix Framework - Foundation and inspiration
 * Hyprland - The amazing Wayland compositor

 ---
## 🌟 Support OrynOS

<h3 align=center>If you find this project useful, consider:</h3>
<div align="center">
<a href="https://github.com/OrynVail/OrynOS/stargazers">
<img src="https://img.shields.io/badge/⭐_Star_this_repo-d72638.svg?style=for-the-badge&logo=star&logoColor=ffffff" alt="Star this repo"/>
</a>
</div>

<h4 align=center>❄️ by Oryn</h4>




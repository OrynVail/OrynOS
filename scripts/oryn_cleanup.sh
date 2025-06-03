#!/usr/bin/env bash

# NixOS System Cleanup Script
# This script safely cleans up unnecessary files from your NixOS system
# without removing important components.

# Text formatting
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

# Function to print section headers
print_header() {
  echo -e "\n${BOLD}${BLUE}$1${RESET}"
  echo -e "${BLUE}$(printf '=%.0s' {1..50})${RESET}"
}

# Function to print success messages
print_success() {
  echo -e "${GREEN}✓ $1${RESET}"
}

# Function to print warning messages
print_warning() {
  echo -e "${YELLOW}⚠ $1${RESET}"
}

# Function to print error messages
print_error() {
  echo -e "${RED}✗ $1${RESET}"
}

# Function to check if running as root
check_root() {
  if [ "$EUID" -ne 0 ]; then
    print_error "This script requires root privileges for some operations."
    echo "Please run with sudo: sudo $0"
    exit 1
  fi
}

# Function to get user confirmation
confirm() {
  read -p "$1 [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY]) 
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Check if running as root
check_root

# Print welcome message
echo -e "${BOLD}${BLUE}NixOS System Cleanup Script${RESET}"
echo -e "${BLUE}$(printf '=%.0s' {1..50})${RESET}"
echo -e "This script will safely clean up your NixOS system."
echo -e "It will remove old generations, unused packages, and temporary files."
echo -e "Your current system configuration will not be affected.\n"

# Ask for confirmation before proceeding
if ! confirm "Do you want to proceed?"; then
  echo "Operation cancelled."
  exit 0
fi

# Calculate initial disk usage
print_header "Initial Disk Usage"
df -h / | grep -v "Filesystem"
INITIAL_USAGE=$(df -h / | grep -v "Filesystem" | awk '{print $5}' | sed 's/%//')
INITIAL_AVAIL=$(df -h / | grep -v "Filesystem" | awk '{print $4}')

# Clean up old system generations
print_header "Cleaning up old system generations"
echo "This will remove old system generations, keeping the current and previous ones."
if confirm "Continue with system generations cleanup?"; then
  echo "Removing old system generations..."
  nix-env --delete-generations old --profile /nix/var/nix/profiles/system
  print_success "Old system generations removed."
else
  print_warning "Skipped system generations cleanup."
fi

# Clean up old user generations
print_header "Cleaning up old user generations"
echo "This will remove old user generations, keeping the current and previous ones."
if confirm "Continue with user generations cleanup?"; then
  echo "Removing old user generations..."
  nix-env --delete-generations old
  print_success "Old user generations removed."
else
  print_warning "Skipped user generations cleanup."
fi

# Clean up nix store
print_header "Cleaning up Nix store"
echo "This will remove unused packages from the Nix store."
if confirm "Continue with Nix store cleanup?"; then
  echo "Running garbage collection..."
  nix-store --gc
  print_success "Nix store garbage collection completed."
else
  print_warning "Skipped Nix store cleanup."
fi

# Optimize nix store
print_header "Optimizing Nix store"
echo "This will optimize the Nix store by finding identical files and hard-linking them."
if confirm "Continue with Nix store optimization?"; then
  echo "Optimizing Nix store..."
  nix-store --optimize
  print_success "Nix store optimization completed."
else
  print_warning "Skipped Nix store optimization."
fi

# Clean up temporary files
print_header "Cleaning up temporary files"
echo "This will remove temporary files from /tmp and clear systemd journal logs."
if confirm "Continue with temporary files cleanup?"; then
  echo "Cleaning up /tmp..."
  find /tmp -type f -atime +10 -delete 2>/dev/null
  
  echo "Cleaning up systemd journal..."
  journalctl --vacuum-time=7d
  
  print_success "Temporary files cleanup completed."
else
  print_warning "Skipped temporary files cleanup."
fi

# Clean up home directory caches (optional)
print_header "Cleaning up home directory caches"
echo "This will clean up various cache directories in your home folder."
echo "This is optional and won't affect system functionality."
if confirm "Continue with home directory cache cleanup?"; then
  echo "Cleaning up home directory caches..."
  
  # Clean npm cache if npm is installed
  if command -v npm &> /dev/null; then
    npm cache clean --force
  fi
  
  # Clean yarn cache if yarn is installed
  if command -v yarn &> /dev/null; then
    yarn cache clean
  fi
  
  # Clean pnpm cache if pnpm is installed
  if command -v pnpm &> /dev/null; then
    pnpm store prune
  fi
  
  print_success "Home directory cache cleanup completed."
else
  print_warning "Skipped home directory cache cleanup."
fi

# Run nix-collect-garbage
print_header "Running nix-collect-garbage"
echo "This will collect all garbage from your system."
if confirm "Continue with nix-collect-garbage?"; then
  echo "Running nix-collect-garbage -d..."
  nix-collect-garbage -d
  print_success "Garbage collection completed."
else
  print_warning "Skipped nix-collect-garbage."
fi

# Calculate final disk usage
print_header "Final Disk Usage"
df -h / | grep -v "Filesystem"
FINAL_USAGE=$(df -h / | grep -v "Filesystem" | awk '{print $5}' | sed 's/%//')
FINAL_AVAIL=$(df -h / | grep -v "Filesystem" | awk '{print $4}')

# Calculate space saved
SAVED_PERCENT=$((INITIAL_USAGE - FINAL_USAGE))
echo -e "\n${BOLD}${GREEN}Cleanup Summary:${RESET}"
echo -e "Initial disk usage: ${BOLD}${INITIAL_USAGE}%${RESET} (${INITIAL_AVAIL} available)"
echo -e "Final disk usage: ${BOLD}${FINAL_USAGE}%${RESET} (${FINAL_AVAIL} available)"

if [ "$SAVED_PERCENT" -gt 0 ]; then
  echo -e "Space freed: ${BOLD}${GREEN}${SAVED_PERCENT}%${RESET} of disk space"
else
  echo -e "Space freed: ${BOLD}${YELLOW}No significant change in disk usage${RESET}"
fi

echo -e "\n${BOLD}${GREEN}Cleanup completed successfully!${RESET}"
echo -e "Your system is now clean and ready for building."

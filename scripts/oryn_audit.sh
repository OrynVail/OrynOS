#!/usr/bin/env bash

# OrynAudit Script
# Version: 1.0
# Description: A comprehensive security and system audit script for NixOS
# "Here's everything you forgot about your machine"

# --- Configuration ---
# Set to 1 to enable verbose debugging output
DEBUG=0
# Output file location
OUTPUT_FILE="/tmp/oryn_audit-$(date +%Y%m%d-%H%M%S).md"
# List of known safe SUID binaries (add more if needed for your system)
KNOWN_SAFE_SUID=("sudo" "su" "passwd" "ping" "mount" "umount" "fusermount" "pkexec" "ssh-keysign" "crontab" "at" "chsh" "chfn" "newgrp" "expiry" "unix_chkpwd" "gpasswd")
# List of known safe SGID binaries (add more if needed)
KNOWN_SAFE_SGID=("wall" "write" "ssh-agent" "unix_chkpwd" "utempter")
# Threshold for high disk usage warning (%)
HIGH_DISK_USAGE_THRESHOLD=90
# Threshold for medium disk usage warning (%)
MEDIUM_DISK_USAGE_THRESHOLD=80
# Threshold for high CPU usage warning for root processes (%)
HIGH_CPU_ROOT_THRESHOLD=10.0

# --- Text Formatting ---
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PURPLE="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"

# --- Global Variables ---
AUDIT_DATE=$(date "+%Y-%m-%d %H:%M:%S")
HOSTNAME=$(hostname)
KERNEL_VERSION=$(uname -r)
CURRENT_USER=$(whoami)
NIXOS_VERSION=$(nixos-version 2>/dev/null || echo "Unknown")

NIXOS_GENERATION_PATH=$(readlink -f /run/current-system 2>/dev/null)
if [[ -n "$NIXOS_GENERATION_PATH" && "$NIXOS_GENERATION_PATH" != "/run/current-system" ]]; then
    NIXOS_GENERATION_NUM=$(nix-env --list-generations -p /nix/var/nix/profiles/system 2>/dev/null | grep -w current | awk '{print $1}' 2>/dev/null)
    if [[ -n "$NIXOS_GENERATION_NUM" ]]; then
        NIXOS_GENERATION="$NIXOS_GENERATION_NUM (Path: $NIXOS_GENERATION_PATH)"
    else
        # Fallback to trying to parse from the path if nix-env method fails
        NIXOS_GENERATION="Path: $NIXOS_GENERATION_PATH (Num N/A)"
    fi
else
    NIXOS_GENERATION="Unknown"
fi

AUDIT_OUTPUT_BUFFER=""
HIGH_FINDINGS=0
MEDIUM_FINDINGS=0
LOW_FINDINGS=0
GOOD_FINDINGS=0

# --- Helper Functions ---

# Debugging output function
debug_log() {
    if [[ "$DEBUG" -eq 1 ]]; then
        echo -e "${CYAN}[DEBUG] $1${RESET}" >&2
    fi
}

# Print section headers 
print_header() {
    local title="$1"
    echo -e "\n${BOLD}${BLUE}### $title ###${RESET}"
    echo -e "${BLUE}$(printf ".%.0s" {1..60})${RESET}"
    echo -e "\n## $title\n" >> "$OUTPUT_FILE"
}

# Print sub-headers 
print_subheader() {
    local title="$1"
    echo -e "\n${BOLD}${PURPLE}--- $title ---${RESET}"
    echo -e "\n### $title\n" >> "$OUTPUT_FILE"
}

# Print findings and count them
print_finding() {
    local level=$1
    local message=$2
    local finding_text=""
    local finding_md=""

    case $level in
        "high")
            finding_text="${RED}🔴 HIGH:${RESET} $message"
            finding_md="- **🔴 HIGH:** $message"
            ((HIGH_FINDINGS++))
            ;;
        "medium")
            finding_text="${YELLOW}🟡 MEDIUM:${RESET} $message"
            finding_md="- **🟡 MEDIUM:** $message"
            ((MEDIUM_FINDINGS++))
            ;;
        "low" | "info")
            finding_text="${CYAN}🔵 INFO:${RESET} $message"
            finding_md="- **🔵 INFO:** $message"
            ((LOW_FINDINGS++))
            ;;
        "good")
            finding_text="${GREEN}✅ GOOD:${RESET} $message"
            finding_md="- **✅ GOOD:** $message"
            ((GOOD_FINDINGS++))
            ;;
        *)
            finding_text="${CYAN}🔵 INFO:${RESET} $message" # Default to info
            finding_md="- **🔵 INFO:** $message"
            ((LOW_FINDINGS++))
            ;;
    esac
    echo -e "  $finding_text"
    echo -e "$finding_md" >> "$OUTPUT_FILE"
    # Append to buffer for live summary (optional)
    AUDIT_OUTPUT_BUFFER+="$finding_text\n"
}

# Add raw text or command output to the report file
add_to_report() {
    echo -e "$1" >> "$OUTPUT_FILE"
}

# Add code blocks to the report file
add_code_block() {
    echo -e "\n\`\`\`\n$1\n\`\`\`\n" >> "$OUTPUT_FILE"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a string is in an array
contains_element() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

# Write the initial markdown header
write_md_header() {
    debug_log "Writing Markdown header to $OUTPUT_FILE"
    cat > "$OUTPUT_FILE" << EOF
# OrynAudit Report

**Generated:** $AUDIT_DATE
**Host:** $HOSTNAME
**User:** $CURRENT_USER
**Kernel:** $KERNEL_VERSION
**NixOS Version:** $NIXOS_VERSION
**NixOS Generation:** $NIXOS_GENERATION

---
EOF
    debug_log "Markdown header written."
}

# Function to check dependencies
check_dependencies() {
    print_header "Dependency Check"
    local missing_critical=()
    local missing_optional=()
    local critical_tools=("ss" "find" "ps" "grep" "awk" "sed" "cut" "stat" "systemctl" "getent" "df" "free" "uname" "hostname" "date")
    local optional_tools=("nixos-version" "nixos-version-list" "nix-channel" "nix-store" "nft" "dig" "bc" "lsblk" "lscpu" "lspci" "lsusb" "docker" "podman" "journalctl" "sshd")

    debug_log "Checking critical dependencies: ${critical_tools[*]}"
    for tool in "${critical_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_critical+=("$tool")
        fi
    done

    if [[ ${#missing_critical[@]} -gt 0 ]]; then
        print_finding "high" "Missing critical tools: ${missing_critical[*]}. Audit cannot continue."
        add_to_report "**ERROR:** Missing critical tools: ${missing_critical[*]}. Audit aborted."
        exit 1
    else
        print_finding "good" "All critical dependencies met."
    fi

    debug_log "Checking optional dependencies: ${optional_tools[*]}"
    for tool in "${optional_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_optional+=("$tool")
        fi
    done

    if [[ ${#missing_optional[@]} -gt 0 ]]; then
        print_finding "low" "Missing optional tools: ${missing_optional[*]}. Some checks may be skipped or limited."
        add_to_report "**INFO:** Missing optional tools: ${missing_optional[*]}. Some checks may be skipped or limited."
    else
        print_finding "good" "All optional dependencies found."
    fi
}

# --- Audit Functions ---

# --- Audit Function: System Information ---

audit_system_info() {
    print_header "System Information"
    add_code_block "Gathering basic system details..."

    print_subheader "Basic System Info"
    add_to_report "- **Hostname:** $HOSTNAME"
    add_to_report "- **Kernel Version:** $KERNEL_VERSION"
    
    local os_pretty_name="N/A"
    if [[ -f /etc/os-release ]]; then
        os_pretty_name_temp=$(. /etc/os-release && echo "$PRETTY_NAME")
        if [[ -n "$os_pretty_name_temp" ]]; then
            os_pretty_name="$os_pretty_name_temp"
        elif command_exists lsb_release; then # Fallback for some systems
            os_pretty_name_temp=$(lsb_release -ds 2>/dev/null)
             if [[ -n "$os_pretty_name_temp" ]]; then
                os_pretty_name="$os_pretty_name_temp"
            fi
        fi
    fi
    
    add_to_report "- **Operating System:** $os_pretty_name"
    add_to_report "- **NixOS Version:** $NIXOS_VERSION"
    add_to_report "- **NixOS Generation:** $NIXOS_GENERATION"
    
    local system_uptime_p=$(uptime -p 2>/dev/null)
    if [[ -n "$system_uptime_p" ]]; then
        add_to_report "- **System Uptime:** $system_uptime_p"
    else
        add_to_report "- **System Uptime:** N/A (or 'uptime -p' produced no output)"
    fi
    
    local current_load_avg=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^ *//' 2>/dev/null)
    if [[ -n "$current_load_avg" ]]; then
        add_to_report "- **Current Load Average:** $current_load_avg"
    else
        # If 'uptime' failed entirely, try to get at least the load from /proc/loadavg
        if [[ -f /proc/loadavg ]]; then
            current_load_avg=$(awk '{print $1 ", " $2 ", " $3}' /proc/loadavg)
            add_to_report "- **Current Load Average (from /proc/loadavg):** $current_load_avg"
        else
            add_to_report "- **Current Load Average:** N/A"
        fi
    fi
    print_finding "good" "Basic system information collected."

    print_subheader "Memory Usage"
    if command_exists free; then
        local mem_info=$(free -h)
        add_to_report "**Memory Details:**"
        add_code_block "$mem_info"
        local mem_line=$(echo "$mem_info" | grep "Mem:")
        local mem_used=$(echo "$mem_line" | awk '{print $3}')
        local mem_total=$(echo "$mem_line" | awk '{print $2}')
        print_finding "low" "Memory Usage: $mem_used / $mem_total"

        local swap_info=$(echo "$mem_info" | grep "Swap:")
        local swap_total=$(echo "$swap_info" | awk '{print $2}')
        if [[ "$swap_total" == "0B" ]] || [[ -z "$swap_total" ]]; then
             print_finding "medium" "No swap space configured or detected."
             add_to_report "- **Swap:** No swap configured."
        else
            local swap_used=$(echo "$swap_info" | awk '{print $3}')
            print_finding "low" "Swap Usage: $swap_used / $swap_total"
            add_to_report "- **Swap:** $swap_used / $swap_total"
        fi
    else
        print_finding "medium" "'free' command not found. Cannot report memory usage."
        add_to_report "**Memory Details:** 'free' command not found."
    fi

    print_subheader "Disk Usage"
    if command_exists df; then
        add_to_report "**Filesystem Mounts and Usage:**"
        local df_output=$(df -hT | grep -vE "^tmpfs|^udev|docker|overlay|squashfs")
        add_code_block "$df_output"
        echo "$df_output" | grep -E "^/dev/" | while IFS= read -r line; do
            local usage=$(echo "$line" | awk '{print $6}' | sed 's/%//')
            local mount=$(echo "$line" | awk '{print $7}')
            local fstype=$(echo "$line" | awk '{print $2}')
            local size=$(echo "$line" | awk '{print $3}')
            local used=$(echo "$line" | awk '{print $4}')

            if [[ "$usage" -ge "$HIGH_DISK_USAGE_THRESHOLD" ]]; then
                print_finding "high" "Disk usage critical: $mount ($fstype) is ${usage}% full ($used/$size)."
            elif [[ "$usage" -ge "$MEDIUM_DISK_USAGE_THRESHOLD" ]]; then
                print_finding "medium" "Disk usage high: $mount ($fstype) is ${usage}% full ($used/$size)."
            else
                print_finding "good" "Disk usage OK: $mount ($fstype) is ${usage}% full ($used/$size)."
            fi
        done
    else
        print_finding "medium" "'df' command not found. Cannot report disk usage."
        add_to_report "**Disk Usage:** 'df' command not found."
    fi
}

# --- Audit Function: NixOS Specific Checks ---

audit_nixos_specifics() {
    print_header "NixOS Specific Checks"
    
    if [[ "$NIXOS_VERSION" == "Unknown" ]]; then
        print_finding "low" "Not a NixOS system or nixos-version not found. Skipping NixOS specific checks."
        add_to_report "This does not appear to be a NixOS system or the nixos-version command is not available. NixOS specific checks skipped."
        return
    fi
    
    print_finding "good" "NixOS detected: $NIXOS_VERSION"
    add_to_report "Performing NixOS-specific security and configuration checks."
    
    print_subheader "NixOS Configuration"
    local nix_config="/etc/nixos/configuration.nix"
    if [[ -f "$nix_config" ]]; then
        local config_mod_time=$(stat -c %y "$nix_config" 2>/dev/null || echo 'N/A')
        print_finding "low" "NixOS configuration file found: $nix_config (Last modified: $config_mod_time)"
        add_to_report "- **Configuration file:** $nix_config (Last modified: $config_mod_time)"
        
        # Check firewall configuration
        if grep -qE "^\s*networking.firewall.enable\s*=\s*true\s*;" "$nix_config" 2>/dev/null; then
            print_finding "good" "NixOS firewall is declaratively enabled in configuration.nix"
            add_to_report "- **Firewall:** Declaratively enabled in configuration"
        elif grep -qE "^\s*networking.firewall.enable\s*=\s*false\s*;" "$nix_config" 2>/dev/null; then
            print_finding "medium" "NixOS firewall is declaratively disabled in configuration.nix"
            add_to_report "- **Firewall:** Declaratively disabled in configuration"
        else
            print_finding "low" "NixOS firewall state in configuration.nix not determined (might be default, complex expression, or not set)"
            add_to_report "- **Firewall:** Status in configuration undetermined"
        fi
        
        # Check user mutability
        if grep -qE "^\s*users.mutableUsers\s*=\s*false\s*;" "$nix_config" 2>/dev/null; then
            print_finding "good" "Immutable users configured (users.mutableUsers = false)"
            add_to_report "- **User Mutability:** Immutable users configured (users.mutableUsers = false)"
        elif grep -qE "^\s*users.mutableUsers\s*=\s*true\s*;" "$nix_config" 2>/dev/null; then
            print_finding "medium" "Mutable users configured (users.mutableUsers = true). This is non-standard for persistent user home state management in NixOS."
            add_to_report "- **User Mutability:** Mutable users configured (users.mutableUsers = true)"
        else
            print_finding "low" "User mutability (users.mutableUsers) not explicitly set in configuration.nix (likely defaults to immutable)"
            add_to_report "- **User Mutability:** Not explicitly set (likely defaults to immutable)"
        fi
        
        # Check for allowed TCP ports
        local open_ports=$(grep -h "networking.firewall.allowedTCPPorts" /etc/nixos/**/*.nix 2>/dev/null | sed 's/.*= \[\(.*\)\];/\1/')
        if [[ -n "$open_ports" ]]; then
            print_finding "medium" "Firewall ports opened in configuration: $open_ports"
            add_to_report "- **Open TCP Ports in Config:** $open_ports"
        else
            print_finding "good" "No explicitly opened TCP ports found in firewall configuration"
            add_to_report "- **Open TCP Ports in Config:** None found"
        fi
    else
        print_finding "low" "NixOS configuration file $nix_config not found. (May be in a non-standard path)"
        add_to_report "- **Configuration file:** $nix_config not found (may be in a non-standard path)"
    fi
    
    print_subheader "Nix Channel Status"
    if command_exists nix-channel; then
        local channels_output=$(nix-channel --list 2>/dev/null)
        if [[ -n "$channels_output" ]]; then
            print_finding "low" "Nix channels configured for root:"
            add_to_report "**Nix Channels for root:**"
            add_code_block "$channels_output"
            
            # Check for potentially outdated channels
            if echo "$channels_output" | grep -q "nixos-"; then
                local channel_version=$(echo "$channels_output" | grep "nixos-" | awk '{print $2}' | grep -oE '[0-9]+\.[0-9]+' | head -1)
                if [[ -n "$channel_version" ]]; then
                    local nixos_ver=$(echo "$NIXOS_VERSION" | grep -oE '[0-9]+\.[0-9]+' | head -1)
                    if [[ "$channel_version" != "$nixos_ver" && -n "$nixos_ver" ]]; then
                        print_finding "medium" "Channel version ($channel_version) differs from NixOS version ($nixos_ver)"
                    fi
                fi
            fi
        else
            print_finding "low" "No Nix channels listed for root"
            add_to_report "**Nix Channels:** None found for root"
        fi
    else
        print_finding "medium" "nix-channel command not found. Cannot check channel status."
        add_to_report "**Nix Channels:** nix-channel command not found"
    fi
    
    print_subheader "Nix Store Integrity"
    if command_exists nix-store; then
        print_finding "low" "Nix store command is available. For a full integrity check, consider running 'sudo nix-store --verify --check-contents' (can be very slow)."
        add_to_report "**Nix Store:** 'nix-store' available. Full verification is a manual, time-consuming step."
        
        # Check for world-writable paths in Nix store (security issue)
        local store_writable=$(find /nix/store -maxdepth 1 -perm -o+w 2>/dev/null)
        if [[ -z "$store_writable" ]]; then
            print_finding "good" "Nix store has correct permissions (not world-writable)"
            add_to_report "- **Nix Store Permissions:** Correct (not world-writable)"
        else
            print_finding "high" "Security issue: Writable paths found in Nix store"
            add_to_report "- **Nix Store Permissions:** SECURITY ISSUE - Writable paths found"
            add_code_block "$store_writable"
        fi
    else
        print_finding "medium" "nix-store command not found."
        add_to_report "**Nix Store:** nix-store command not found"
    fi
    
    print_subheader "Nix Daemon Status"
    if command_exists systemctl; then
        if systemctl is-active nix-daemon.service >/dev/null 2>&1; then
            print_finding "good" "nix-daemon service is active"
            add_to_report "- **Nix Daemon:** Active"
        else
            print_finding "high" "nix-daemon service is not running"
            add_to_report "- **Nix Daemon:** NOT ACTIVE"
        fi
    else
        print_finding "medium" "systemctl not found. Cannot check nix-daemon status."
        add_to_report "- **Nix Daemon:** Status unknown (systemctl not found)"
    fi
    
    print_subheader "NixOS Kernel Hardening"
    local kernel_checks=(
        "kernel.kptr_restrict=2"
        "kernel.sysrq=0"
        "kernel.unprivileged_bpf_disabled=1"
        "kernel.unprivileged_userns_clone=0"
        "kernel.dmesg_restrict=1"
    )
    
    add_to_report "**Kernel Hardening Parameters:**"
    for check in "${kernel_checks[@]}"; do
        local param=${check%=*}
        local expected=${check#*=}
        local actual=$(sysctl -n $param 2>/dev/null || echo "N/A")
        
        if [[ "$actual" == "$expected" ]]; then
            print_finding "good" "Kernel parameter $param correctly set to $expected"
            add_to_report "- **$param:** $actual ✅"
        elif [[ "$actual" == "N/A" ]]; then
            print_finding "low" "Kernel parameter $param not available"
            add_to_report "- **$param:** Not available"
        else
            print_finding "medium" "Kernel parameter $param set to $actual (expected: $expected)"
            add_to_report "- **$param:** $actual ❌ (expected: $expected)"
        fi
    done
}

# --- Audit Function: Network Security ---

audit_network_security() {
    print_header "Network Security"
    
    print_subheader "Network Interfaces"
    if command_exists ip; then
        local interfaces=$(ip -brief addr show)
        add_to_report "**Network Interfaces:**"
        add_code_block "$interfaces"
        
        # Check for interfaces in promiscuous mode (potential security issue)
        local promisc_interfaces=$(ip -d link show | grep -i PROMISC)
        if [[ -n "$promisc_interfaces" ]]; then
            print_finding "medium" "Interfaces in promiscuous mode detected (potential security risk)"
            add_to_report "**Interfaces in Promiscuous Mode:**"
            add_code_block "$promisc_interfaces"
        else
            print_finding "good" "No interfaces in promiscuous mode"
        fi
    else
        print_finding "medium" "'ip' command not found. Cannot analyze network interfaces."
    fi
    
    print_subheader "Open Listening Ports"
    if command_exists ss; then
        local tcp_ports=$(ss -tlnp 2>/dev/null | grep LISTEN)
        local udp_ports=$(ss -ulnp 2>/dev/null)
        
        add_to_report "**TCP Listening Ports:**"
        if [[ -n "$tcp_ports" ]]; then
            add_code_block "$tcp_ports"
            echo "$tcp_ports" | while read line; do
                if [[ -n "$line" ]]; then
                    local port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
                    local process_info=$(echo "$line" | awk '{print $6}')
                    local process_name=$(echo "$process_info" | sed -n 's/.*users:(("([^"]*)".*/\1/p' | cut -d',' -f1)
                    if [[ -z "$process_name" ]]; then process_name="N/A"; fi
                    
                    case $port in
                        22|80|443|53) 
                            print_finding "good" "Standard service on port $port ($process_name)" 
                            ;;
                        3389|5900|5901) 
                            print_finding "medium" "Remote access port $port open ($process_name)" 
                            ;;
                        *) 
                            print_finding "low" "Service on port $port ($process_name)" 
                            ;;
                    esac
                fi
            done
        else
            print_finding "good" "No active TCP listening ports found"
            add_to_report "No active TCP listening ports found."
        fi
        
        add_to_report "**UDP Listening Ports:**"
        if [[ -n "$(echo "$udp_ports" | grep -v "State")" ]]; then
            add_code_block "$udp_ports"
            echo "$udp_ports" | grep -v "State" | while read line; do
                if [[ -n "$line" ]]; then
                    local port=$(echo "$line" | awk '{print $4}' | sed 's/.*://')
                    local process_info=$(echo "$line" | awk '{print $5}')
                    local process_name=$(echo "$process_info" | sed -n 's/.*users:(("([^"]*)".*/\1/p' | cut -d',' -f1)
                    if [[ -z "$process_name" ]]; then process_name="N/A"; fi
                    
                    print_finding "low" "UDP service on port $port ($process_name)"
                fi
            done
        else
            print_finding "good" "No active UDP listening ports found"
            add_to_report "No active UDP listening ports found."
        fi
    else
        print_finding "medium" "ss command not found, cannot audit network ports"
    fi
    
    print_subheader "Firewall Status"
    if command_exists nft; then
        local ruleset=$(nft list ruleset 2>/dev/null)
        local rule_count=$(echo "$ruleset" | grep -c '^\s*ip\s')
        
        add_to_report "**NFTables Ruleset:**"
        if [[ $rule_count -gt 0 ]]; then
            print_finding "good" "NFTables rules active ($rule_count rules)"
            add_code_block "$(echo "$ruleset" | head -n 20)"
            if [[ $(echo "$ruleset" | wc -l) -gt 20 ]]; then
                add_to_report "*(Showing first 20 lines of ruleset)*"
            fi
        else
            print_finding "high" "No NFTables rules found. Firewall may be inactive."
            add_to_report "No NFTables rules found. Firewall may be inactive."
        fi
    elif command_exists iptables; then
        local iptables_rules=$(iptables -L -n 2>/dev/null)
        add_to_report "**IPTables Rules:**"
        add_code_block "$iptables_rules"
        
        if echo "$iptables_rules" | grep -q "Chain INPUT (policy ACCEPT)"; then
            print_finding "high" "IPTables INPUT chain policy is set to ACCEPT"
        else
            print_finding "good" "IPTables INPUT chain has rules or restrictive policy"
        fi
    else
        print_finding "medium" "Neither nft nor iptables commands found. Cannot check firewall status."
    fi
    
    print_subheader "DNS Configuration"
    if [[ -f /etc/resolv.conf ]]; then
        local dns_servers=$(grep nameserver /etc/resolv.conf | awk '{print $2}')
        add_to_report "**DNS Servers:**"
        
        if [[ -n "$dns_servers" ]]; then
            add_code_block "$dns_servers"
            echo "$dns_servers" | while read dns; do
                case $dns in
                    8.8.8.8|8.8.4.4) 
                        print_finding "low" "Using Google DNS: $dns" 
                        ;;
                    1.1.1.1|1.0.0.1) 
                        print_finding "good" "Using Cloudflare DNS: $dns" 
                        ;;
                    127.0.0.1|::1) 
                        print_finding "good" "Using local DNS resolver: $dns" 
                        ;;
                    192.168.*|10.*|172.16.*|172.17.*|172.18.*|172.19.*|172.2*.*|172.30.*|172.31.*) 
                        print_finding "low" "Using private/local network DNS: $dns" 
                        ;;
                    *) 
                        print_finding "medium" "Using potentially public or ISP DNS server: $dns" 
                        ;;
                esac
            done
        else
            print_finding "medium" "No nameservers found in /etc/resolv.conf"
        fi
    else
        print_finding "medium" "/etc/resolv.conf not found"
    fi
    
    print_subheader "DNS Leak Test"
    if command_exists dig; then
        local external_dns=$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null)
        local system_resolver_ip=$(dig +short myip.opendns.com 2>/dev/null)
        
        add_to_report "**DNS Leak Test Results:**"
        add_to_report "- IP as seen by OpenDNS resolver1: $external_dns"
        add_to_report "- IP as seen by system's default resolver: $system_resolver_ip"
        
        if [[ -z "$external_dns" ]] || [[ -z "$system_resolver_ip" ]]; then
            print_finding "medium" "DNS leak test inconclusive (could not fetch IPs)"
        elif [[ "$external_dns" != "$system_resolver_ip" ]]; then
            print_finding "medium" "Potential DNS leak detected or using a VPN/proxy. External IP ($external_dns) differs from system resolver's perceived IP ($system_resolver_ip)."
        else
            print_finding "good" "No obvious DNS leak detected (external IP matches system resolver's perceived IP: $external_dns)"
        fi
    else
        print_finding "low" "dig command not found, skipping DNS leak test"
    fi
    
    print_subheader "SSH Configuration"
    if [[ -f /etc/ssh/sshd_config ]]; then
        add_to_report "**SSH Server Configuration:**"
        
        # Check for key SSH security settings
        local ssh_checks=(
            "PermitRootLogin no"
            "PasswordAuthentication no"
            "X11Forwarding no"
            "PermitEmptyPasswords no"
            "Protocol 2"
        )
        
        for check in "${ssh_checks[@]}"; do
            local param=${check% *}
            local expected=${check#* }
            local actual=$(grep "^$param" /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}')
            
            if [[ -z "$actual" ]]; then
                print_finding "medium" "SSH parameter $param not explicitly set in sshd_config"
                add_to_report "- **$param:** Not explicitly set"
            elif [[ "$actual" == "$expected" ]]; then
                print_finding "good" "SSH parameter $param correctly set to $expected"
                add_to_report "- **$param:** $actual ✅"
            else
                print_finding "medium" "SSH parameter $param set to $actual (recommended: $expected)"
                add_to_report "- **$param:** $actual ❌ (recommended: $expected)"
            fi
        done
        
        # Check SSH port
        local ssh_port=$(grep "^Port " /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}')
        if [[ -z "$ssh_port" ]]; then
            print_finding "low" "SSH using default port (22)"
            add_to_report "- **SSH Port:** Default (22)"
        elif [[ "$ssh_port" == "22" ]]; then
            print_finding "low" "SSH using standard port (22)"
            add_to_report "- **SSH Port:** Standard (22)"
        else
            print_finding "good" "SSH using non-standard port ($ssh_port)"
            add_to_report "- **SSH Port:** Non-standard ($ssh_port)"
        fi
    else
        print_finding "low" "SSH server configuration file not found"
    fi
}

# --- Audit Function: File System Security ---

audit_file_system_security() {
    print_header "File System Security"
    
    print_subheader "SUID/SGID Files"
    add_to_report "**SUID Root Files:**"
    
    local suid_found=0
    find / -path /proc -prune -o -path /sys -prune -o -path /dev -prune -o -path /run -prune -o -perm -4000 -type f -exec ls -la {} \; 2>/dev/null | while read line; do
        suid_found=1
        local file=$(echo "$line" | awk '{print $NF}')
        local base_file=$(basename "$file")
        
        if contains_element "$base_file" "${KNOWN_SAFE_SUID[@]}"; then
            print_finding "good" "Standard SUID binary: $file"
        else
            print_finding "medium" "Non-standard SUID binary: $file"
            add_to_report "- $line"
        fi
    done
    
    if [[ $suid_found -eq 0 ]]; then
        print_finding "good" "No SUID root files found in main filesystem areas"
        add_to_report "No SUID root files found in main filesystem areas (excluding /proc, /sys, /dev, /run)"
    fi
    
    add_to_report "**SGID Files (Sample):**"
    local sgid_found=0
    find / -path /proc -prune -o -path /sys -prune -o -path /dev -prune -o -path /run -prune -o -perm -2000 -type f -exec ls -la {} \; 2>/dev/null | head -10 | while read line; do
        sgid_found=1
        local file=$(echo "$line" | awk '{print $NF}')
        local base_file=$(basename "$file")
        
        if contains_element "$base_file" "${KNOWN_SAFE_SGID[@]}"; then
            print_finding "good" "Standard SGID binary: $file"
        else
            print_finding "low" "SGID file: $file"
            add_to_report "- $line"
        fi
    done
    
    if [[ $sgid_found -eq 0 ]]; then
        print_finding "good" "No SGID files found in sample"
        add_to_report "No SGID files found in sample (checked up to 10)"
    fi
    
    print_subheader "World-Writable Files"
    add_to_report "**World-Writable Files (Sample):**"
    
    local ww_found=0
    find / -path /proc -prune -o -path /sys -prune -o -path /dev -prune -o -path /run -prune -o -path /nix/store -prune -o -type f -perm -002 -exec ls -la {} \; 2>/dev/null | head -20 | while read line; do
        ww_found=1
        print_finding "high" "World-writable file: $(echo "$line" | awk '{print $NF}')"
        add_to_report "- $line"
    done
    
    if [[ $ww_found -eq 0 ]]; then
        print_finding "good" "No world-writable files found in sampled locations"
        add_to_report "No world-writable files found in main filesystem areas (excluding /proc, /sys, /dev, /run, /nix/store)"
    fi
    
    print_subheader "Unowned Files"
    add_to_report "**Unowned/Ungrouped Files (Sample):**"
    
    local unowned_found=0
    find / -path /proc -prune -o -path /sys -prune -o -path /dev -prune -o -path /run -prune -o -path /nix/store -prune -o \( -nouser -o -nogroup \) -print 2>/dev/null | head -10 | while read file; do
        unowned_found=1
        print_finding "medium" "Unowned/ungrouped file: $file"
        add_to_report "- $file ($(ls -ld "$file" 2>/dev/null | awk '{print $1, $3, $4}'))"
    done
    
    if [[ $unowned_found -eq 0 ]]; then
        print_finding "good" "No unowned/ungrouped files found in sampled locations"
        add_to_report "No unowned/ungrouped files found in main filesystem areas (excluding /proc, /sys, /dev, /run, /nix/store)"
    fi
    
    print_subheader "Suspicious Hidden Files"
    add_to_report "**Suspicious Hidden Files in Home Directories (Sample):**"
    
    local hidden_found=0
    find /home -name ".*" -type f -not -path "*/\.*rc" -not -path "*/\.config/*" -not -path "*/\.cache/*" -not -path "*/\.local/*" -size +1M 2>/dev/null | head -10 | while read file; do
        hidden_found=1
        print_finding "medium" "Large hidden file: $file ($(du -h "$file" 2>/dev/null | cut -f1))"
        add_to_report "- $file ($(du -h "$file" 2>/dev/null | cut -f1))"
    done
    
    if [[ $hidden_found -eq 0 ]]; then
        print_finding "good" "No suspicious large hidden files found in home directories"
        add_to_report "No suspicious large hidden files found in home directories"
    fi
}

# --- Audit Function: User Account Security ---

audit_user_account_security() {
    print_header "User Account Security"
    
    print_subheader "Users with Login Shells"
    add_to_report "**Users with Login Shells:**"
    
    getent passwd | grep -E "(bash|zsh|fish|sh)$" | while read line; do
        local username=$(echo "$line" | cut -d: -f1)
        local uid=$(echo "$line" | cut -d: -f3)
        local shell=$(echo "$line" | cut -d: -f7)
        
        if [[ $uid -eq 0 ]]; then
            print_finding "high" "Root account: $username (UID: $uid, Shell: $shell)"
            add_to_report "- **ROOT:** $username (UID: $uid, Shell: $shell)"
        elif [[ $uid -lt 1000 ]] && [[ $uid -gt 0 ]]; then
            print_finding "medium" "System account with shell: $username (UID: $uid, Shell: $shell)"
            add_to_report "- **SYSTEM:** $username (UID: $uid, Shell: $shell)"
        else
            print_finding "low" "User account: $username (UID: $uid, Shell: $shell)"
            add_to_report "- **USER:** $username (UID: $uid, Shell: $shell)"
        fi
    done
    
    print_subheader "Password Policy"
    if [[ -f /etc/login.defs ]]; then
        add_to_report "**Password Policy Settings:**"
        
        local pass_max_days=$(grep "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')
        local pass_min_days=$(grep "^PASS_MIN_DAYS" /etc/login.defs | awk '{print $2}')
        local pass_min_len=$(grep "^PASS_MIN_LEN" /etc/login.defs | awk '{print $2}')
        
        if [[ -n "$pass_max_days" ]]; then
            if [[ $pass_max_days -gt 90 ]]; then
                print_finding "medium" "Password maximum age ($pass_max_days days) exceeds recommended 90 days"
                add_to_report "- **PASS_MAX_DAYS:** $pass_max_days days ❌ (recommended: ≤90)"
            else
                print_finding "good" "Password maximum age is $pass_max_days days"
                add_to_report "- **PASS_MAX_DAYS:** $pass_max_days days ✅"
            fi
        fi
        
        if [[ -n "$pass_min_days" ]]; then
            if [[ $pass_min_days -lt 1 ]]; then
                print_finding "low" "Password minimum age ($pass_min_days days) allows frequent changes"
                add_to_report "- **PASS_MIN_DAYS:** $pass_min_days days ❌ (recommended: ≥1)"
            else
                print_finding "good" "Password minimum age is $pass_min_days days"
                add_to_report "- **PASS_MIN_DAYS:** $pass_min_days days ✅"
            fi
        fi
        
        if [[ -n "$pass_min_len" ]]; then
            if [[ $pass_min_len -lt 8 ]]; then
                print_finding "medium" "Password minimum length ($pass_min_len) is less than recommended 8 characters"
                add_to_report "- **PASS_MIN_LEN:** $pass_min_len characters ❌ (recommended: ≥8)"
            else
                print_finding "good" "Password minimum length is $pass_min_len characters"
                add_to_report "- **PASS_MIN_LEN:** $pass_min_len characters ✅"
            fi
        fi
    else
        print_finding "low" "login.defs file not found, cannot check password policy"
        add_to_report "login.defs file not found, cannot check password policy"
    fi
    
    print_subheader "Sudo Privileges"
    add_to_report "**Sudo Configuration:**"
    
    if command_exists sudo; then
        if [[ -d /etc/sudoers.d ]]; then
            local sudoers_files=$(find /etc/sudoers.d -type f -not -name README 2>/dev/null)
            if [[ -n "$sudoers_files" ]]; then
                print_finding "low" "Additional sudoers files found in /etc/sudoers.d/"
                add_to_report "Additional sudoers files found:"
                for file in $sudoers_files; do
                    add_to_report "- $file"
                done
            fi
        fi
        
        if [[ $EUID -eq 0 ]]; then
            local sudo_all=$(grep -r "ALL=(ALL" /etc/sudoers /etc/sudoers.d 2>/dev/null | grep -v "^#")
            if [[ -n "$sudo_all" ]]; then
                print_finding "medium" "Users/groups with full sudo privileges found"
                add_to_report "**Users/groups with full sudo privileges:**"
                add_code_block "$sudo_all"
            fi
            
            local sudo_nopasswd=$(grep -r "NOPASSWD" /etc/sudoers /etc/sudoers.d 2>/dev/null | grep -v "^#")
            if [[ -n "$sudo_nopasswd" ]]; then
                print_finding "high" "NOPASSWD sudo entries found (allows sudo without password)"
                add_to_report "**NOPASSWD sudo entries (security risk):**"
                add_code_block "$sudo_nopasswd"
            fi
        else
            print_finding "low" "Not running as root, limited sudo configuration check"
            add_to_report "Limited sudo configuration check (not running as root)"
            
            local current_sudo=$(sudo -l 2>/dev/null)
            if [[ $? -eq 0 ]]; then
                add_to_report "**Current user sudo privileges:**"
                add_code_block "$current_sudo"
                
                if echo "$current_sudo" | grep -q "NOPASSWD"; then
                    print_finding "medium" "Current user has NOPASSWD sudo privileges"
                fi
                
                if echo "$current_sudo" | grep -q "ALL=(ALL"; then
                    print_finding "medium" "Current user has full sudo privileges"
                fi
            fi
        fi
    else
        print_finding "low" "sudo command not found"
        add_to_report "sudo command not found"
    fi
}

# --- Audit Function: Process Security ---

audit_process_security() {
    print_header "Process Security"
    
    print_subheader "Processes Running as Root"
    add_to_report "**Root Processes (Top CPU Usage):**"
    
    if command_exists ps && command_exists bc; then
        ps aux --sort=-%cpu | grep "^root" | grep -v "\[" | head -n 10 | while read line; do
            local cmd=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}')
            local cpu=$(echo "$line" | awk '{print $3}')
            local pid=$(echo "$line" | awk '{print $2}')
            
            add_to_report "- PID $pid: $cmd (CPU: ${cpu}%)"
            
            if (( $(echo "$cpu > $HIGH_CPU_ROOT_THRESHOLD" | bc -l) )); then
                print_finding "medium" "High CPU root process: $cmd (CPU: ${cpu}%)"
            else
                print_finding "low" "Root process: $cmd (CPU: ${cpu}%)"
            fi
        done
    else
        print_finding "low" "ps or bc command not found, limited process analysis"
        ps aux | grep "^root" | grep -v "\[" | head -n 10 | while read line; do
            local cmd=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}')
            add_to_report "- $cmd"
            print_finding "low" "Root process: $cmd"
        done
    fi
    
    print_subheader "Unusual Process Check"
    add_to_report "**Unusual Processes:**"
    
    # Check for processes running from /tmp or /dev
    local unusual_locations=$(ps aux | grep -E '(/tmp|/dev|/var/tmp)' | grep -v grep)
    if [[ -n "$unusual_locations" ]]; then
        print_finding "high" "Processes running from unusual locations detected"
        add_to_report "Processes running from unusual locations:"
        add_code_block "$unusual_locations"
    else
        print_finding "good" "No processes running from unusual locations"
        add_to_report "No processes running from unusual locations detected"
    fi
    
    # Check for processes with deleted binaries
    local deleted_binaries=$(ls -l /proc/*/exe 2>/dev/null | grep "deleted")
    if [[ -n "$deleted_binaries" ]]; then
        print_finding "medium" "Processes running with deleted binaries detected"
        add_to_report "Processes running with deleted binaries:"
        add_code_block "$deleted_binaries"
    else
        print_finding "good" "No processes with deleted binaries"
        add_to_report "No processes with deleted binaries detected"
    fi
    
    print_subheader "Cron Jobs"
    add_to_report "**Scheduled Tasks:**"
    
    # System crontabs
    if [[ -d /etc/cron.d ]]; then
        local cron_files=$(find /etc/cron.d -type f -not -name README 2>/dev/null)
        if [[ -n "$cron_files" ]]; then
            print_finding "low" "System cron jobs found in /etc/cron.d/"
            add_to_report "System cron jobs:"
            for file in $cron_files; do
                add_to_report "- $file"
            done
        fi
    fi
    
    # User crontabs
    if command_exists crontab; then
        if [[ $EUID -eq 0 ]]; then
            for user in $(cut -d: -f1 /etc/passwd); do
                local user_cron=$(crontab -u "$user" -l 2>/dev/null | grep -v "^#")
                if [[ -n "$user_cron" ]]; then
                    print_finding "low" "Cron jobs found for user $user"
                    add_to_report "Cron jobs for user $user:"
                    add_code_block "$user_cron"
                fi
            done
        else
            local current_cron=$(crontab -l 2>/dev/null | grep -v "^#")
            if [[ -n "$current_cron" ]]; then
                print_finding "low" "Cron jobs found for current user"
                add_to_report "Cron jobs for current user:"
                add_code_block "$current_cron"
            fi
        fi
    fi
    
    # Systemd timers (modern alternative to cron)
    if command_exists systemctl; then
        local timers=$(systemctl list-timers --no-pager 2>/dev/null)
        if [[ -n "$timers" ]]; then
            print_finding "low" "Systemd timers found"
            add_to_report "Systemd timers:"
            add_code_block "$(echo "$timers" | head -n 10)"
            if [[ $(echo "$timers" | wc -l) -gt 10 ]]; then
                add_to_report "*(Showing first 10 timers)*"
            fi
        fi
    fi
}

# --- Audit Function: Container and Virtualization Security ---

audit_container_security() {
    print_header "Container and Virtualization Security"
    
    print_subheader "Docker Security"
    add_to_report "**Docker Environment Check:**"
    
    if command_exists docker; then
        print_finding "low" "Docker installed"
        add_to_report "Docker is installed on this system."
        
        # Check if Docker daemon is running
        if docker info &>/dev/null; then
            print_finding "low" "Docker daemon is running"
            
            # Check Docker version
            local docker_version=$(docker version --format '{{.Server.Version}}' 2>/dev/null)
            if [[ -n "$docker_version" ]]; then
                print_finding "low" "Docker version: $docker_version"
                add_to_report "- Docker version: $docker_version"
            fi
            
            # Check for running containers
            local running_containers=$(docker ps --format "{{.Names}}" 2>/dev/null)
            if [[ -n "$running_containers" ]]; then
                local container_count=$(echo "$running_containers" | wc -l)
                print_finding "medium" "$container_count Docker containers running"
                add_to_report "- Running containers: $container_count"
                add_to_report "**Running Containers:**"
                add_code_block "$(docker ps 2>/dev/null)"
            else
                print_finding "low" "No Docker containers running"
                add_to_report "- No running containers"
            fi
            
            # Check Docker socket permissions
            if [[ -S /var/run/docker.sock ]]; then
                local socket_perms=$(ls -la /var/run/docker.sock | awk '{print $1, $3, $4}')
                add_to_report "- Docker socket: $socket_perms"
                
                if echo "$socket_perms" | grep -q "srw-rw----.*root.*docker"; then
                    print_finding "good" "Docker socket has proper permissions"
                else
                    print_finding "high" "Docker socket has potentially insecure permissions: $socket_perms"
                fi
                
                # Check which users are in the docker group && can control Docker daemon
                local docker_group_users=$(getent group docker 2>/dev/null | cut -d: -f4)
                if [[ -n "$docker_group_users" ]]; then
                    print_finding "medium" "Users in docker group (equivalent to root): $docker_group_users"
                    add_to_report "- Users in docker group: $docker_group_users"
                    add_to_report "  *Note: Members of the docker group effectively have root access*"
                fi
            fi
        else
            print_finding "low" "Docker installed but daemon not running"
            add_to_report "Docker is installed but the daemon is not running."
        fi
    else
        print_finding "low" "Docker not installed"
        add_to_report "Docker is not installed on this system."
    fi
    
    print_subheader "Podman Security"
    add_to_report "**Podman Environment Check:**"
    
    if command_exists podman; then
        print_finding "low" "Podman installed"
        add_to_report "Podman is installed on this system."
        
        # Check Podman version
        local podman_version=$(podman version --format '{{.Version}}' 2>/dev/null)
        if [[ -n "$podman_version" ]]; then
            print_finding "low" "Podman version: $podman_version"
            add_to_report "- Podman version: $podman_version"
        fi
        
        # Check for running containers
        local podman_containers=$(podman ps --format "{{.Names}}" 2>/dev/null)
        if [[ -n "$podman_containers" ]]; then
            local container_count=$(echo "$podman_containers" | wc -l)
            print_finding "medium" "$container_count Podman containers running"
            add_to_report "- Running containers: $container_count"
            add_to_report "**Running Podman Containers:**"
            add_code_block "$(podman ps 2>/dev/null)"
        else
            print_finding "low" "No Podman containers running"
            add_to_report "- No running containers"
        fi
    else
        print_finding "low" "Podman not installed"
        add_to_report "Podman is not installed on this system."
    fi
    
    print_subheader "Virtualization Check"
    add_to_report "**Virtualization Environment:**"
    
    # Check if system is a VM or running on bare metal
    if [[ -f /proc/cpuinfo ]]; then
        if grep -q "hypervisor" /proc/cpuinfo; then
            print_finding "low" "System is running in a virtual machine"
            add_to_report "This system appears to be running in a virtual machine."
            
            # Try to determine hypervisor type
            local hypervisor_type=""
            if [[ -x /usr/sbin/dmidecode ]]; then
                hypervisor_type=$(/usr/sbin/dmidecode -s system-product-name 2>/dev/null)
            fi
            
            if [[ -z "$hypervisor_type" ]]; then
                if grep -q "VMware" /proc/scsi/scsi 2>/dev/null; then
                    hypervisor_type="VMware"
                elif grep -q "QEMU" /proc/cpuinfo; then
                    hypervisor_type="QEMU/KVM"
                elif grep -q "Microsoft Hv" /proc/cpuinfo; then
                    hypervisor_type="Hyper-V"
                elif grep -q "Xen" /proc/cpuinfo; then
                    hypervisor_type="Xen"
                fi
            fi
            
            if [[ -n "$hypervisor_type" ]]; then
                print_finding "low" "Hypervisor type: $hypervisor_type"
                add_to_report "- Hypervisor type: $hypervisor_type"
            fi
        else
            print_finding "low" "System appears to be running on bare metal"
            add_to_report "This system appears to be running on bare metal (not virtualized)."
        fi
    fi
    
    # Check if system is hosting VMs
    if command_exists virsh; then
        local vms=$(virsh list --all 2>/dev/null)
        if [[ $? -eq 0 && -n "$vms" ]]; then
            print_finding "medium" "System is hosting virtual machines"
            add_to_report "**Virtual Machines on this Host:**"
            add_code_block "$vms"
        fi
    fi
}

# --- Audit Function: Hardware Security ---

audit_hardware_security() {
    print_header "Hardware Security"
    
    print_subheader "CPU Information"
    add_to_report "**CPU Details:**"
    
    if command_exists lscpu; then
        local cpu_info=$(lscpu)
        add_code_block "$(echo "$cpu_info" | head -n 15)"
        
        # Check for CPU vulnerabilities
        if [[ -d /sys/devices/system/cpu/vulnerabilities ]]; then
            print_finding "low" "Checking CPU security vulnerabilities"
            add_to_report "**CPU Vulnerabilities:**"
            
            for vuln in /sys/devices/system/cpu/vulnerabilities/*; do
                if [[ -f "$vuln" ]]; then
                    local vuln_name=$(basename "$vuln")
                    local vuln_status=$(cat "$vuln" 2>/dev/null)
                    
                    add_to_report "- $vuln_name: $vuln_status"
                    
                    if [[ "$vuln_status" == *"Vulnerable"* ]]; then
                        print_finding "high" "CPU vulnerable to $vuln_name: $vuln_status"
                    elif [[ "$vuln_status" == *"Mitigation"* ]]; then
                        print_finding "medium" "CPU vulnerability $vuln_name mitigated: $vuln_status"
                    else
                        print_finding "good" "CPU not vulnerable to $vuln_name: $vuln_status"
                    fi
                fi
            done
        fi
    else
        print_finding "low" "lscpu command not found, limited CPU information"
        
        # Fallback to /proc/cpuinfo
        if [[ -f /proc/cpuinfo ]]; then
            local cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^[ \t]*//')
            local cpu_cores=$(grep -c "processor" /proc/cpuinfo)
            
            add_to_report "- CPU Model: $cpu_model"
            add_to_report "- CPU Cores: $cpu_cores"
            print_finding "low" "CPU: $cpu_model ($cpu_cores cores)"
        fi
    fi
    
    print_subheader "PCI Devices"
    add_to_report "**PCI Devices:**"
    
    if command_exists lspci; then
        local pci_devices=$(lspci)
        add_code_block "$(echo "$pci_devices" | head -n 10)"
        if [[ $(echo "$pci_devices" | wc -l) -gt 10 ]]; then
            add_to_report "*(Showing first 10 PCI devices)*"
        fi
        
        # Check for potentially sensitive devices
        if echo "$pci_devices" | grep -qi "wifi\|wireless"; then
            print_finding "medium" "Wireless network device detected"
            add_to_report "- Wireless network device detected"
        fi
        
        if echo "$pci_devices" | grep -qi "bluetooth"; then
            print_finding "medium" "Bluetooth device detected"
            add_to_report "- Bluetooth device detected"
        fi
    else
        print_finding "low" "lspci command not found, cannot list PCI devices"
    fi
    
    print_subheader "USB Devices"
    add_to_report "**USB Devices:**"
    
    if command_exists lsusb; then
        local usb_devices=$(lsusb)
        add_code_block "$usb_devices"
        
        # Count USB devices
        local usb_count=$(echo "$usb_devices" | wc -l)
        print_finding "low" "$usb_count USB devices detected"
        
        # Check for potentially sensitive USB devices
        if echo "$usb_devices" | grep -qi "camera\|webcam"; then
            print_finding "medium" "Camera/webcam USB device detected"
            add_to_report "- Camera/webcam USB device detected"
        fi
        
        if echo "$usb_devices" | grep -qi "audio\|microphone"; then
            print_finding "medium" "Audio/microphone USB device detected"
            add_to_report "- Audio/microphone USB device detected"
        fi
    else
        print_finding "low" "lsusb command not found, cannot list USB devices"
    fi
    
    print_subheader "Storage Devices"
    add_to_report "**Storage Devices:**"
    
    if command_exists lsblk; then
        local storage_devices=$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE)
        add_code_block "$storage_devices"
        
        # Check for unencrypted partitions
        if echo "$storage_devices" | grep -q "swap"; then
            print_finding "medium" "Unencrypted swap partition detected"
            add_to_report "- Unencrypted swap partition detected"
        fi
        
        # Check for disk encryption
        if echo "$storage_devices" | grep -qi "crypt"; then
            print_finding "good" "Encrypted storage detected"
            add_to_report "- Encrypted storage detected"
        else
            print_finding "medium" "No encrypted storage detected"
            add_to_report "- No encrypted storage detected"
        fi
    else
        print_finding "low" "lsblk command not found, cannot list block devices"
    fi
}

# --- Audit Function: Package Security ---

audit_package_security() {
    print_header "Package Security"
    
    print_subheader "NixOS Packages"
    add_to_report "**NixOS Package Information:**"
    
    if command_exists nix-env; then
        # Get installed packages
        local installed_packages=$(nix-env -qa --installed "*" 2>/dev/null)
        local package_count=$(echo "$installed_packages" | wc -l)
        
        print_finding "low" "$package_count packages installed via nix-env"
        add_to_report "- $package_count packages installed via nix-env"
        
        if [[ $package_count -gt 0 ]]; then
            add_to_report "**Sample of Installed Packages:**"
            add_code_block "$(echo "$installed_packages" | head -n 10)"
            if [[ $package_count -gt 10 ]]; then
                add_to_report "*(Showing first 10 packages)*"
            fi
        fi
        
        # Check for outdated packages
        if command_exists nix-channel; then
            print_finding "low" "Checking for outdated packages (may take a moment)..."
            local outdated_packages=$(nix-env -u --dry-run 2>/dev/null)
            
            if [[ -n "$outdated_packages" && "$outdated_packages" != *"nothing to do"* ]]; then
                local outdated_count=$(echo "$outdated_packages" | grep -c "^upgrade")
                print_finding "medium" "$outdated_count outdated packages detected"
                add_to_report "- $outdated_count outdated packages detected"
                add_to_report "**Outdated Packages:**"
                add_code_block "$outdated_packages"
            else
                print_finding "good" "No outdated packages detected"
                add_to_report "- No outdated packages detected"
            fi
        fi
    else
        print_finding "low" "nix-env command not found, cannot check installed packages"
        add_to_report "nix-env command not found, cannot check installed packages"
    fi
    
    print_subheader "System Packages"
    add_to_report "**System Package Information:**"
    
    if [[ -f /run/current-system/sw/bin/nix-store ]]; then
        # Get system packages
        local system_path=$(readlink -f /run/current-system 2>/dev/null)
        if [[ -n "$system_path" ]]; then
            print_finding "low" "Current system path: $system_path"
            add_to_report "- Current system path: $system_path"
            
            # Count system dependencies
            if command_exists nix-store; then
                local system_deps=$(/run/current-system/sw/bin/nix-store -q --references "$system_path" 2>/dev/null | wc -l)
                print_finding "low" "System contains approximately $system_deps packages/dependencies"
                add_to_report "- System contains approximately $system_deps packages/dependencies"
            fi
        fi
    fi
    
    # Check for other package managers
    local other_pkg_managers=()
    for pm in apt dpkg yum dnf pacman; do
        if command_exists $pm; then
            other_pkg_managers+=("$pm")
        fi
    done
    
    if [[ ${#other_pkg_managers[@]} -gt 0 ]]; then
        print_finding "medium" "Non-Nix package managers found: ${other_pkg_managers[*]}"
        add_to_report "- **WARNING:** Non-Nix package managers found: ${other_pkg_managers[*]}"
        add_to_report "  *This may cause conflicts with the NixOS package management*"
    else
        print_finding "good" "No non-Nix package managers found"
        add_to_report "- No non-Nix package managers found"
    fi
}

# --- Audit Function: Startup Services ---

audit_startup_services() {
    print_header "Startup Services Analysis"
    
    print_subheader "Enabled Services"
    add_to_report "**Enabled Services:**"
    
    if command_exists systemctl; then
        local enabled_services=$(systemctl list-unit-files --state=enabled --type=service --no-pager | grep -v "UNIT FILE")
        
        if [[ -n "$enabled_services" ]]; then
            add_code_block "$(echo "$enabled_services" | head -n 20)"
            if [[ $(echo "$enabled_services" | wc -l) -gt 20 ]]; then
                add_to_report "*(Showing first 20 enabled services)*"
            fi
            
            echo "$enabled_services" | while read line; do
                if [[ -n "$line" ]]; then
                    local service=$(echo "$line" | awk '{print $1}')
                    
                    case $service in
                        nix-daemon.service|systemd-*.service|dbus.service)
                            print_finding "good" "Essential service: $service"
                            ;;
                        ssh.service|sshd.service)
                            print_finding "medium" "SSH service enabled: $service"
                            ;;
                        *telnet*|*rsh*|*ftp*)
                            print_finding "high" "Insecure service enabled: $service"
                            ;;
                        *)
                            print_finding "low" "Enabled service: $service"
                            ;;
                    esac
                fi
            done
        else
            print_finding "low" "No enabled services found"
            add_to_report "No enabled services found"
        fi
        
        print_subheader "Failed Services"
        add_to_report "**Failed Services:**"
        
        local failed_services=$(systemctl --failed --no-pager --no-legend)
        if [[ -n "$failed_services" ]]; then
            add_code_block "$failed_services"
            
            echo "$failed_services" | while read line; do
                local service=$(echo "$line" | awk '{print $1}')
                print_finding "medium" "Failed service: $service"
            done
        else
            print_finding "good" "No failed services"
            add_to_report "No failed services found"
        fi
        
        print_subheader "Socket Units"
        add_to_report "**Active Sockets:**"
        
        local active_sockets=$(systemctl list-units --type=socket --state=active --no-pager --no-legend)
        if [[ -n "$active_sockets" ]]; then
            add_code_block "$(echo "$active_sockets" | head -n 10)"
            if [[ $(echo "$active_sockets" | wc -l) -gt 10 ]]; then
                add_to_report "*(Showing first 10 active sockets)*"
            fi
            
            local socket_count=$(echo "$active_sockets" | wc -l)
            print_finding "low" "$socket_count active socket units"
        else
            print_finding "low" "No active socket units"
            add_to_report "No active socket units found"
        fi
    else
        print_finding "medium" "systemctl command not found, cannot analyze services"
        add_to_report "systemctl command not found, cannot analyze services"
    fi
}

# --- Audit Function: Log Analysis ---

audit_log_analysis() {
    print_header "Log Analysis"
    
    print_subheader "Authentication Failures"
    add_to_report "**Recent Authentication Failures:**"
    
    if command_exists journalctl; then
        local auth_failures=$(journalctl -u systemd-logind -u sshd --since "24 hours ago" | grep -i "fail\|invalid\|error" | tail -n 10)
        
        if [[ -n "$auth_failures" ]]; then
            add_code_block "$auth_failures"
            local failure_count=$(echo "$auth_failures" | wc -l)
            
            if [[ $failure_count -gt 5 ]]; then
                print_finding "medium" "$failure_count recent authentication failures detected"
            else
                print_finding "low" "$failure_count recent authentication failures detected"
            fi
        else
            print_finding "good" "No recent authentication failures detected"
            add_to_report "No recent authentication failures detected"
        fi
        
        print_subheader "System Errors"
        add_to_report "**Recent System Errors:**"
        
        local system_errors=$(journalctl -p err..emerg --since "24 hours ago" | tail -n 10)
        if [[ -n "$system_errors" ]]; then
            add_code_block "$system_errors"
            local error_count=$(echo "$system_errors" | wc -l)
            
            if [[ $error_count -gt 10 ]]; then
                print_finding "medium" "$error_count recent system errors detected"
            else
                print_finding "low" "$error_count recent system errors detected"
            fi
        else
            print_finding "good" "No recent system errors detected"
            add_to_report "No recent system errors detected"
        fi
    else
        print_finding "low" "journalctl command not found, cannot analyze logs"
        
        # Fallback to traditional log files
        if [[ -f /var/log/auth.log ]]; then
            local auth_failures=$(grep -i "fail\|invalid\|error" /var/log/auth.log | tail -n 10)
            if [[ -n "$auth_failures" ]]; then
                add_code_block "$auth_failures"
                print_finding "medium" "Authentication failures found in auth.log"
            else
                print_finding "good" "No authentication failures found in auth.log"
                add_to_report "No authentication failures found in auth.log"
            fi
        fi
    fi
    
    print_subheader "Login History"
    add_to_report "**Recent Logins:**"
    
    if command_exists last; then
        local recent_logins=$(last -n 10)
        add_code_block "$recent_logins"
        
        # Check for remote logins
        local remote_logins=$(echo "$recent_logins" | grep -v "localhost\|127.0.0.1\|::1" | grep -v "^$")
        if [[ -n "$remote_logins" ]]; then
            print_finding "medium" "Remote logins detected"
            add_to_report "**Remote Logins Detected:**"
            add_code_block "$remote_logins"
        else
            print_finding "good" "No remote logins detected"
        fi
    else
        print_finding "low" "last command not found, cannot check login history"
    fi
}

# --- Main Execution Logic ---

main() {
    # Root check
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}🔴 HIGH: Audit requires root privileges for full visibility! Please run with sudo.${RESET}"
        exit 1
    fi

    echo -e "${BOLD}${BLUE}Starting OrynAudit Script...${RESET}"
    echo -e "Audit Date: ${CYAN}$AUDIT_DATE${RESET}"
    echo -e "Hostname: ${CYAN}$HOSTNAME${RESET}"
    echo -e "Report File: ${CYAN}$OUTPUT_FILE${RESET}"

    # Initialize Report File
    write_md_header

    # Check Dependencies
    check_dependencies

    # Execute Audit Sections
    audit_system_info
    audit_nixos_specifics
    audit_network_security
    audit_file_system_security
    audit_user_account_security
    audit_process_security
    audit_container_security
    audit_hardware_security
    audit_package_security
    audit_startup_services
    audit_log_analysis

    # Final Summary
    print_header "OrynAudit Summary"
    print_finding "good" "Audit completed successfully."
    print_finding "low" "Full report saved to: $OUTPUT_FILE"
    add_to_report "\n**Findings Summary:**"
    add_to_report "- ✅ Good Practices Confirmed: $GOOD_FINDINGS"
    add_to_report "- 🔴 High Priority Issues: $HIGH_FINDINGS"
    add_to_report "- 🟡 Medium Priority Issues: $MEDIUM_FINDINGS"
    add_to_report "- 🔵 Informational Findings: $LOW_FINDINGS"

    echo -e "\n${BOLD}OrynAudit Summary:${RESET}"
    echo -e "  ${GREEN}✅ Good Practices Confirmed: $GOOD_FINDINGS${RESET}"
    echo -e "  ${RED}🔴 High Priority Issues: $HIGH_FINDINGS${RESET}"
    echo -e "  ${YELLOW}🟡 Medium Priority Issues: $MEDIUM_FINDINGS${RESET}"
    echo -e "  ${CYAN}🔵 Informational Findings: $LOW_FINDINGS${RESET}"

    echo -e "\n${BOLD}${GREEN}OrynAudit finished.${RESET}"
    echo -e "Full report available at: ${CYAN}$OUTPUT_FILE${RESET}"

    # Optional: Display report using bat or rich if available
    if command_exists bat; then
        echo -e "\n${GREEN}Displaying report with bat...${RESET}"
        bat --paging=always --plain "$OUTPUT_FILE"
    elif command_exists rich; then
        echo -e "\n${GREEN}Displaying report with rich...${RESET}"
        rich "$OUTPUT_FILE"
    fi
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi

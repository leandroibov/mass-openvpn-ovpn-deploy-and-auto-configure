#!/usr/bin/env bash
# ------------------------------------------------------------
# Script: openvpn2.sh
# Description: Interactive version – asks for the folder that
#              holds .ovpn files, the VPN username, and the password,
#              then imports each profile and stores the credentials
#              correctly (username + password) with “store the password
#              for all users”.
# ------------------------------------------------------------

# 1️⃣ Must be root
if [ "$(id -u)" -ne 0 ]; then
    echo "⚠️  This script must be run as root (UID 0)." >&2
    echo "Sleeping 3 seconds…" >&2
    sleep 3
    exit 1
fi

# ------------------------------------------------------------
#  2️⃣ Verify that the `nmcli` command is available
# ------------------------------------------------------------
if ! command -v nmcli >/dev/null 2>&1; then
    echo "❌  The `nmcli` utility is not installed."
    echo "🔧  Install it with: apt-get install network-manager   # Debian/Ubuntu"
    echo "          or: yum install NetworkManager            # RHEL/CentOS/Fedora"
sleep 3
    exit 1
fi

# -----------------------------------------------------------------
# 1️⃣ Prompt for the directory that holds the .ovpn files
# -----------------------------------------------------------------
read -p "Enter the full path to the folder containing .ovpn files: " OVPN_DIR

# Remove a possible trailing slash for consistency
OVPN_DIR="${OVPN_DIR%/}"

# Verify that the directory exists
if [[ ! -d "$OVPN_DIR" ]]; then
    echo "Error: directory \"$OVPN_DIR\" does not exist."
    exit 1
fi

# -----------------------------------------------------------------
# 2️⃣ Prompt for VPN credentials
# -----------------------------------------------------------------
read -p "Enter VPN username: " VPN_USER
read -s -p "Enter VPN password: " VPN_PASS
echo   # newline after hidden password entry

# Simple validation
if [[ -z "$VPN_USER" || -z "$VPN_PASS" ]]; then
    echo "Error: Both username and password must be provided."
    exit 1
fi

# -----------------------------------------------------------------
# 3️⃣ Process each .ovpn file in the supplied directory
# -----------------------------------------------------------------
shopt -s nullglob   # skip the loop if no .ovpn files are present
found_any=false

for cfg in "$OVPN_DIR"/*.ovpn; do
    found_any=true
    # Derive a clean connection name from the filename (strip extension)
    conn_name="$(basename "$cfg" .ovpn)"

    echo "Importing \"$cfg\" as connection \"$conn_name\"..."

    # 3.1️⃣ Import the OpenVPN profile
    nmcli connection import type openvpn file "$cfg"

    # 3.2️⃣ Ensure the connection ID matches the desired name
    nmcli connection modify "$conn_name" connection.id "$conn_name"

   # 3️⃣ Set the username (vpn.user-name) and the password (vpn.secrets)
    nmcli connection modify "$conn_name" \
       vpn.user-name "$VPN_USER" \
        +vpn.secrets "password=$VPN_PASS" \
        +vpn.data "password-flags=0"

    # 3.4️⃣ (Optional) Bring the connection down after configuration
    nmcli connection down "$conn_name" 2>/dev/null || true

    echo "Connection \"$conn_name\" configured (username + password stored)."
done

if ! $found_any; then
    echo "No .ovpn files were found in \"$OVPN_DIR\"."
else
    echo "All OpenVPN profiles have been processed successfully."
fi
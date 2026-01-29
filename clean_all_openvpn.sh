#!/usr/bin/env bash

# ------------------------------------------------------------
#  1️⃣ Must be run as root
# ------------------------------------------------------------
if [[ "$(id -u)" -ne 0 ]]; then
    echo "⚠️  This script must be run as root (UID 0)." >&2
    echo "⏳  Sleeping 3 seconds…" >&2
    sleep 3
    exit 1
fi

# ------------------------------------------------------------
#  2️⃣ Verify that the `nmcli` command is available
# ------------------------------------------------------------
if ! command -v nmcli >/dev/null 2>&1; then
    echo "❌  The 'nmcli' utility is not installed." >&2
    echo "🔧  Install it with:" >&2
    echo "      apt-get install network-manager   # Debian/Ubuntu" >&2
    echo "      yum install NetworkManager        # RHEL/CentOS/Fedora" >&2
    exit 1
fi

# Command to save VPN connections to a temporary file
sudo nmcli connection show | grep vpn > /dev/shm/list.txt

# Read each line from the list.txt
while IFS= read -r line
do
    # Extract the first field (VPN name)
    vpn_name=$(echo "$line" | awk '{print $1}')

    # Check if vpn_name is not empty
    if [ -n "$vpn_name" ]; then
        # Execute the delete command
        echo "Deleting connection: $vpn_name"
        if sudo nmcli connection delete "$vpn_name"; then
            echo "Successfully deleted: $vpn_name"
        else
            echo "Failed to delete: $vpn_name"
        fi
    fi
done < /dev/shm/list.txt
sudo rm -rf /dev/shm/list.txt
echo
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

# ------------------------------------------------------------
#  3️⃣ Ask the user for the folder that contains the .ovpn files
# ------------------------------------------------------------
read -rp "📂  Enter the full path to the folder with the imported .ovpn files: " OVPN_DIR

# Trim possible trailing slash for nicer messages
OVPN_DIR="${OVPN_DIR%/}"

# Validate the directory
if [[ ! -d "$OVPN_DIR" ]]; then
    echo "❌  Directory '$OVPN_DIR' does not exist or is not accessible." >&2
    exit 1
fi

# ------------------------------------------------------------
#  4️⃣ Helper: delete a NetworkManager connection if it exists
# ------------------------------------------------------------
remove_nm_connection() {
    local conn_name="$1"

    # Does the connection exist in NetworkManager?
    if nmcli -g NAME connection show | grep -Fxq "$conn_name"; then
        echo "🗑️  Removing NMCLI connection: $conn_name"

        # Try a straightforward delete first
        if nmcli connection delete "$conn_name" >/dev/null 2>&1; then
            echo "   → Deleted successfully."
            return
        fi

        # If it failed (most likely because it is active), bring it down then delete
        echo "   → Deletion failed – attempting to bring the connection down first..."
        nmcli connection down "$conn_name" >/dev/null 2>&1
        if nmcli connection delete "$conn_name" >/dev/null 2>&1; then
            echo "   → Deleted after being brought down."
        else
            echo "   → Could not delete '$conn_name'. Please investigate manually."
        fi
    else
        echo "ℹ️  No NetworkManager connection named '$conn_name' – nothing to do."
    fi
}

# ------------------------------------------------------------
#  5️⃣ Process every .ovpn file in the supplied folder
# ------------------------------------------------------------
shopt -s nullglob   # makes the loop skip if no matches
found_any=false

for ovpn_file in "$OVPN_DIR"/*.ovpn; do
    found_any=true
    # Derive the expected NM connection name from the filename (strip path & .ovpn)
    conn_name="$(basename "$ovpn_file" .ovpn)"
    echo "🔎  Processing file: $ovpn_file → expected connection name: $conn_name"
    remove_nm_connection "$conn_name"
done

if ! $found_any; then
    echo "⚠️  No *.ovpn files found in '$OVPN_DIR'."
fi

echo "✅  Cleanup finished."
# 📂 Mass OpenVPN (.ovpn) Installation & Configuration

A tiny set of helper scripts that let you bulk‑register hundreds or thousands of OpenVPN (`*.ovpn`) profiles on a Linux host (or a Qubes AppVM) in just a few seconds.  
Simply point the script to the folder that contains all of your provider’s OpenVPN configuration files, supply the username and password, and everything will be imported into NetworkManager/NMCLI, ready to connect instantly.

---

## ✨ What It Does

- **Bulk‑register** thousands of `.ovpn` files in seconds.  
- **Auto‑fill** the supplied username and password for each profile.  
- Works on any Linux distribution or Qubes AppVM that has **NetworkManager** (or `nmcli`) installed and running.  

---

## 🚀 How to Use

1. **Download** the `.ovpn` files from your VPN provider and place them in a single directory on your Linux system or inside a Qubes AppVM.  
2. Make sure **NetworkManager** (or the `nmcli` command‑line tool) is installed and active.  

---

## 🛠️ Installation

```bash
# Give the scripts execution permission
sudo chmod +x openvpn2.sh clean_all_openvpn.sh

# (Optional) Install them system‑wide so you can run them from any terminal location
sudo cp -r openvpn2.sh /usr/local/bin/
sudo cp -r clean_all_openvpn.sh /usr/local/bin/

# Doe monero para nos ajudar: (donate XMR)

    87JGuuwXzoMGwQAcSD7cvS7D7iacPpN2f5bVqETbUvCgdEmrPZa12gh5DSiKKRgdU7c5n5x1UvZLj8PQ7AAJSso5CQxgjak

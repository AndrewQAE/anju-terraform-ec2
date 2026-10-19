#!/bin/bash

# get admin privileges
sudo su

# install httpd
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
echo "Welcome to DevOps Training" > /var/www/html/index.html


#!/bin/bash

# Ensure the script is run with sudo/root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# --- CONFIGURATION ---
NEW_USER="anju"
# REPLACE THIS WITH THE ACTUAL PUBLIC SSH KEY (.pub) OF THE USER
PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCaSiXaalZSYDZRYRW8EVUncWRychldXjV8o54dwO3SWd4wzpC3BCGhCMJKNZCNHcNYrK4rusxQH5TP0loPAaLIYzQMTNEw0zkAykSmDcxy67x3oOf+WXYMXplL1OFzv/DBePrqP8Vd5J0LcD/xRnO3QRvFBGmY4f3RNcB642BMcGCsiDOImi3sdyJucph7e+6wCi8RZFumFYselArijDBJR7ikD6/cwx0GVoBsCvQRDtqXuEF8A5BrBH2N8ebQn7bauFr188rE4yyEudG5aVwOFHK/oDhDF6CAxfcgy0F0uQmzeHy8EZLS5Dt5D2rJzRaRZwDtMlrrG/r+c/p+QfUT+sMUoZCIO03WZcsJK+X5w2p+hrWBGd+KS2ZCXWquoTdU/SUB1w/QJF7+1mnF+n8hbHxAzm2t4BX84TAdy8pTNjdOAiZkEPx9667uqDYjZSryO4458zE/RNH2wZhUHvOSIcxIkT9+I8NLK8DH4OKZILiazhjWwWA7fbtnm0sjGus= A.T@Andrews-MacBook-Pro-2.local" 
# Set to true if the user needs admin/sudo rights; false if standard user
GRANT_SUDO=true 
# ---------------------

echo "Creating user: $NEW_USER..."

# 1. Create the user with a home directory and default bash shell
if id "$NEW_USER" &>/dev/null; then
    echo "User $NEW_USER already exists!"
else
    useradd -m -s /bin/bash "$NEW_USER"
    echo "User $NEW_USER created successfully."
fi

# 2. Configure SSH Directory and Authorized Keys
USER_HOME="/home/$NEW_USER"
SSH_DIR="$USER_HOME/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

mkdir -p "$SSH_DIR"
echo "$PUBLIC_KEY" > "$AUTH_KEYS"

# 3. Apply strict security permissions required by SSH
chmod 700 "$SSH_DIR"
chmod 600 "$AUTH_KEYS"
chown -R "$NEW_USER:$NEW_USER" "$SSH_DIR"

echo "SSH access configured for $NEW_USER."

# 4. Optional: Grant passwordless sudo access (typical for EC2 service accounts)
if [ "$GRANT_SUDO" = true ]; then
    SUDOERS_FILE="/etc/sudoers.d/90-$NEW_USER"
    echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"
    chmod 0440 "$SUDOERS_FILE"
    echo "Sudo privileges granted to $NEW_USER."
fi

echo "Setup complete! The user can now log in using: ssh -i /path/to/private_key $NEW_USER@<EC2-IP>"

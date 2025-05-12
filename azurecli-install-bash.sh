#!/bin/bash

set -e

# Detect OS and Version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION_ID=$VERSION_ID
else
    echo "Unsupported OS"
    exit 1
fi

echo "Detected OS: $OS, Version: $VERSION_ID"

install_azure_cli() {
    case "$OS" in
        ubuntu|debian)
            echo "Installing Azure CLI for Debian-based systems..."
            curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
            ;;
        opensuse|sles)
            echo "Installing Azure CLI for OpenSUSE/SLES..."
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo zypper addrepo --name 'Azure CLI' --check https://packages.microsoft.com/yumrepos/azure-cli azure-cli
            sudo zypper install -y azure-cli
            ;;
        centos|rhel|fedora)
            echo "Installing Azure CLI for Red Hat-based systems..."
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo tee /etc/yum.repos.d/azure-cli.repo <<EOF
[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
            if [[ "$OS" == "rhel" ]]; then
                if [[ "$VERSION_ID" == "7" ]]; then
                    sudo yum install -y azure-cli
                elif [[ "$RHEL_VERSION" == "9" ]]; then
                sudo dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm
                sudo dnf install -y azure-cli
                elif [[ "$RHEL_VERSION" == "8" ]]; then
                sudo dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
                sudo dnf install -y azure-cli

                else
                    echo "Unsupported RHEL version"
                    exit 1
                fi
            else
                sudo yum install -y azure-cli
            fi
            ;;
        *)
            echo "Unsupported distribution: $OS"
            exit 1
            ;;
    esac
    echo "Azure CLI installation completed."
}

install_azure_cli

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

RHEL_VERSION=$(awk -F'.' '{print $1}' /etc/redhat-release | awk '{print $NF}')

uninstall_azure_cli() {
    case "$OS" in
        ubuntu|debian)
            echo "Uninstalling Azure CLI for Debian-based systems..."
            sudo apt remove --purge -y azure-cli
            ;;
        opensuse|sles)
            echo "Uninstalling Azure CLI for OpenSUSE/SLES..."
            sudo zypper remove -y azure-cli
            ;;
        centos|rhel|fedora)
            echo "Uninstalling Azure CLI for Red Hat-based systems..."
            if [[ "$OS" == "rhel" ]]; then
                if [[ "$RHEL_VERSION" == "7" ]]; then
                    sudo yum remove -y azure-cli
                elif [[ "$RHEL_VERSION" == "8" || "$RHEL_VERSION" == "9" ]]; then
                    sudo dnf remove -y azure-cli
                else
                    echo "Unsupported RHEL version"
                    exit 1
                fi
            else
                sudo yum remove -y azure-cli
            fi
            ;;
        *)
            echo "Unsupported distribution: $OS"
            exit 1
            ;;
    esac
    echo "Azure CLI uninstallation completed."
}

uninstall_azure_cli

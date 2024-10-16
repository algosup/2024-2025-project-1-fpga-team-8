
# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Download the latest release of the repository
REPO_URL="https://github.com/algosup/2024-2025-project-1-fpga-team-8"
LATEST_RELEASE=$(curl -s "$REPO_URL/releases/latest" | grep -oP 'href="\K[^"]+')
DOWNLOAD_URL="https://github.com$LATEST_RELEASE"

echo "Downloading the latest release from $DOWNLOAD_URL..."
wget -q --show-progress "$DOWNLOAD_URL" -O latest_release.zip

# Extract the downloaded zip file
echo "Extracting the downloaded release..."
unzip -q latest_release.zip
rm latest_release.zip  # Remove the zip file after extraction

# Install Python if not installed
if ! command_exists python3; then
    echo "Python is not installed. Installing Python..."
    sudo apt update
    sudo apt install -y python3 python3-pip
else
    echo "Python is already installed."
fi

# Install pip if not installed
if ! command_exists pip3; then
    echo "pip is not installed. Installing pip..."
    sudo apt install -y python3-pip
else
    echo "pip is already installed."
fi

# Install apio using pip
echo "Installing apio..."
pip3 install apio

echo "Setup complete!"

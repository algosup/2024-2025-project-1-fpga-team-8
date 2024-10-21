
# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Download the latest release of the repository
sudo apt install curl
if [ ! -d "./2024-2025-project-1-fpga-team-8-main/"]; then
	curl -L -o project.zip https://github.com/algosup/2024-2025-project-1-fpga-team-8/archive/refs/heads/main.zip
	unzip project.zip
	rm project.zip  # Remove the zip file after extraction
fi

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
sudo apt install python3-apio

cd 2024-2025-project-1-fpga-team-8-main/src/
apio upload
echo "Setup complete! Press any key to close"

read a

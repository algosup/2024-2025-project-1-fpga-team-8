#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error encountered during $1. Exiting...${NC}"
        exit 1
    fi
}

# Ensure Homebrew is installed
echo -e "${YELLOW}Checking for Homebrew...${NC}"
if ! command -v brew &> /dev/null
then
    echo -e "${RED}Homebrew not found! Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    check_error "Homebrew installation"
else
    echo -e "${GREEN}Homebrew is already installed.${NC}"
fi

# Install Python using Homebrew
echo -e "${YELLOW}Installing Python using Homebrew...${NC}"
brew install python
check_error "Python installation"

# Install Apio using pip
echo -e "${YELLOW}Installing Apio...${NC}"
pip3 install apio
check_error "Apio installation"

# Install necessary Apio packages
echo -e "${YELLOW}Installing all necessary Apio packages...${NC}"
apio install -a
check_error "Apio package installation"

# Wait for the user to plug in GoBoard
echo -e "${YELLOW}Please plug in your GoBoard and press [ENTER] to continue...${NC}"
read -p ""

# Enable FTDI drivers
echo -e "${YELLOW}Enabling FTDI drivers...${NC}"
apio drivers --ftdi-enable
check_error "FTDI driver enablement"

# Prompt to unplug and replug GoBoard
echo -e "${YELLOW}Please unplug and replug your GoBoard, then press [ENTER] to continue...${NC}"
read -p ""

# Navigate to the source directory
echo -e "${YELLOW}Navigating to source directory...${NC}"
if [ ! -d "../src" ]; then
    echo -e "${RED}Source directory 'src' not found. Exiting...${NC}"
    exit 1
fi
cd ../src

# Upload code
echo -e "${YELLOW}Uploading code to GoBoard...${NC}"
apio upload
check_error "code upload"

# Display success message
echo -e "${GREEN}Upload successful!${NC}"

# Wait 5 seconds before exiting
sleep 5
exit 0

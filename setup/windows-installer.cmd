@echo off

:: Check if Python is installed
where python >nul 2>nul
set "_fGreen=[32m"
set "_fBWhite=[97m"
set "_fYellow=[33m"
set "_reset=[0m"

:: If Python is not found, download and install it
if %errorlevel% neq 0 (
    echo %_fYellow%Downloading Python...%_reset%
    :: Download the Python installer using curl
    curl -o python-installer.exe https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe

    :: Run the installer in silent mode, add Python to PATH, and install for all users
    python-installer.exe /quiet InstallAllUsers=1 PrependPath=1

    :: Clean up the installer
    del python-installer.exe

    echo Python installation complete.
)

:: Check if the file or directory exists
if not exist "../src/" (
    echo %_fYellow%Downloading the latest version of the game...%_reset%
    curl -L -o project.zip https://github.com/algosup/2024-2025-project-1-fpga-team-8/archive/refs/heads/main.zip
    tar -xf project.zip
    del .\project.zip
    cd .\2024-2025-project-1-fpga-team-8-main\src\
)

if exist "../src/" (
    cd ../src/
)

apio upload



:: Print the message with colors
echo Upload %_fGreen%successful%_fBWhite%! You can now play the game%_reset%

pause
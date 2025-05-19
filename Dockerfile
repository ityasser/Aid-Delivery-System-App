# Use Windows image with Flutter SDK
FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["powershell", "-Command"]

# Install Chocolatey (Windows package manager)
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Git and Flutter dependencies
RUN choco install -y git vscode

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git C:\flutter
ENV PATH="C:\\flutter\\bin;C:\\flutter\\bin\\cache\\dart-sdk\\bin;%PATH%"

# Enable Windows desktop support
RUN flutter doctor
RUN flutter config --enable-windows-desktop

# Set working directory
WORKDIR C:/app

# Copy project files
COPY . .

# Get dependencies
RUN flutter pub get

# Build Windows executable
RUN flutter build windows

#!/bin/bash

echo "=== Installing Torrentio-scraper with MediaFlow Proxy Light using Podman ==="
echo "MediaFlow Proxy password is set to: mib2003"
echo

# Check if Podman is installed
if ! command -v podman &> /dev/null; then
    echo "Podman is not installed. Please install Podman first."
    echo "Visit https://podman.io/getting-started/installation for installation instructions."
    exit 1
fi

# Check if Podman Compose is installed
if ! command -v podman-compose &> /dev/null; then
    echo "Podman Compose is not installed."
    echo "You can install it using pip: pip install podman-compose"
    echo "Or visit https://github.com/containers/podman-compose for installation instructions."
    exit 1
fi

# Ask for GitHub authentication if needed
read -p "Do you need to authenticate with GitHub Container Registry? (y/n): " need_auth
if [[ "$need_auth" == "y" || "$need_auth" == "Y" ]]; then
    read -p "Enter your GitHub username: " github_user
    read -sp "Enter your GitHub token: " github_token
    echo
    
    echo "Logging in to GitHub Container Registry..."
    echo "$github_token" | podman login ghcr.io -u "$github_user" --password-stdin
    if [ $? -ne 0 ]; then
        echo "Failed to authenticate with GitHub Container Registry."
        echo "Please check your credentials and try again."
        exit 1
    fi
fi

echo "Creating pod network..."
podman network create torrentio-network 2>/dev/null || true

echo "Starting services..."
# Use podman-compose with the Podman-specific compose file
podman-compose -f podman-compose.yml up -d

echo
echo "=== Installation Complete ==="
echo "Torrentio-scraper is running at: http://localhost:7000"
echo "MediaFlow Proxy Light is running at: http://localhost:8888"
echo
echo "To configure Torrentio with MediaFlow Proxy:"
echo "1. Go to http://localhost:7000/configure"
echo "2. Configure your desired settings"
echo "3. In the MediaFlow Proxy Light Integration section, enable the proxy"
echo "4. Set the MediaFlow Proxy URL to: http://localhost:8888"
echo "5. Set the MediaFlow Proxy API Password to: mib2003"
echo "6. Click INSTALL to apply your configuration"
echo
echo "To check logs:"
echo "  podman-compose -f podman-compose.yml logs -f"
echo
echo "To stop the services:"
echo "  podman-compose -f podman-compose.yml down"
echo
echo "Note: If running rootless Podman on a system with SELinux, you may need to"
echo "adjust your system settings to allow container access to filesystem volumes." 
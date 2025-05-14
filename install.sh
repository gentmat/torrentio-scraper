#!/bin/bash

echo "=== Installing Torrentio-scraper with MediaFlow Proxy Light ==="
echo "MediaFlow Proxy password is set to: mib2003"
echo

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    echo "Visit https://docs.docker.com/get-docker/ for installation instructions."
    exit 1
fi

# Check if Docker Compose is installed
if ! docker compose version &> /dev/null; then
    echo "Docker Compose is not installed or not in the correct version."
    echo "Please install Docker Compose V2 first."
    echo "Visit https://docs.docker.com/compose/install/ for installation instructions."
    exit 1
fi

# Ask for GitHub authentication if needed
read -p "Do you need to authenticate with GitHub Container Registry? (y/n): " need_auth
if [[ "$need_auth" == "y" || "$need_auth" == "Y" ]]; then
    read -p "Enter your GitHub username: " github_user
    read -sp "Enter your GitHub token: " github_token
    echo
    
    echo "Logging in to GitHub Container Registry..."
    echo "$github_token" | docker login ghcr.io -u "$github_user" --password-stdin
    if [ $? -ne 0 ]; then
        echo "Failed to authenticate with GitHub Container Registry."
        echo "Please check your credentials and try again."
        exit 1
    fi
fi

echo "Starting services..."
docker compose up -d

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
echo "  docker compose logs -f"
echo
echo "To stop the services:"
echo "  docker compose down" 
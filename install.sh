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

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Please install Git first."
    echo "Visit https://git-scm.com/downloads for installation instructions."
    exit 1
fi

# Create a temp directory for cloning and building
echo "Creating temporary build directory..."
BUILD_DIR=$(mktemp -d)
cd "$BUILD_DIR"

# Clone the repository
echo "Cloning torrentio-scraper repository..."
git clone https://github.com/gentmat/torrentio-scraper.git
if [ $? -ne 0 ]; then
    echo "Failed to clone repository."
    exit 1
fi

# Build the Docker image
echo "Building torrentio-scraper Docker image..."
cd torrentio-scraper
docker build -t local/torrentio-scraper:latest -f addon/Dockerfile addon/
if [ $? -ne 0 ]; then
    echo "Failed to build Docker image."
    exit 1
fi

# Return to original directory
cd "$OLDPWD"

# Clean up temp directory
rm -rf "$BUILD_DIR"

# Update docker-compose.yml to use local image
sed -i 's|ghcr.io/gentmat/torrentio-scraper:latest|local/torrentio-scraper:latest|g' docker-compose.yml

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
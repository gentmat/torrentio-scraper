# Torrentio-scraper with MediaFlow Proxy Light

This guide helps you set up Torrentio-scraper with MediaFlow Proxy Light integration in Docker or Podman.

## Prerequisites

### For Docker installation:
- Docker installed on your system
- Docker Compose V2 installed on your system
- Ports 7000 and 8888 available on your host machine

### For Podman installation:
- Podman installed on your system
- podman-compose installed (can be installed via pip)
- Ports 7000 and 8888 available on your host machine

## Installation

### Using Docker:

1. Make sure the installation script is executable:
   ```bash
   chmod +x install.sh
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

### Using Podman:

1. Make sure the Podman installation script is executable:
   ```bash
   chmod +x installPodman.sh
   ```

2. Run the Podman installation script:
   ```bash
   ./installPodman.sh
   ```

3. After installation completes, access Torrentio at:
   [http://localhost:7000](http://localhost:7000)

## Configuration

1. Go to Torrentio's configuration page:
   [http://localhost:7000/configure](http://localhost:7000/configure)

2. Configure your desired Torrentio settings (providers, sorting, etc.)

3. In the MediaFlow Proxy Light Integration section:
   - Check the "Enable MediaFlow Proxy Light" box
   - Set the MediaFlow Proxy URL to: `http://localhost:8888`
   - Set the MediaFlow Proxy API Password to: `mib2003`

4. Click the INSTALL button to apply your configuration

## Accessing Your Setup

- Torrentio-scraper: [http://localhost:7000](http://localhost:7000)
- MediaFlow Proxy Light: [http://localhost:8888](http://localhost:8888)

## Management Commands

### For Docker:

- View logs:
  ```bash
  docker compose logs -f
  ```

- Stop the services:
  ```bash
  docker compose down
  ```

- Restart the services:
  ```bash
  docker compose restart
  ```

### For Podman:

- View logs:
  ```bash
  podman-compose -f podman-compose.yml logs -f
  ```

- Stop the services:
  ```bash
  podman-compose -f podman-compose.yml down
  ```

- Restart the services:
  ```bash
  podman-compose -f podman-compose.yml restart
  ```

## Remote Access

If you want to access your Torrentio setup from outside your local network:

1. Make sure ports 7000 and 8888 are forwarded on your router
2. Replace `localhost` with your public IP address in the MediaFlow Proxy URL configuration
3. Consider using a domain name with HTTPS for secure access

## Troubleshooting

- If you encounter issues, check the container logs using the appropriate command for your environment (Docker or Podman)

- Ensure no other services are using ports 7000 or 8888

- Verify that all containers are running:
  ```bash
  # For Docker
  docker compose ps
  
  # For Podman
  podman-compose -f podman-compose.yml ps
  ```

### Podman-specific issues:

- SELinux: If running rootless Podman on a system with SELinux, you might need to set appropriate SELinux contexts for volume mounts or run with `--privileged` flag
  
- If you experience networking issues, check that the network was properly created:
  ```bash
  podman network ls
  ``` 
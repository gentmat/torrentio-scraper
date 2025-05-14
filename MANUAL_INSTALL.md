# Manual Installation Guide for Torrentio-scraper with MediaFlow Proxy

This guide provides detailed, step-by-step instructions for installing and running Torrentio-scraper and MediaFlow Proxy Light without Docker or Podman. Instructions are provided for both Ubuntu/Debian and Arch Linux distributions.

## Prerequisites

Before you begin, ensure you have the following installed:

1. Install Git:
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install git

   # Arch Linux
   sudo pacman -Syu
   sudo pacman -S git
   ```

2. Install Node.js (v16 or newer):
   ```bash
   # Ubuntu/Debian
   curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
   sudo apt install -y nodejs

   # Arch Linux
   sudo pacman -S nodejs npm
   ```

3. Install PostgreSQL:
   ```bash
   # Ubuntu/Debian
   sudo apt install postgresql postgresql-contrib

   # Arch Linux
   sudo pacman -S postgresql
   sudo -u postgres initdb -D /var/lib/postgres/data
   sudo systemctl enable postgresql
   sudo systemctl start postgresql
   ```

4. Install Rust and Cargo:
   ```bash
   # Both Ubuntu/Debian and Arch Linux
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   
   # After installation, set up your shell environment:
   # For bash/zsh/sh
   source $HOME/.cargo/env
   
   # For fish shell
   set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths
   # Or if available
   # source $HOME/.cargo/env.fish
   ```

## Part 1: Installing Torrentio-scraper

### Step 1: Clone the Repository

1. Create a directory for your installation:
   ```bash
   mkdir -p ~/torrentio
   cd ~/torrentio
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/gentmat/torrentio-scraper.git
   cd torrentio-scraper
   ```

### Step 2: Set Up PostgreSQL Database

1. Start PostgreSQL service (if not already running):
   ```bash
   # Both Ubuntu/Debian and Arch Linux
   sudo systemctl start postgresql
   sudo systemctl enable postgresql
   ```

2. Create a database for Torrentio:
   ```bash
   # Both Ubuntu/Debian and Arch Linux
   sudo -u postgres psql
   ```

3. In the PostgreSQL prompt, enter the following commands:
   ```sql
   CREATE DATABASE torrentio;
   CREATE USER torrentio WITH ENCRYPTED PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE torrentio TO torrentio;
   \q
   ```
   Note: Replace 'your_password' with a secure password of your choice.

### Step 3: Install and Run Torrentio-scraper

1. Navigate to the addon directory:
   ```bash
   cd ~/torrentio/torrentio-scraper/addon
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create an environment variables file:
   ```bash
   # For bash/zsh/sh
   cat > .env << EOF
   PORT=7000
   DATABASE_URI=postgres://torrentio:your_password@localhost:5432/torrentio
   CACHE_MAX_AGE=3600
   EOF
   
   # For fish shell
   echo 'PORT=7000
   DATABASE_URI=postgres://torrentio:your_password@localhost:5432/torrentio
   CACHE_MAX_AGE=3600' > .env
   ```
   Note: Replace 'your_password' with the same password you used when creating the PostgreSQL user.

4. Install dotenv for loading environment variables:
   ```bash
   npm install dotenv
   ```

5. Start the server:
   ```bash
   node -r dotenv/config index.js
   ```

6. (Optional) Install PM2 to keep the server running:
   ```bash
   # Both Ubuntu/Debian and Arch Linux
   sudo npm install -g pm2
   ```

7. (Optional) Start the server with PM2:
   ```bash
   pm2 start "node -r dotenv/config index.js" --name torrentio
   ```

8. (Optional) Configure PM2 to start on boot:
   ```bash
   # Generate the startup command
   pm2 startup
   
   # You'll see output like this:
   # [PM2] Init System found: systemd
   # [PM2] To setup the Startup Script, copy/paste the following command:
   # sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u YOUR_USERNAME --hp /home/YOUR_USERNAME
   
   # Instead of copying the output, you can run this command which will substitute your username automatically:
   # Replace YOUR_USERNAME with your actual username or use the command below:
   sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u $(whoami) --hp /home/$(whoami)
   
   # Save the current PM2 process list
   pm2 save
   ```

9. Access Torrentio-scraper to verify installation:
   ```
   http://localhost:7000
   ```
   You should see the Torrentio landing page. If you want to configure it, go to:
   ```
   http://localhost:7000/configure
   ```

## Part 2: Installing MediaFlow Proxy Light

### Step 1: Clone and Build MediaFlow Proxy Light

1. Navigate to your installation directory:
   ```bash
   cd ~/torrentio
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/mhdzumair/MediaFlow-Proxy-Light.git
   cd MediaFlow-Proxy-Light
   ```

3. Install build dependencies (if needed):
   ```bash
   # Ubuntu/Debian
   sudo apt install build-essential pkg-config libssl-dev

   # Arch Linux
   sudo pacman -S base-devel openssl
   ```

4. Build the project (this might take a few minutes):
   ```bash
   cargo build --release
   ```

### Step 2: Create Configuration File

1. Create a config.toml file:
   ```bash
   # For bash/zsh/sh
   cat > config.toml << EOF
   [app.server]
   host = "0.0.0.0"
   port = 8888
   workers = 4

   [app.auth]
   api_password = "mib2003"
   EOF
   
   # For fish shell
   echo '[app.server]
   host = "0.0.0.0"
   port = 8888
   workers = 4

   [app.auth]
   api_password = "mib2003"' > config.toml
   ```
   Note: You can change the 'mib2003' password to a secure password of your choice.

### Step 3: Run MediaFlow Proxy Light

1. Run the proxy with the config file:
   ```bash
   CONFIG_PATH=./config.toml ./target/release/mediaflow-proxy-light
   ```

2. (Optional) To run it with PM2:
   ```bash
   pm2 start --name mediaflow-proxy "CONFIG_PATH=./config.toml ./target/release/mediaflow-proxy-light"
   ```

3. (Optional) Save the PM2 configuration:
   ```bash
   pm2 save
   ```

## Part 3: Configuring Torrentio with MediaFlow Proxy

1. Open a web browser and navigate to:
   ```
   http://localhost:7000/configure
   ```

2. Configure your desired settings for Torrentio-scraper

3. In the MediaFlow Proxy Light Integration section:
   - Check the box to "Enable MediaFlow Proxy Light"
   - Set the MediaFlow Proxy URL to: `http://localhost:8888`
   - Set the MediaFlow Proxy API Password to: `mib2003` (or your chosen password)

4. Click INSTALL to apply your configuration

## Part 4: Accessing Your Setup

1. To access Torrentio-scraper:
   ```
   http://localhost:7000
   ```

2. To install the addon in Stremio, use:
   ```
   http://localhost:7000/[your_configuration_hash].bundle
   ```

3. To access MediaFlow Proxy status (if enabled):
   ```
   http://localhost:8888/status
   ```

## Part 5: Creating Systemd Services (For Persistent Operation)

### Torrentio-scraper Service

1. Create the systemd service file:
   ```bash
   # Both Ubuntu/Debian and Arch Linux
   sudo mkdir -p /etc/systemd/system
   sudo nano /etc/systemd/system/torrentio.service
   ```

2. Add the following content to the file:
   ```
   [Unit]
   Description=Torrentio Stremio Addon
   After=network.target postgresql.service

   [Service]
   Type=simple
   User=$(whoami)
   WorkingDirectory=$(realpath ~/torrentio/torrentio-scraper/addon)
   Environment=PORT=7000
   Environment=DATABASE_URI=postgres://torrentio:your_password@localhost:5432/torrentio
   Environment=CACHE_MAX_AGE=3600
   ExecStart=$(which node) index.js
   Restart=always
   RestartSec=10

   [Install]
   WantedBy=multi-user.target
   ```
   Note: Replace 'your_password' with your PostgreSQL password.

3. Save and exit the editor (Ctrl+X, then Y, then Enter)

### MediaFlow Proxy Light Service

1. Create the systemd service file:
   ```bash
   sudo nano /etc/systemd/system/mediaflow-proxy.service
   ```

2. Add the following content to the file:
   ```
   [Unit]
   Description=MediaFlow Proxy Light Service
   After=network.target

   [Service]
   Type=simple
   User=$(whoami)
   WorkingDirectory=$(realpath ~/torrentio/MediaFlow-Proxy-Light)
   Environment=CONFIG_PATH=$(realpath ~/torrentio/MediaFlow-Proxy-Light/config.toml)
   ExecStart=$(realpath ~/torrentio/MediaFlow-Proxy-Light/target/release/mediaflow-proxy-light)
   Restart=always
   RestartSec=10

   [Install]
   WantedBy=multi-user.target
   ```

3. Save and exit the editor (Ctrl+X, then Y, then Enter)

### Enable and Start the Services

1. Reload systemd configuration:
   ```bash
   # Both Ubuntu/Debian and Arch Linux
   sudo systemctl daemon-reload
   ```

2. Enable services to start on boot:
   ```bash
   sudo systemctl enable torrentio.service
   sudo systemctl enable mediaflow-proxy.service
   ```

3. Start the services:
   ```bash
   sudo systemctl start torrentio.service
   sudo systemctl start mediaflow-proxy.service
   ```

4. Check service status:
   ```bash
   sudo systemctl status torrentio.service
   sudo systemctl status mediaflow-proxy.service
   ```

## Troubleshooting

1. If services fail to start, check logs:
   ```bash
   sudo journalctl -u torrentio.service -n 50
   sudo journalctl -u mediaflow-proxy.service -n 50
   ```

2. If you need to restart services after changes:
   ```bash
   sudo systemctl restart torrentio.service
   sudo systemctl restart mediaflow-proxy.service
   ```

3. To view real-time logs:
   ```bash
   sudo journalctl -u torrentio.service -f
   sudo journalctl -u mediaflow-proxy.service -f
   ```

4. PostgreSQL issues:
   ```bash
   # Ubuntu/Debian
   sudo systemctl status postgresql
   
   # Arch Linux
   # If you have issues with PostgreSQL authentication
   sudo nano /var/lib/postgres/data/pg_hba.conf
   # Change authentication method from 'peer' to 'md5' for local connections
   sudo systemctl restart postgresql
   ```
#!/bin/bash
# ═══════════════════════════════════════════════════════════
# Travel Ambalangoda — Laravel Backend Setup Script
# Run this on your DigitalOcean droplet:
#   curl -sL https://raw.githubusercontent.com/menukadilhara1/travel-api-backend/main/setup.sh | bash
# ═══════════════════════════════════════════════════════════

set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Travel Ambalangoda API  — Setup     ║"
echo "╚══════════════════════════════════════╝"
echo ""

INSTALL_DIR="/var/www/travel-api"
DB_NAME="travel_planner"
DB_USER="travel_user"
DB_PASS="Travel2026Pass"
PORT="8080"

# ── 1. Create Laravel project ──────────────────────────────
echo "▶ Creating Laravel project at $INSTALL_DIR..."
sudo mkdir -p $INSTALL_DIR
sudo chown $(whoami):$(whoami) $INSTALL_DIR

if [ -f "$INSTALL_DIR/artisan" ]; then
  echo "  Laravel already exists — skipping composer create-project"
else
  composer create-project laravel/laravel $INSTALL_DIR --prefer-dist -q
  echo "  ✓ Laravel installed"
fi

cd $INSTALL_DIR

# ── 2. Install Sanctum ─────────────────────────────────────
echo "▶ Installing Laravel Sanctum..."
composer require laravel/sanctum -q
echo "  ✓ Sanctum installed"

# ── 3. Copy custom files from this repo ───────────────────
echo "▶ Copying custom backend files..."
REPO_RAW="https://raw.githubusercontent.com/menukadilhara1/backend-travel-ambalangoda/main/src"

curl -sL -o app/Http/Controllers/AuthController.php  $REPO_RAW/AuthController.php
curl -sL -o routes/api.php                           $REPO_RAW/api.php
curl -sL -o config/cors.php                          $REPO_RAW/cors.php
curl -sL -o app/Models/User.php                      $REPO_RAW/User.php
curl -sL -o bootstrap/app.php                        $REPO_RAW/bootstrap_app.php
echo "  ✓ Custom files copied"

# ── 4. Configure .env ─────────────────────────────────────
echo "▶ Configuring .env..."
cp .env.example .env

sed -i "s|APP_URL=http://localhost|APP_URL=http://$(curl -s ifconfig.me):$PORT|" .env
sed -i "s/APP_DEBUG=true/APP_DEBUG=false/" .env
sed -i "s/DB_CONNECTION=sqlite/DB_CONNECTION=mysql/" .env
sed -i "s/# DB_HOST=127.0.0.1/DB_HOST=127.0.0.1/"   .env
sed -i "s/# DB_PORT=3306/DB_PORT=3306/"               .env
sed -i "s/# DB_DATABASE=laravel/DB_DATABASE=$DB_NAME/" .env
sed -i "s/# DB_USERNAME=root/DB_USERNAME=$DB_USER/"   .env
sed -i "s/# DB_PASSWORD=/DB_PASSWORD=$DB_PASS/"       .env

php artisan key:generate --quiet
echo "  ✓ .env configured"

# ── 5. Setup MySQL database ────────────────────────────────
echo "▶ Setting up MySQL database..."
sudo mysql -u root -e "
  CREATE DATABASE IF NOT EXISTS $DB_NAME;
  CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
  GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
  FLUSH PRIVILEGES;
"
echo "  ✓ Database ready"

# ── 6. Run migrations ─────────────────────────────────────
echo "▶ Running migrations..."
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider" --quiet
php artisan migrate --force --quiet
echo "  ✓ Migrations done"

# ── 7. Kill any old server + start fresh ──────────────────
echo "▶ Starting API server on port $PORT..."
pkill -f "artisan serve" 2>/dev/null || true
sleep 1
nohup php artisan serve --host=0.0.0.0 --port=$PORT > /tmp/travel-api.log 2>&1 &
sleep 2

# ── 8. Test ────────────────────────────────────────────────
echo "▶ Testing API..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/api/register)
if [ "$RESPONSE" = "405" ] || [ "$RESPONSE" = "422" ] || [ "$RESPONSE" = "200" ]; then
  echo "  ✓ API is responding (HTTP $RESPONSE — expected)"
else
  echo "  ✗ Unexpected response: HTTP $RESPONSE"
  echo "  Check logs: tail -f /tmp/travel-api.log"
fi

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  Setup Complete!                                     ║"
echo "║  API running at: http://$(curl -s ifconfig.me):$PORT/api   ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

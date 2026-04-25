# travel-api-backend

Laravel 11 backend API for the **Travel Ambalangoda** project (ITE2953).

## One-Command Setup on DigitalOcean

SSH into your droplet and run:

```bash
curl -sL https://raw.githubusercontent.com/menukadilhara1/travel-api-backend/main/setup.sh | bash
```

That's it. The script will:
- Create a Laravel project at `/var/www/travel-api`
- Install Sanctum
- Configure MySQL database
- Apply all custom files
- Start the API on port **8080**

## API Endpoints

| Method | URL | Auth |
|--------|-----|------|
| POST | `/api/register` | No |
| POST | `/api/login` | No |
| POST | `/api/logout` | Yes |
| GET | `/api/user` | Yes |

## Tech Stack

- Laravel 11 + Sanctum
- MySQL 8
- PHP 8.3

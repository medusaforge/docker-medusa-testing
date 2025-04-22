# MedusaJS Test Docker Image

This repository contains a pre-configured **Docker image for MedusaJS v2** bundled with an internal **PostgreSQL server** and seeded test data. It's ideal for development, local testing, CI/CD, and plugin experiments.

## Features

- Fully initialized **MedusaJS v2** instance
- Embedded **PostgreSQL** database running in the same container
- Pre-seeded with:
    - **Admin user**
        - Email: `me@hsalem.com`
        - Password: `hsalem.com`
    - **Customer**
        - Email: `customer_1@hsalem.com`
        - Password: `password`
    - **Fake publishable key**:
        - `pk_0000000000000000000000000000000000000000000000000000000000000000`
    - **Promotions**:
        - Standard percentage discount: `10PERCENTOFF` (10% off)
        - Fixed amount discount: `5DOLLAROFF` ($5 off)
        - Buy X get Y promotion: `BUY2GET1` (buy 2 get 1 free)
        - Campaign promotion: `SUMMER2023` (15% off, part of Summer Sale 2023 campaign)
        - Additional promotions managed in campaigns:
            - `FLASH25` (25% off, added to Summer Sale 2023 campaign)
            - `WEEKEND30` (30% off, added then removed from Summer Sale 2023 campaign)

## Project Architecture

This project consists of several key components:

### Docker Container Structure

```
┌─────────────────────────────────────────┐
│              Docker Container           │
│                                         │
│  ┌─────────────────┐  ┌──────────────┐  │
│  │   MedusaJS v2   │  │  PostgreSQL  │  │
│  │                 │  │              │  │
│  │  - Admin API    │  │  - medusa DB │  │
│  │  - Store API    │  │              │  │
│  │  - Auth API     │  │              │  │
│  └─────────────────┘  └──────────────┘  │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │          Seed Scripts           │    │
│  │                                 │    │
│  │  - Customers                    │    │
│  │  - Promotions                   │    │
│  │  - Publishable Key              │    │
│  └─────────────────────────────────┘    │
│                                         │
└─────────────────────────────────────────┘
```

### Container Initialization Process

1. PostgreSQL server starts
2. Database migrations are run
3. Admin user is created
4. Fake data is seeded (default Medusa seed)
5. Custom data is seeded (customers, promotions, publishable key)
6. Medusa server starts


## How to Use

### Run from Docker Hub

```bash
docker run -p 9000:9000 hassansalem/docker-medusa-testing:latest
```

Access Medusa server at:

```
http://localhost:9000
```

Login using the seeded credentials.

### Using the Makefile

This project includes a Makefile to simplify Docker operations:

```bash
# Build and run the container (default)
make

# Only build the Docker image
make build

# Only run the container (if already built)
make run

# Stop and remove the container
make stop

# Clean up container and image
make clean

# Show help information
make help
```

You can customize the build by setting variables:

```bash
# Example: Custom image name and port
make IMAGE_NAME=my-medusa PORT=8000 all
```

## Seeding Process

The Docker container automatically seeds the database with test data during initialization. Here's what gets seeded:

### Admin User
- Created using `npx medusa user` command
- Email: `me@hsalem.com`
- Password: `hsalem.com`

### Default Medusa Data
- Seeded using the default Medusa seed script (`seed.ts`)
- Includes products, regions, shipping options, etc.

### Customers
- Seeded using `seed-customers.ts`
- Creates a customer account with:
  - Email: `customer_1@hsalem.com`
  - Password: `password`
  - First name: `CustomerFirstName`
  - Last name: `CustomerLastName`

### Promotions
- Seeded using `seed-promotions.ts`
- Creates various types of promotions:
  - Standard percentage discount: `10PERCENTOFF` (10% off)
  - Fixed amount discount: `5DOLLAROFF` ($5 off)
  - Buy X get Y promotion: `BUY2GET1` (buy 2 get 1 free)
  - Campaign promotion: `SUMMER2023` (15% off, part of Summer Sale 2023 campaign)
  - Additional promotions managed in campaigns:
    - `FLASH25` (25% off, added to Summer Sale 2023 campaign)
    - `WEEKEND30` (30% off, added then removed from Summer Sale 2023 campaign)

### Publishable Key
- Seeded using `seed-publishable-key.ts`
- Sets a fake publishable key: `pk_0000000000000000000000000000000000000000000000000000000000000000`

## Customization

You can customize this Docker image in several ways:

### Environment Variables

The following environment variables can be set when running the container:

- `DATABASE_URL`: PostgreSQL connection string (default: `postgres://medusa:medusa@localhost:5432/medusa`)
- `STORE_CORS`: CORS settings for the Store API
- `ADMIN_CORS`: CORS settings for the Admin API
- `AUTH_CORS`: CORS settings for the Auth API
- `JWT_SECRET`: Secret for JWT tokens (default: `supersecret`)
- `COOKIE_SECRET`: Secret for cookies (default: `supersecret`)

Example:
```bash
docker run -p 9000:9000 -e JWT_SECRET=mysecret -e COOKIE_SECRET=mycookiesecret hassansalem/docker-medusa-testing:latest
```

### Custom Seed Data

To customize the seed data:

1. Fork this repository
2. Modify the seed scripts in the `data/` directory:
   - `seed-customers.ts`: Customize customer data
   - `seed-promotions.ts`: Customize promotion data
   - `seed-publishable-key.ts`: Customize publishable key
3. Build your custom Docker image using the Makefile:
   ```bash
   make IMAGE_NAME=my-custom-medusa build
   ```

### Custom Configuration

To customize the Medusa configuration:

1. Fork this repository
2. Modify `config/medusa-config.ts`
3. Build your custom Docker image

## Versioning

This image uses a dual-versioning system:

- The tag format is: `v<medusa-version>-<image-version>`
- Example: `v2.7.0-1`
    - `v2.7.0` refers to the MedusaJS version
    - `-1` indicates the Docker image version for that Medusa release (for bugfixes, tweaks, etc.)

This helps distinguish between different Docker builds of the same Medusa version.

## Use Cases

- Local plugin or theme development
- CI/CD and integration testing
- MedusaJS learning sandbox
- Backend service mocking

## Git Tag-Based Publishing

This image is built and pushed automatically when a Git tag like `v2.7.0-1` is pushed to the repository:

```bash
git tag v2.7.0-1
git push origin v2.7.0-1
```

The resulting Docker image will be tagged as:

- `latest`
- `v2.7.0-1`

## License

This project is licensed under the [MIT License](LICENSE).

## Project Structure

```
├── config/
│   └── medusa-config.ts         # Medusa configuration file
├── data/
│   ├── seed-customers.ts        # Script to seed customer data
│   ├── seed-promotions.ts       # Script to seed promotion data
│   └── seed-publishable-key.ts  # Script to seed publishable key
├── scripts/
│   └── develop.sh               # Container entrypoint script that handles seeding
├── Dockerfile                   # Docker image definition
├── Makefile                     # Build automation
├── LICENSE                      # MIT License
└── README.md                    # This documentation
```

### Key Files

- **Dockerfile**: Defines how the Docker image is built, including installing dependencies, setting up PostgreSQL, and copying configuration files.
- **develop.sh**: Container entrypoint script that starts PostgreSQL, runs migrations, creates the admin user, seeds data, and starts the Medusa server.
- **medusa-config.ts**: Configures the Medusa server, including database connection and HTTP settings.
- **seed-*.ts**: Scripts that seed the database with test data.
- **Makefile**: Provides commands for building and running the Docker container.

## Contributions

PRs welcome! Feel free to open issues for improvements or questions.

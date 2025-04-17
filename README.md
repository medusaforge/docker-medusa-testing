# MedusaJS Test Docker Image

This repository contains a pre-configured **Docker image for MedusaJS v2** bundled with an internal **PostgreSQL server** and seeded test data. It's ideal for development, local testing, CI/CD, and plugin experiments.

---

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

---

## How to Use

### Run from Docker Hub

```bash
docker run -p 9000:9000 hassansalem/medusajs-test:latest
```

Access Medusa server at:

```
http://localhost:9000
```

Login using the seeded credentials.

---

## Versioning

This image uses a dual-versioning system:

- The tag format is: `v<medusa-version>-<image-version>`
- Example: `v2.7.0-1`
    - `v2.7.0` refers to the MedusaJS version
    - `-1` indicates the Docker image version for that Medusa release (for bugfixes, tweaks, etc.)

This helps distinguish between different Docker builds of the same Medusa version.

---

## Use Cases

- Local plugin or theme development
- CI/CD and integration testing
- MedusaJS learning sandbox
- Backend service mocking

---

## Git Tag-Based Publishing

This image is built and pushed automatically when a Git tag like `v2.7.0-1` is pushed to the repository:

```bash
git tag v2.7.0-1
git push origin v2.7.0-1
```

The resulting Docker image will be tagged as:

- `latest`
- `v2.7.0-1`

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Contributions

PRs welcome! Feel free to open issues for improvements or questions.
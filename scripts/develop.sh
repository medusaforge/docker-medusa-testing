#!/bin/bash

echo "Starting PostgreSQL..."
service postgresql start

echo "Waiting for PostgreSQL to be ready..."
until pg_isready -h localhost -p 5432 -U medusa; do
  sleep 1
done

export DATABASE_URL=$DATABASE_URL || 'postgres://medusa:medusa@localhost:5432/medusa'

echo "Running migrations..."
npx medusa db:migrate

echo "Setup user"
npx medusa user --email me@hsalem.com --password "hsalem.com"
echo "User email: me@hsalem.com, password: hsalem.com"
echo "Finished user setup"

echo "Seeding fake data..."
npx medusa exec src/scripts/seed.ts
echo "Finished fake data seeding"

echo "Seeding Customers..."
npx medusa exec src/scripts/seed-customers.ts
echo "Finished Customers seeding"

echo "Seeding fake publishable key..."
npx medusa exec src/scripts/seed-publishable-key.ts
echo "Finished fake publishable key seeding"

echo "Starting Medusa..."
npx medusa develop

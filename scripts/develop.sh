#!/bin/bash

echo "Migrating database...${DB_NAME}"
npx medusa db:setup --db "$DB_NAME" --no-interactive
echo "Finished database migration"

echo "Setup user"
npx medusa user --email me@hsalem.com --password "hsalem.com"
echo "User email: me@hsalem.com, password: hsalem.com"
echo "Finished user setup"

echo "Starting Medusa server..."
npx medusa develop
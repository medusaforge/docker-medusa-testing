#!/bin/bash

cd /app/medusa || exit 1

echo "Seeding fake data"
npx medusa exec src/scripts/seed.ts
echo "Finished fake data seeding"


echo "Seeding database..."
npx medusa exec src/scripts/seed-customers.ts
echo "Finished database seeding"

echo "Seeding Customers..."
npx medusa exec src/scripts/seed-customers.ts
echo "Finished Customers seeding"

echo "Finished seeding"
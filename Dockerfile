FROM node:20.17.0

# Install OS deps
RUN apt-get update && \
    apt-get install -y python3 python-is-python3 postgresql postgresql-contrib

# Create postgres user and database
USER postgres
RUN /etc/init.d/postgresql start && \
    psql --command "CREATE USER medusa WITH SUPERUSER PASSWORD 'medusa';" && \
    createdb -O medusa medusa

USER root

WORKDIR /app

# Install Medusa CLI and create app
RUN npm install -g npm@latest
RUN npm install -g @medusajs/medusa-cli@latest
RUN npm install -g create-medusa-app@2.6.0

# Create Medusa app
RUN npx --yes create-medusa-app@2.7.0 medusa \
    --with-nextjs-starter false \
    --skip-db \
    --verbose true

# Copy entrypoint script and config
COPY ./scripts/develop.sh /app/develop.sh
COPY ./config/medusa-config.ts /app/medusa/medusa-config.ts

COPY ./data/seed-customers.ts /app/medusa/src/scripts/
COPY ./data/seed-publishable-key.ts /app/medusa/src/scripts/
COPY ./data/seed-promotions.ts /app/medusa/src/scripts/

# Make entrypoint executable
RUN chmod +x /app/develop.sh

# Set working directory to medusa app
WORKDIR /app/medusa

# Expose Medusa port
EXPOSE 9000

ENTRYPOINT ["/app/develop.sh"]

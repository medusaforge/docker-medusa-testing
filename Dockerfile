FROM node:20.17.0

WORKDIR /app

RUN apt-get update

RUN apt-get install -y python3 python-is-python3

RUN npm install -g npm@latest

RUN npm install -g @medusajs/medusa-cli@latest
RUN npm install -g create-medusa-app@2.6.0

RUN npx --yes create-medusa-app@2.7.0 medusa \
    --with-nextjs-starter false \
    --skip-db \
    --verbose true

COPY ./scripts/develop.sh /app/develop.sh

WORKDIR /app/medusa

ENTRYPOINT ["/app/develop.sh"]
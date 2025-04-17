import {ExecArgs} from "@medusajs/framework/types";
import {
  ContainerRegistrationKeys, Modules,
} from "@medusajs/framework/utils";
import knex from "knex";

export default async function seedPublishableKey({container}: ExecArgs) {
  const logger = container.resolve(ContainerRegistrationKeys.LOGGER);
  logger.info("Seeding Publishable Key...");

  const apiKeyService = container.resolve(Modules.API_KEY);
  const keys = await apiKeyService.listApiKeys();
  if (keys.length > 0) {
    const apiKey = keys[0];
    const id = apiKey.id

    const db = knex({
      client: 'pg',
      connection: process.env.DATABASE_URL,
    })

    await db.update({
      token: 'pk_0000000000000000000000000000000000000000000000000000000000000000'
    }).from('api_key').where({
      id: id
    })
  }
  logger.info("Publishable Key seeded successfully");
}


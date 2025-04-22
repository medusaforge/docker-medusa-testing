import {
  createPromotionsWorkflow,
} from "@medusajs/medusa/core-flows";
import {ExecArgs} from "@medusajs/framework/types";
import {
  ContainerRegistrationKeys, Modules,
} from "@medusajs/framework/utils";

export default async function seedPromotions({container}: ExecArgs) {
  const logger = container.resolve(ContainerRegistrationKeys.LOGGER);

  logger.info("Seeding Promotions...");

  try {
    // Create a standard percentage discount promotion
    const { result: standardPromotion } = await createPromotionsWorkflow(container).run({
      input: {
        promotionsData: [{
          code: "10PERCENTOFF",
          type: "standard",
          status: "active",
          is_automatic: false,
          application_method: {
            type: "percentage",
            target_type: "items",
            allocation: "across",
            value: 10,
            currency_code: "usd"
          }
        }]
      }
    });

    // Create a fixed amount discount promotion
    const { result: fixedPromotion } = await createPromotionsWorkflow(container).run({
      input: {
        promotionsData: [{
          code: "5DOLLAROFF",
          type: "standard",
          status: "active",
          is_automatic: false,
          application_method: {
            type: "fixed",
            target_type: "items",
            allocation: "across",
            value: 5,
            currency_code: "usd"
          }
        }]
      }
    });

    // Create a buy X get Y promotion
    const { result: buyGetPromotion } = await createPromotionsWorkflow(container).run({
      input: {
        promotionsData: [{
          code: "BUY2GET1",
          type: "buyget",
          status: "active",
          is_automatic: false,
          application_method: {
            type: "percentage",
            target_type: "items",
            allocation: "across",
            value: 100, // 100% off for the free item
            currency_code: "usd",
            buy_rules_min_quantity: 2,
            apply_to_quantity: 1
          }
        }]
      }
    });

    // Create a promotion with campaign
    const { result: campaignPromotion } = await createPromotionsWorkflow(container).run({
      input: {
        promotionsData: [{
          code: "SUMMER2023",
          type: "standard",
          status: "active",
          is_automatic: false,
          application_method: {
            type: "percentage",
            target_type: "items",
            allocation: "across",
            value: 15,
            currency_code: "usd"
          },
          campaign: {
            name: "Summer Sale 2023",
            campaign_identifier: "summer-2023",
            description: "Summer sale promotion with 15% off",
            starts_at: new Date(),
            ends_at: new Date(new Date().setMonth(new Date().getMonth() + 3)), // 3 months from now
            budget: {
              type: "usage",
              limit: 1000 // Can be used 1000 times
            }
          }
        }]
      }
    });

    logger.info(`Created standard promotion with code: ${standardPromotion[0].code}`);
    logger.info(`Created fixed amount promotion with code: ${fixedPromotion[0].code}`);
    logger.info(`Created buy X get Y promotion with code: ${buyGetPromotion[0].code}`);
    logger.info(`Created campaign promotion with code: ${campaignPromotion[0].code}`);
    
    logger.info("Promotions seeded successfully");
  } catch (error) {
    logger.error("Failed to seed promotions");
    logger.error(error);
  }
}
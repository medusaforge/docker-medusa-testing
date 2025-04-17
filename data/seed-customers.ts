import {
  createCustomerAccountWorkflow,
} from "@medusajs/medusa/core-flows";
import {ExecArgs} from "@medusajs/framework/types";
import {
  ContainerRegistrationKeys, Modules,
} from "@medusajs/framework/utils";

export default async function seedCustomers({container}: ExecArgs) {
  const logger = container.resolve(ContainerRegistrationKeys.LOGGER);

  logger.info("Seeding Customers...");
  const authService = container.resolve(Modules.AUTH);

  const {authIdentity} = await authService.register(
    "emailpass",
    {
      body: {
        email: "customer_1@hsalem.com",
        password: "password"
      }
    });

  if (authIdentity) {
    await createCustomerAccountWorkflow(container).run({
      input: {
        authIdentityId: authIdentity.id,
        customerData: {
          email: 'customer_1@hsalem.com',
          first_name: 'CustomerFirstName',
          last_name: 'CustomerLastName',
        }
      }
    });
    logger.info("Customer account created successfully");
    logger.info("Customer account email: customer_1@hsalem.com");
    logger.info("Customer account password: password");
  } else {
    logger.error("Failed to create customer account");
    logger.error("AuthIdentity is null");
  }
}


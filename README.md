# One2Launch

> [**One2Launch**](https://one2launch.site) is an open-source, headless e-commerce Platform-as-a-Service (PaaS) designed to simplify online store setup and management for non-technical users while providing flexibility for developers. Key features include:
>
> - **E-commerce App**: A Next.js admin panel for store management and customer-facing storefronts.
> - **Integrations**: Supports Stripe for payments, Pirate Ship for shipping, and Invoice Ninja for invoicing.
> - **Security Focused**: Dockerized microservices architecture with Traefik and Cloudflare Zero Trust for enhanced security.
> - **Hosting Options**: Available as a self-hosted solution with automated VPS provisioning or as a managed PaaS with automatic shop subdomain assignment.

## Table of Contents

- [Usage](#usage)
- [Requirements](#requirements)
- [Get Started](#get-started)
  - [Self-Hosted](#self-hosted)
  - [Managed PaaS](#managed-paas)
- [Development](#development)
  - [Installing Dependencies](#installing-dependencies)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Style Guide](#style-guide)

## Get Started
> Create your shop at [One2Launch](https://one2launch.site)

### Managed PaaS

For non-technical users, One2Launch offers a fully managed PaaS solution with:

- **Easy onboarding** – Sign up and launch a store with a few clicks.
- **Admin Dashboard** – Access your admin panel at `admin.one2launch.site`
- **Automatic shop subdomain assignment** – Your shop will automatically be assigned a subdomain, such as `yourstore.one2launch.site`
- **No server management required** – Updates and security patches are handled automatically.

### Self-Hosted
For users who want full control, One2Launch can be deployed on a VPS with automated provisioning. See [*Architecture Overview*](https://docs.google.com/document/d/e/2PACX-1vSSXXzCGYhqhM0c6ta24FsoQ8R8mi4wjSy6vUJOIKkyLU8XQu1JGSOMAROHxPkCXc7WWIGjdj6-He8s/pub) for technical details.

- **Pre-Requesites**
  - *Accounts*: [Hetzner Cloud](https://www.hetzner.com/cloud), [Cloudflare](https://www.cloudflare.com/), A registered [Domain](https://www.namecheap.com/support/knowledgebase/article.aspx/9607/2210/how-to-set-up-dns-records-for-your-domain-in-a-cloudflare-account/)
  - *CLI Tools*: [HashiCorp Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli), [cf-terraforming](https://github.com/cloudflare/cf-terraforming)
  - *Environment Variables*: Fill out the provided `env-template.env` and rename it to `.env`

- **In your terminal, run**:
  ```sh
  git clone https://github.com/one2launch/one2launch/provision.git
  sudo bash scripts/setup-vps.sh
  ```

## Development
Follow the steps below to get customize One2Launch with local development! Refer to our [Product Specification](https://docs.google.com/document/d/e/2PACX-1vSSXXzCGYhqhM0c6ta24FsoQ8R8mi4wjSy6vUJOIKkyLU8XQu1JGSOMAROHxPkCXc7WWIGjdj6-He8s/pub) and [Press Release](./PRODUCT_RELEASE.md) for more details about the project's features and goals.

### Requirements

- [pnpm](https://pnpm.io/) (v10.3+) – To develop app
- [Supabase](https://supabase.com/) – For database and authentication
- [Stripe](https://stripe.com/) – For payment processing
- [Clerk](https://clerk.dev/) – For user authentication
- [Cloudinary](https://cloudinary.com/) – For product images


### Usage
> Instructions for getting One2Launch up and running locally.
```sh
git clone https://github.com/One2Launch/one2launch.git
cd o2l
```
Create a `.env` file in the project root with the following variables:
```sh
# nextjs client-side vars
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=""
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/
NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME=""
NEXT_PUBLIC_SHOP_URL=""  # for customers: shop_url.one2launch.site

# nextjs server-side vars
CLERK_SECRET_KEY=""
CLOUDINARY_URL=""
STRIPE_API_KEY=""
STRIPE_WEBHOOK_SECRET=""
DATABASE_URL="postgresql://<db_username>:<db_password>@<aws_region>.pooler.supabase.com:6543/<db_name>?pgbouncer=true" # find at supabase dashboard -> connect -> ORMs (prisma)
DIRECT_URL="postgresql://<db_username>:<db_password>@<aws_region>.pooler.supabase.com:5432/postgres" # for db migrations only

```

### Installing Dependencies
From the root directory, install dependencies and set up the database:
```sh
pnpm i
pnpm build
pnpm dev
```
For easier development, see the available tasks in [`package.json`](./o2l/admin/package.json)

## Roadmap
Stay up-to-date with the latest features and improvements by following our [GitHub Project Board](https://github.com/orgs/One2Launch/projects/3).

## Contributing
We welcome contributions! Review our [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on how to get involved. You can help by reporting issues, suggesting features, submitting pull requests, or improving documentation.

Thank you for considering contributing to One2Launch! If you have any feedback, feel free to reach out at <dev@eileenrodriguez.com> or check out my other projects [here](https://eileenrodriguez.com).

## Style Guide
This project adheres to the [JavaScript Standard Style](https://standardjs.com/).
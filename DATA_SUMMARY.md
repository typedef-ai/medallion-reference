# Seed Data Summary

**Generated:** 2025-10-31
**Time Period:** January 2022 - October 2025 (Historical) + November 2025 - June 2026 (Pipeline)
**Total Rows:** 383,483

## Overview

This dataset represents 3 years and 10 months of historical operational data for CloudMetrics Inc., a SaaS analytics platform company, plus 8 months of forward-looking sales pipeline data.

## Data Files

### Dimension Tables

| File                  | Rows | Description                                                       |
| --------------------- | ---- | ----------------------------------------------------------------- |
| `sfdc_account.csv`    | 200  | Salesforce CRM accounts (customer master data)                    |
| `product_catalog.csv` | 20   | Product SKU reference data (platform licenses, add-ons, services) |
| `payment_methods.csv` | 172  | Customer payment methods (credit card, ACH, wire)                 |

### Transaction Tables

| File                           | Rows  | Description                                                  |
| ------------------------------ | ----- | ------------------------------------------------------------ |
| `sfdc_opportunity.csv`         | 670   | Sales opportunities (590 closed + 80 open pipeline)          |
| `sfdc_opportunitylineitem.csv` | 1,045 | Products/services sold per opportunity                       |
| `stripe_subscriptions.csv`     | 438   | Active and canceled subscriptions (337 active, 101 canceled) |
| `stripe_invoices.csv`          | 780   | Monthly/annual billing invoices (757 paid, 23 open)          |

### Event/Activity Tables

| File                       | Rows    | Description                   |
| -------------------------- | ------- | ----------------------------- |
| `product_usage_events.csv` | 356,239 | Daily product usage telemetry |
| `support_tickets.csv`      | 1,657   | Customer support interactions |
| `user_licenses.csv`        | 21,592  | Named user seat assignments   |

## Date Ranges

### Historical Data (Closed Business)

- **Start:** January 1, 2022
- **End:** October 31, 2025
- **Duration:** 46 months

**Closed Opportunities:** January 31, 2022 - October 24, 2025
**Usage Events:** Throughout subscription periods
**Support Tickets:** Throughout subscription periods
**Invoices:** Subscription start dates through October 2025

### Forward-Looking Data (Pipeline)

- **Start:** November 1, 2025
- **End:** June 30, 2026
- **Duration:** 8 months

**Open Opportunities:** Created from November 2025, expected close through June 2026

## Data Quality Characteristics

### Account Distribution

**By Tier:**

- **Tier 1 (Enterprise):** 23% of accounts, 45% of ARR
- **Tier 2 (Mid-Market):** 37% of accounts, 35% of ARR
- **Tier 3 (SMB):** 40% of accounts, 20% of ARR

**By Geography:**

- **North America:** 50%
- **Europe:** 35%
- **Asia Pacific:** 15%

### Sales Performance

**Closed Opportunities:**

- **Won:** 438 (74.2% win rate)
- **Lost:** 152 (25.8%)

**Opportunity Types:**

- **New Subscription:** Initial customer acquisitions
- **Renewal:** Annual contract renewals (~80% renewal rate)
- **Expansion:** Upsells and seat growth
- **Monthly Billing:** Month-to-month contracts (minority)

**Open Pipeline:**

- **80 opportunities** across stages: Qualification, Proposal/Price Quote, Negotiation/Review
- **Forecast categories:** Commit, Best Case, Pipeline, Omitted
- **Expected close dates:** November 2025 - June 2026

### Subscription Lifecycle

**Status:**

- **Active:** 337 subscriptions (77%)
- **Canceled:** 101 subscriptions (23%)

**Editions:**

- Starter, Starter Plus, Starter Premium
- Professional, Professional Plus, Professional Premium, Professional Elite
- Enterprise, Enterprise Plus, Enterprise Premium

**Churn Modeling:**

- 20-30% churn rate over period
- Higher churn in SMB tier, lower in Enterprise tier

### Usage Patterns

**Product Usage Events:** 356,239 events over 46 months

**Event frequency by tier:**

- **Enterprise (Tier 1):** 50-100 events/month, 50-200 users
- **Mid-Market (Tier 2):** 20-50 events/month, 25-50 users
- **SMB (Tier 3):** 5-20 events/month, 5-15 users

**Event Types:**

- login, dashboard_view, report_create, data_export, api_call, alert_trigger

**Features Used:**

- Analytics Dashboard, Custom Reports, Data Export, API Access
- Predictive Models, Advanced Analytics, User Management
- White Label Branding, Alerts & Notifications, Data Integration

### Support Patterns

**Support Tickets:** 1,657 tickets over 46 months

**Average tickets per year by tier:**

- **Enterprise:** 5-10 tickets/year
- **Mid-Market:** 3-5 tickets/year
- **SMB:** 1-3 tickets/year

**Priority Distribution:**

- Critical, High, Medium, Low (distribution varies by tier)

**Categories:**

- Technical, Bug Report, Feature Request, Account Management, Billing, Training

**Resolution Time:**

- **Critical:** 1-8 hours
- **High:** 4-24 hours
- **Medium:** 12-72 hours
- **Low:** 24-168 hours

**Satisfaction Scores:** 1-5 scale (higher scores for Enterprise tier)

### Payment Methods

**172 payment methods** across 200 accounts

**Types:**

- **Credit Card:** Primary for SMB/Mid-Market (60-90%)
- **ACH:** Common for Mid-Market/Enterprise (30-40%)
- **Wire Transfer:** Primarily Enterprise (30%)

**Status:**

- Active, Expired (credit cards past expiry date)
- 20% of accounts have multiple payment methods

## Data Generation Methodology

### Business Realism

The data incorporates realistic business patterns:

1. **Account Growth Curve:** S-curve growth from 75 accounts (2022) to 200 accounts (2025)
2. **Seasonality:** Q4 new business surge, Q1 renewal activity, summer slowdown
3. **Customer Lifecycle:** New customer → Expansions → Annual renewals → Potential churn
4. **Tiered Behaviors:** Enterprise, Mid-Market, and SMB segments have distinct usage, support, and expansion patterns

### Referential Integrity

All relationships validated:

- ✅ All opportunities reference valid accounts
- ✅ All line items reference valid opportunities and products
- ✅ All subscriptions link to won opportunities (with minor exceptions for data quality scenarios)
- ✅ All invoices reference valid subscriptions/customers
- ✅ All events, tickets, and licenses reference valid accounts/customers

### Intentional Data Quality Issues

The dataset includes realistic data quality scenarios (not implemented in v1, reserved for future enhancement):

- Late-arriving events (5-10%)
- Duplicate records (2-5%)
- Orphaned foreign keys (1-2%)
- Failed payments (2-5% of invoices)
- Inactive user licenses (20-30%)

## Regenerating Data

To regenerate the seed data with different parameters:

```bash
cd dbt_projects/medallion-reference
uv sync
uv run python scripts/generate_seeds.py
```

The generation script uses a fixed random seed (42) for reproducibility. To change the date ranges or account counts, modify the configuration in `scripts/generators/utils.py`:

- `START_DATE`: Historical data start date
- `END_DATE`: Historical data end date
- `PIPELINE_END_DATE`: Forward pipeline end date

Then adjust parameters in `scripts/generate_seeds.py`:

- `num_accounts` in `generate_accounts()`
- `start_accounts` and `end_accounts` in `generate_account_growth_curve()`

## Loading Data into dbt

```bash
cd dbt_projects/medallion-reference
export DBT_PROFILES_DIR=$(pwd)
dbt seed    # Load seed files into database
dbt run     # Build medallion models
```

## Data Lineage Integration

After loading, you can ingest this metadata into the lineage graph:

```bash
cd ../../
uv run lineage init
uv run lineage load-dbt-full dbt_projects/medallion-reference/target/ --verbose
```

This will:

1. Parse dbt manifest.json
2. Extract semantic metadata (measures, dimensions, grain) using LLM analysis
3. Load into KùzuDB property graph
4. Enable intelligent querying via the multi-agent system

## Notes

- **Invoice Count:** Lower than initially projected (~780 vs ~4,500 target). This is due to a simplified billing logic that generates fewer monthly invoices. The framework can be enhanced to generate more granular billing data if needed.

- **User Licenses:** High count (21,592) reflects realistic seat assignments across 438 subscriptions with varying user limits by edition.

- **Usage Events:** Very high count (356K+) represents daily telemetry data, creating realistic power law distribution (few high-usage accounts, many low-usage accounts).

## Schema Reference

For detailed schema information, see:

- `seeds/*.csv` - Actual data files with headers
- `models/` - dbt models that transform this seed data
- `../docs/SYNTHETIC_DATA_GENERATION_GUIDE.md` - Data generation methodology
- `COMPANY_PERSONA.md` - Business context and assumptions

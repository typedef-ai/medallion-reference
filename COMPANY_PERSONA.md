# CloudMetrics Inc. - Company Persona & Data Architecture

## Company Overview

**CloudMetrics Inc.** is a SaaS analytics platform company providing cloud-based data observability and analytics solutions to businesses worldwide.

### Key Facts

- **Industry**: SaaS Analytics Platform
- **Product**: Cloud-based data observability and analytics platform
- **Founded**: 2020
- **Headquarters**: San Francisco, CA
- **Employees**: 450
- **Annual Recurring Revenue (ARR)**: $42M
- **Customer Base**: 250+ customers across 30+ countries
- **Market Segments**: Enterprise (45% of ARR), Mid-Market (35% of ARR), SMB (20% of ARR)

## Product & Pricing

### Product Editions

| Edition             | Annual Price | Monthly Price | Users     | Data Limit | Key Features                       |
| ------------------- | ------------ | ------------- | --------- | ---------- | ---------------------------------- |
| **Starter**         | $1,200       | $120          | Up to 5   | 1GB        | Basic dashboards, email support    |
| **Professional**    | $6,000       | $600          | Up to 25  | 10GB       | Advanced analytics, chat support   |
| **Enterprise**      | $15,000      | $1,500        | Unlimited | 100GB      | Custom integrations, phone support |
| **Enterprise Plus** | $30,000+     | $3,000+       | Unlimited | Unlimited  | White-label, dedicated CSM, SLA    |

### Product Modules & Add-ons

- **Core Platform**: Data observability and monitoring
- **Advanced Analytics**: Predictive analytics and ML models
- **API Access**: Programmatic data access (Enterprise+)
- **White Label**: Custom branding (Enterprise Plus only)
- **Premium Support**: 24/7 support with 1-hour SLA
- **Professional Services**: Implementation and training

## Go-to-Market Strategy

### Sales Motion by Segment

**Enterprise (6-12 month sales cycle)**

- Sales-led with dedicated Account Executives
- Multi-stakeholder decision process
- Custom pricing and contracts
- POC/Trial period: 30-60 days
- Average deal size: $50,000 - $300,000 ARR

**Mid-Market (2-4 month sales cycle)**

- Inside sales with Solution Consultants
- Department-level decisions
- Standard pricing with volume discounts
- Trial period: 14-30 days
- Average deal size: $15,000 - $75,000 ARR

**SMB (30-60 day sales cycle)**

- Product-led growth (PLG) with self-service signup
- Individual or small team decisions
- Online pricing and checkout
- Trial period: 14 days
- Average deal size: $1,200 - $12,000 ARR

### Customer Success Strategy

- **Starter/Professional**: Digital customer success (email, knowledge base)
- **Enterprise**: Dedicated Customer Success Manager (CSM)
- **Enterprise Plus**: Named CSM + Technical Account Manager (TAM)

### Expansion Motion

- **Usage-based triggers**: Alert when approaching data limits
- **Feature adoption**: Upsell based on advanced feature usage
- **User growth**: Expand as teams grow
- **Multi-product**: Cross-sell additional modules

## Data Architecture

### Medallion Architecture Overview

```
Bronze (Raw)          Silver (Staging)              Gold (Intermediate)           Platinum (Marts)
════════════         ══════════════════            ═══════════════════           ════════════════
SFDC Data     ──────► stg_sfdc__*        ──────►  int_pipeline_*       ──────►  fct_pipeline
Stripe Data   ──────► stg_stripe__*      ──────►  int_arr_*            ──────►  fct_arr_reporting
Usage Events  ──────► stg_product__*     ──────►  int_usage_*          ──────►  fct_usage_monthly
Support Data  ──────► stg_support__*     ──────►  int_support_*        ──────►  fct_customer_health
User Data     ──────► stg_product__*     ──────►  int_health_*         ──────►  dim_account_enriched
```

### Data Sources (Bronze Layer)

#### Salesforce (CRM)

1. **`sfdc_account`** - Customer accounts
2. **`sfdc_opportunity`** - Sales opportunities
3. **`sfdc_opportunitylineitem`** - Opportunity line items (products sold)

#### Stripe (Billing)

4. **`stripe_subscriptions`** - Active and historical subscriptions
5. **`stripe_invoices`** - Billing and payment data
6. **`stripe_payment_methods`** - Payment method information

#### Product Platform (Internal Systems)

7. **`product_usage_events`** - Daily product usage telemetry
8. **`user_licenses`** - Named user seat assignments
9. **`product_catalog`** - Product SKU master data

#### Support System (Zendesk/Internal)

10. **`support_tickets`** - Customer support tickets

### Transformation Layers

#### Silver Layer (Staging Models)

- Data type casting and normalization
- Basic cleaning and validation
- Column renaming for consistency
- Deduplication
- **No business logic** - just standardization

#### Gold Layer (Intermediate Models)

- Business logic and calculations
- Aggregations (daily, monthly)
- Derived metrics
- Complex joins
- **Reusable components** for multiple marts

#### Platinum Layer (Marts)

- Business-facing fact and dimension tables
- Denormalized for query performance
- Semantic layer ready
- **Optimized for BI tools** and reporting

### Key Metrics & KPIs

#### Revenue Metrics (ARR Analysis)

- **New ARR**: First-time customer revenue
- **Expansion ARR**: Upsells and cross-sells from existing customers
- **Contraction ARR**: Downgrades and seat reductions
- **Churn ARR**: Lost revenue from cancellations
- **Net ARR**: Net change in ARR (New + Expansion - Contraction - Churn)

#### Customer Health Metrics

- **Health Score** (0-100): Composite score of usage, support, and payment
  - Usage Score (40%): DAU/MAU ratio, feature adoption
  - Support Score (30%): Ticket volume, satisfaction, resolution time
  - Payment Score (30%): Payment success rate, method age
- **Churn Risk**: Predicted likelihood of churn (Low/Medium/High)
- **Expansion Potential**: Likelihood of upsell/expansion

#### Product Metrics

- **Daily Active Users (DAU)**: Unique users per day
- **Monthly Active Users (MAU)**: Unique users per month
- **Feature Adoption**: Percentage of accounts using each feature
- **Data Processed**: GB of data processed per account
- **API Calls**: API usage per account
- **License Utilization**: Active users / total licenses purchased

#### Sales & Pipeline Metrics

- **Pipeline Coverage**: Open pipeline / quota
- **Win Rate**: Closed Won / (Closed Won + Closed Lost)
- **Average Sales Cycle**: Days from opportunity create to close
- **Average Deal Size**: Mean ARR per closed won deal
- **Forecast Accuracy**: Actual vs forecasted revenue

#### Support Metrics

- **Time to First Response (TTFR)**: Average time to first agent response
- **Average Resolution Time**: Mean time to close tickets
- **Customer Satisfaction (CSAT)**: Rating from post-ticket surveys
- **SLA Breach Rate**: Percentage of tickets exceeding SLA
- **Ticket Volume per Account**: Support intensity metric

### Customer Segmentation

#### By Tier

- **Tier 1**: Enterprise accounts (>$50K ARR)
- **Tier 2**: Mid-Market accounts ($10K-$50K ARR)
- **Tier 3**: SMB accounts (<$10K ARR)

#### By Geography

- **North America**: US, Canada, Mexico
- **Europe**: UK, Germany, France, Netherlands, Ireland, Switzerland
- **Asia Pacific**: Australia, Japan, Singapore, South Korea, India

#### By Industry Vertical

- Financial Services
- Healthcare & Life Sciences
- Technology & SaaS
- Retail & E-commerce
- Manufacturing
- Media & Entertainment
- Education
- Energy & Utilities

#### By Product Edition

- Starter (Entry level)
- Professional (Growing teams)
- Enterprise (Large organizations)
- Enterprise Plus (Strategic accounts)

## Data Quality & Testing Strategy

### Critical Data Tests

1. **Uniqueness**: Primary keys across all sources
2. **Referential Integrity**: Foreign key relationships
3. **Accepted Values**: Categorical columns (status, tier, geo)
4. **Not Null**: Required business fields
5. **Freshness**: Data recency checks
6. **Volume**: Row count anomaly detection

### Known Data Quality Issues (Intentional)

- **Late-arriving events**: Some usage events arrive days late
- **Duplicate tickets**: Support system occasionally creates duplicates
- **Inactive users**: Dormant user licenses not deprovisioned
- **Failed payments**: Retry logic creates multiple payment attempts
- **Missing tier data**: Some old accounts lack tier classification

## Business Rules & Logic

### ARR Calculation Rules

1. Annual contracts: Full contract value
2. Monthly contracts: MRR × 12
3. Multi-year contracts: Annual value (not total contract value)
4. Mid-year upgrades: Prorated based on remaining term

### Customer Health Scoring

```
health_score = (
  0.4 × usage_score +      # DAU/MAU ratio, feature adoption
  0.3 × support_score +    # Low ticket volume, high satisfaction
  0.3 × payment_score      # Payment success, method freshness
) × 100
```

### Churn Risk Classification

- **High Risk**: health_score < 50 OR no usage in 14 days OR 3+ critical tickets in 30 days
- **Medium Risk**: health_score 50-70 OR declining usage trend (>20% decline)
- **Low Risk**: health_score > 70 AND stable/growing usage

### Expansion Opportunity Signals

- License utilization > 80% (seat expansion)
- Data usage > 80% of limit (tier upgrade)
- Heavy usage of gated features (module upsell)
- High health score (>80) with stable usage (happy customer)

## Use Cases for Analytics

### Finance Team

- Monthly recurring revenue (MRR) and ARR tracking
- Revenue forecasting and variance analysis
- Cohort retention and LTV analysis
- Logo vs ARR churn analysis

### Sales Team

- Pipeline coverage and forecast accuracy
- Win/loss analysis by segment, competitor, deal size
- Sales rep performance and quota attainment
- Deal velocity and conversion rates

### Customer Success Team

- Customer health monitoring and churn prediction
- Expansion opportunity identification
- Feature adoption tracking
- Proactive outreach prioritization

### Product Team

- Feature usage and adoption metrics
- User engagement trends (DAU/MAU)
- Product-led growth conversion
- Performance and reliability monitoring

### Executive Team

- North star metrics dashboard (ARR, NRR, CAC, LTV)
- Board-level reporting
- Strategic account health
- Market segment performance

---

**Last Updated**: 2024-10-17
**Version**: 1.0
**Owner**: Data Engineering Team

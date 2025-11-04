
  create or replace   view DEMO_AGENTS_DAVID.intermediate.int_invoice_facts
  
  
  
  
  as (
    -- Stripe invoice aggregation
select
    invoice_id,
    customer_id,
    amount_due as invoice_amount_usd,
    invoice_date,
    last_day(invoice_date) as report_month,
    paid,
    status
from DEMO_AGENTS_DAVID.staging.stg_stripe__invoices
  );


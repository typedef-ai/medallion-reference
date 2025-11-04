
  create or replace   view DEMO_AGENTS_DAVID.staging.stg_stripe__invoices
  
  
  
  
  as (
    select
    cast(invoice_id as varchar) as invoice_id,
    cast(customer_id as varchar) as customer_id,
    cast(amount_due as decimal(15,2)) as amount_due,
    cast(currency as varchar) as currency,
    cast(created as date) as invoice_date,
    cast(paid as boolean) as paid,
    cast(status as varchar) as status
from DEMO_AGENTS_DAVID.staging.stripe_invoices
  );


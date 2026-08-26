select
    cast(invoice_id as string) as invoice_id,
    cast(customer_id as string) as customer_id,
    cast(amount_due as {% if target.type == 'bigquery' %}numeric{% else %}decimal(15,2){% endif %}) as amount_due,
    cast(currency as string) as currency,
    cast(created as date) as invoice_date,
    cast(paid as boolean) as paid,
    cast(status as string) as status
from {{ ref('stripe_invoices') }}

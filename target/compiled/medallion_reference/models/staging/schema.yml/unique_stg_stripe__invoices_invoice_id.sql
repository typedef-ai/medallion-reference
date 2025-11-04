
    
    

select
    invoice_id as unique_field,
    count(*) as n_records

from DEMO_AGENTS_DAVID.staging.stg_stripe__invoices
where invoice_id is not null
group by invoice_id
having count(*) > 1



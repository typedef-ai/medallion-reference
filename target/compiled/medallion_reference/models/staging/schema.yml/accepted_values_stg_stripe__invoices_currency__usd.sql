
    
    

with all_values as (

    select
        currency as value_field,
        count(*) as n_records

    from DEMO_AGENTS_DAVID.staging.stg_stripe__invoices
    group by currency

)

select *
from all_values
where value_field not in (
    'usd'
)



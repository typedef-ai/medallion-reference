
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from DEMO_AGENTS_DAVID.staging.stg_stripe__subscriptions
    group by status

)

select *
from all_values
where value_field not in (
    'active','canceled'
)



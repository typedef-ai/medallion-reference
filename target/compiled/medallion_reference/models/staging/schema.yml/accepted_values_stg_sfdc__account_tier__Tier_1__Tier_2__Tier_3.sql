
    
    

with all_values as (

    select
        tier as value_field,
        count(*) as n_records

    from DEMO_AGENTS_DAVID.staging.stg_sfdc__account
    group by tier

)

select *
from all_values
where value_field not in (
    'Tier 1','Tier 2','Tier 3'
)



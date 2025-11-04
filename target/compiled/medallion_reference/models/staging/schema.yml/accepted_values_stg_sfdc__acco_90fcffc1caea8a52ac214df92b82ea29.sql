
    
    

with all_values as (

    select
        geo as value_field,
        count(*) as n_records

    from DEMO_AGENTS_DAVID.staging.stg_sfdc__account
    group by geo

)

select *
from all_values
where value_field not in (
    'North America','Europe','Asia Pacific'
)



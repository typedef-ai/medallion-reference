
    
    

with all_values as (

    select
        company_type as value_field,
        count(*) as n_records

    from DEMO_AGENTS_DAVID.staging.stg_sfdc__account
    group by company_type

)

select *
from all_values
where value_field not in (
    'Enterprise','Mid-Market','SMB'
)




    
    

select
    account_id as unique_field,
    count(*) as n_records

from DEMO_AGENTS_DAVID.staging.stg_sfdc__account
where account_id is not null
group by account_id
having count(*) > 1



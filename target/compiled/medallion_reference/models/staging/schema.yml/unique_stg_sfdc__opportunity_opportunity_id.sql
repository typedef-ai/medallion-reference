
    
    

select
    opportunity_id as unique_field,
    count(*) as n_records

from DEMO_AGENTS_DAVID.staging.stg_sfdc__opportunity
where opportunity_id is not null
group by opportunity_id
having count(*) > 1



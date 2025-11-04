
    
    

select
    ticket_id as unique_field,
    count(*) as n_records

from DEMO_AGENTS_DAVID.staging.stg_support__tickets
where ticket_id is not null
group by ticket_id
having count(*) > 1



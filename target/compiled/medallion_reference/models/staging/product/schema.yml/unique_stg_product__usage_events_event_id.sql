
    
    

select
    event_id as unique_field,
    count(*) as n_records

from DEMO_AGENTS_DAVID.staging.stg_product__usage_events
where event_id is not null
group by event_id
having count(*) > 1



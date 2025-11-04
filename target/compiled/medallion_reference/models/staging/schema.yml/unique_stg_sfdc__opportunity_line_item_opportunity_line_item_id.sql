
    
    

select
    opportunity_line_item_id as unique_field,
    count(*) as n_records

from DEMO_AGENTS_DAVID.staging.stg_sfdc__opportunity_line_item
where opportunity_line_item_id is not null
group by opportunity_line_item_id
having count(*) > 1



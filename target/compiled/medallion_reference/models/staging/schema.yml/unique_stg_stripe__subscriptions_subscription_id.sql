
    
    

select
    subscription_id as unique_field,
    count(*) as n_records

from DEMO_AGENTS_DAVID.staging.stg_stripe__subscriptions
where subscription_id is not null
group by subscription_id
having count(*) > 1



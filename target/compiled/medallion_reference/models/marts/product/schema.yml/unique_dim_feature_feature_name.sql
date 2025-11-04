
    
    

select
    feature_name as unique_field,
    count(*) as n_records

from DEMO_AGENTS_DAVID.marts.dim_feature
where feature_name is not null
group by feature_name
having count(*) > 1



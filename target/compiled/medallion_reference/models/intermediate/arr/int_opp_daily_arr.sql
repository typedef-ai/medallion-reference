-- Aggregate daily ARR to opportunity level
select
    opportunity_id,
    day,
    sum(won_arr) as won_arr,
    sum(lost_arr) as lost_arr,
    sum(open_arr) as open_arr
from DEMO_AGENTS_DAVID.intermediate.int_oli_daily_arr
group by opportunity_id, day
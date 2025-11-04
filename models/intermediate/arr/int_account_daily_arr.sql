-- Aggregate won ARR to account level by day
select
    acc.account_id,
    acc.parent_account_id,
    opp_daily.day,
    sum(opp_daily.won_arr) as total_arr
from {{ ref('int_opp_daily_arr') }} opp_daily
join {{ ref('stg_sfdc__opportunity') }} opp
    on opp.opportunity_id = opp_daily.opportunity_id
join {{ ref('stg_sfdc__account') }} acc
    on acc.account_id = opp.account_id
group by acc.account_id, acc.parent_account_id, opp_daily.day

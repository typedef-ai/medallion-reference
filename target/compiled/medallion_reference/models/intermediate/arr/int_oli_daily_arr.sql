

-- Expand each OLI to daily grain with ARR classification
-- Core ARR calculation per the spec: 365 * total_price / contract_days

with oli_with_opp as (
    select
        oli.opportunity_line_item_id,
        oli.opportunity_id,
        oli.total_price,
        oli.start_date__c as start_date,
        oli.end_date__c as end_date,
        oli.product_family,
        opp.is_won,
        opp.is_closed,
        opp.type as opp_type
    from DEMO_AGENTS_DAVID.staging.stg_sfdc__opportunity_line_item oli
    join DEMO_AGENTS_DAVID.staging.stg_sfdc__opportunity opp
        on opp.opportunity_id = oli.opportunity_id
    -- Exclude monthly billing opportunities from ARR per spec
    where opp.type != 'Monthly Billing'
        and oli.product_family = 'License'  -- Only License products for ARR
),

expanded_daily as (
    select
        oli.opportunity_line_item_id,
        oli.opportunity_id,
        oli.total_price,
        oli.start_date,
        oli.end_date,
        oli.is_won,
        oli.is_closed,
        dates.date_day as day,
        -- ARR formula: annualize the contract value
        365.0 * oli.total_price / nullif(DATEDIFF(day, oli.start_date, oli.end_date) + 1, 0) as daily_arr
    from oli_with_opp oli
    join DEMO_AGENTS_DAVID.staging.util__dates dates
        on dates.date_day between oli.start_date and oli.end_date
)

select
    opportunity_line_item_id,
    opportunity_id,
    day,
    -- Classify ARR by opportunity status
    case when is_won then daily_arr else 0 end as won_arr,
    case when is_closed and not is_won then daily_arr else 0 end as lost_arr,
    case when not is_closed then daily_arr else 0 end as open_arr
from expanded_daily
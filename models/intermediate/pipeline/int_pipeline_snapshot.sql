-- Pipeline snapshot with ARR normalization
select
    opportunity_id,
    account_id,
    stage_name,
    forecast_category,
    created_date,
    close_date,
    type as deal_type,
    -- Calculate ARR from bookings amount
    -- If we have license dates, annualize; otherwise assume 12 month term
    case
        when license_start_date is not null and license_end_date is not null
        then
            case
                when DATEDIFF('month', license_start_date, license_end_date) = 0
                then amount
                else round(amount / nullif(DATEDIFF('month', license_start_date, license_end_date), 0) * 12, 2)
            end
        else amount  -- Assume already ARR
    end as arr,
    -- Probability weighted ARR
    case
        when license_start_date is not null and license_end_date is not null
        then
            case
                when DATEDIFF('month', license_start_date, license_end_date) = 0
                then amount * probability / 100.0
                else round(amount / nullif(DATEDIFF('month', license_start_date, license_end_date), 0) * 12 * probability / 100.0, 2)
            end
        else amount * probability / 100.0
    end as prob_weighted_arr,
    amount as bookings,
    DATE_TRUNC('month', close_date) as close_month
from {{ ref('stg_sfdc__opportunity') }}

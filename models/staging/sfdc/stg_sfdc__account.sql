select
    cast(account_id as string) as account_id,
    cast(parent_account_id as string) as parent_account_id,
    cast(account_name as string) as account_name,
    cast(geo as string) as geo,
    cast(company_type as string) as company_type,
    cast(tier as string) as tier,
    cast(billing_country as string) as billing_country
from {{ ref('sfdc_account') }}

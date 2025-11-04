{{
    config(
        materialized='table'
    )
}}

-- Account dimension table
select
    account_id,
    parent_account_id,
    account_name,
    geo,
    company_type,
    tier,
    billing_country
from {{ ref('stg_sfdc__account') }}

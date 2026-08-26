select
    cast(opportunity_line_item_id as string) as opportunity_line_item_id,
    cast(opportunity_id as string) as opportunity_id,
    cast(product_code as string) as product_code,
    cast(product_family as string) as product_family,
    cast(product_line_type as string) as product_line_type,
    cast(total_price as {% if target.type == 'bigquery' %}numeric{% else %}decimal(15,2){% endif %}) as total_price,
    cast(quantity as int) as quantity,
    cast(start_date__c as date) as start_date__c,
    cast(end_date__c as date) as end_date__c
from {{ ref('sfdc_opportunitylineitem') }}
-- Filter out invalid date ranges per spec
where cast(end_date__c as date) > cast(start_date__c as date)

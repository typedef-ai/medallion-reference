
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select invoice_id
from DEMO_AGENTS_DAVID.staging.stg_stripe__invoices
where invoice_id is null



  
  
      
    ) dbt_internal_test
-- Deduplicated customer master with data quality validation
{{ config(materialized='view') }}

select
    customer_id,
    customer_number,
    first_name,
    last_name,
    concat(first_name, ' ', last_name) as full_name,
    gender,
    date_of_birth,
    email,
    phone_number,
    street_address,
    city,
    state_province,
    postal_code,
    country_code,
    country_name,
    region,
    preferred_language,
    customer_segment,
    loyalty_tier,
    registration_date,
    is_active,
    source_system,
    record_source,
    case
        when customer_id is null then false
        when first_name is null or trim(first_name) = '' then false
        when last_name is null or trim(last_name) = '' then false
        when email is null then false
        when country_code is null then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from {{ source('bronze', 'CUSTOMER_MASTER') }}
qualify row_number() over (
    partition by customer_id
    order by __load_ts desc, __row_number desc
) = 1

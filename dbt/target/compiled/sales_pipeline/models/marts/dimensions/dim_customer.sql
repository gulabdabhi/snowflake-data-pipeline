-- DIM_CUSTOMER: Customer dimension with demographics and loyalty


select
    sha2(concat(
        coalesce(customer_id, ''),
        coalesce(to_varchar(__bronze_load_ts, 'YYYY-MM-DD HH24:MI:SS.FF6'), '')
    ), 256) as customer_dim_key,

    customer_id,
    customer_number,
    first_name,
    last_name,
    full_name,
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

    __bronze_load_ts as effective_start_ts,
    cast('9999-12-31 23:59:59' as timestamp_ntz) as effective_end_ts,
    true as is_current

from SALES_DEV.GOLD_SILVER.stg_customer_master
where is_valid_record = true
-- DIM_DATE: Calendar and fiscal date dimension
{{ config(materialized='table') }}

with date_spine as (
    select
        dateadd(day, seq4(), '2020-01-01')::date as date_key
    from table(generator(rowcount => 3653))
)

select
    sha2(to_varchar(date_key, 'YYYYMMDD'), 256) as date_dim_key,
    date_key,
    year(date_key) as year_number,
    quarter(date_key) as quarter_number,
    month(date_key) as month_number,
    weekofyear(date_key) as week_number,
    dayofyear(date_key) as day_of_year,
    day(date_key) as day_of_month,
    dayofweek(date_key) as day_of_week,
    to_varchar(date_key, 'YYYY') as year_name,
    'Q' || quarter(date_key) as quarter_name,
    monthname(date_key) as month_name,
    left(monthname(date_key), 3) as month_short_name,
    dayname(date_key) as day_name,
    to_varchar(date_key, 'YYYY-MM') as year_month,
    to_varchar(date_key, 'YYYY') || '-Q' || quarter(date_key) as year_quarter,
    case
        when month(date_key) >= 4 then year(date_key)
        else year(date_key) - 1
    end as fiscal_year,
    case
        when month(date_key) >= 4 then ceil((month(date_key) - 3) / 3.0)
        else ceil((month(date_key) + 9) / 3.0)
    end::int as fiscal_quarter,
    case when dayofweek(date_key) in (0, 6) then true else false end as is_weekend,
    false as is_holiday

from date_spine

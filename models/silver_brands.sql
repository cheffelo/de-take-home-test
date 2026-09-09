-- WORKED EXAMPLE. Delete it, keep it, or rename it. Your call.
--
-- It's here to show the mechanics: how to read a CSV, how to cast and rename
-- columns, and how a model becomes something the next model can select from.
-- It is not a suggestion about how many layers you should have. That's part of
-- what we're interested in seeing.

create or replace view silver_brands as

with source as (

    select * from read_csv('data/raw_brands.csv')

),

renamed as (

    select
        cast(brand_id as integer)      as brand_id,
        brand_name,
        country                        as country_code,
        currency                       as currency_code,
        cast(vat_rate as decimal(5,4)) as vat_rate

    from source

)

select * from renamed;

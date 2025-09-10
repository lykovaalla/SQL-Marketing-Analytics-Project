with combined_platforms as (
    select 
        ad_date,
        spend,
        impressions,
        clicks,
        value,
        'Facebook' as platform
    from 
        facebook_ads_basic_daily
    union all
    select
        ad_date,
        spend,
        impressions,
        clicks,
        value,
        'Google' as platform
    from
        google_ads_basic_daily
)

select
    platform,
    ad_date,
    avg(spend) as avg_spend,
    max(spend) as max_spend,
    min(spend) as min_spend,
    avg(impressions) as avg_imp,
    max(impressions) as max_imp,
    min(impressions) as min_imp,
    avg(clicks) as avg_clicks,
    max(clicks) as max_clicks,
    min(clicks) as min_clicks,
    avg(value) as avg_value,
    max(value) as max_value,
    min(value) as min_value
from
    combined_platforms
group by
    ad_date,
    platform
order by
    ad_date,
    platform;
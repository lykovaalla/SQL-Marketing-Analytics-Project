WITH all_ads_data AS (
    SELECT
        fbd.ad_date,
        fc.campaign_name,
        fa.adset_name,
        fbd.spend,
        fbd.impressions,
        fbd.clicks,
        fbd.reach,
        fbd.value,
        'Facebook' AS ad_source
    FROM
        facebook_ads_basic_daily AS fbd
    LEFT JOIN facebook_adset AS fa 
        ON fbd.adset_id = fa.adset_id
    LEFT JOIN facebook_campaign AS fc 
        ON fbd.campaign_id = fc.campaign_id
UNION ALL
SELECT
ad_date,
campaign_name,
adset_name,
spend,
impressions,
clicks,
reach,
value,
'Google' AS ad_source
FROM google_ads_basic_daily
)
SELECT
DATE_TRUNC('week', ad_date)::DATE AS week_start,
campaign_name,
SUM(COALESCE(value, 0)) AS weekly_value -- сума значення
FROM all_ads_data
GROUP BY 1, 2
HAVING SUM(COALESCE(value, 0)) > 0 -- фільтр за сумою
ORDER BY 3 DESC
LIMIT 1;

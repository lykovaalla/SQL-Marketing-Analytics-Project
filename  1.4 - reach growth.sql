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
),

montly_reach_camp AS (
SELECT
DATE_PART('year', ad_date) || '-' || DATE_PART('month', ad_date) AS ad_month,
campaign_name,
COALESCE(SUM(reach), 0) AS monthly_reach -- метрика reach
FROM all_ads_data
GROUP BY 1, 2
)
SELECT
    *,
    ABS(monthly_reach - COALESCE(LAG(monthly_reach) OVER (PARTITION BY campaign_name ORDER BY ad_month), 0)) AS montly_growth
FROM
    montly_reach_camp
ORDER BY
    montly_growth DESC
LIMIT 1;
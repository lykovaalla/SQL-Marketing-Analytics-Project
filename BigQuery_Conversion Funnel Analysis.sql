SELECT
  PARSE_DATE('%Y%m%d', _TABLE_SUFFIX) AS event_date,
  traffic_source.source,
  traffic_source.medium,
  traffic_source.name AS campaign,
  COUNT(DISTINCT CONCAT(user_pseudo_id, (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id'))) AS user_sessions_count,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart' THEN CONCAT(user_pseudo_id, (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')) ELSE NULL END),
    COUNT(DISTINCT CASE WHEN event_name = 'session_start' THEN CONCAT(user_pseudo_id, (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')) ELSE NULL END)
  ) AS visit_to_cart,


  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN event_name = 'begin_checkout' THEN CONCAT(user_pseudo_id, (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')) ELSE NULL END),
    COUNT(DISTINCT CASE WHEN event_name = 'session_start' THEN CONCAT(user_pseudo_id, (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')) ELSE NULL END)
  ) AS visit_to_checkout,
  
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN CONCAT(user_pseudo_id, (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')) ELSE NULL END),
    COUNT(DISTINCT CASE WHEN event_name = 'session_start' THEN CONCAT(user_pseudo_id, (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')) ELSE NULL END)
  ) AS visit_to_purchase

FROM
 
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE
 
  _TABLE_SUFFIX BETWEEN '20210101' AND '20211231'
 
  AND event_name IN ('session_start', 'add_to_cart', 'begin_checkout', 'purchase')
  
GROUP BY
  event_date,
  source,
  medium,
  campaign

ORDER BY
  event_date,
  source,
  medium,
  campaign;
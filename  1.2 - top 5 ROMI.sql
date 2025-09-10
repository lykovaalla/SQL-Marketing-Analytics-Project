with combined_table as
(
select
ad_date,
spend,
value

from facebook_ads_basic_daily

union all 

select
ad_date,
spend,
value

from google_ads_basic_daily
)

select 
ad_date,
case
	when sum(spend) > 0 then ((sum(value) - sum(spend)) * 1.0 / sum(spend)) * 100
        else 0
end as total_romi
from combined_table

group by ad_date
order by total_romi desc
limit 5


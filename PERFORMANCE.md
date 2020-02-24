
# PERFORMANCE IDEAS

[X] 1. VACCUM table dialer_campaign_rtinfo

[X] 2. ALTER TABLE dialer_campaign_rtinfo SET UNLOGGED;
    Check with:
    select relpersistence, relname from pg_class where relname like 'dialer_campaign_rtinfo%';

[ ] 5. Bulk queries?

[X] 6. Create frequency settings on freeswitch_realtime: heartbeat 2sec? Some might be unhappy with a delay though.

[ ] 7. bypass 1 on X (eg 1/5) writting to influxDB as this is not as necessary as data dialer_campaign_rtinfo

[ ] 8. Different architecture to avoid backpressure

[X] 9. Review DB performance / pgbench and pgtune

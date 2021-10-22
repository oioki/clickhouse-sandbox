CREATE TABLE clicktail.access_log
(
    `_time` DateTime CODEC(DoubleDelta, LZ4),
    `_date` Date DEFAULT toDate(_time),
    `_ms` UInt32,
    `body_bytes_sent` UInt32 CODEC(ZSTD(1)),
    `status` UInt32 CODEC(T64, ZSTD(1)),
    `upstream_bytes_received` UInt32 CODEC(ZSTD(1)),
    `upstream_response_length` UInt32 CODEC(ZSTD(1)),
    `request_length` UInt32 CODEC(ZSTD(1)),
    `project_id` UInt64,
    `request` String CODEC(LZ4HC(0)) TTL _date + toIntervalDay(90),
    `request_uri` String CODEC(LZ4) TTL _date + toIntervalDay(30),
    `request_uri_path` LowCardinality(String) MATERIALIZED path(request_uri),
    `request_time` Float32 CODEC(Gorilla, LZ4) TTL _date + toIntervalDay(1),
    `upstream_connect_time` Float32 CODEC(Gorilla, LZ4),
    `upstream_response_time` Float32 CODEC(LZ4) TTL _date + toIntervalDay(1),
    `upstream_response_time_ms` UInt32 MATERIALIZED CAST(round(upstream_response_time * 1000, 0), 'UInt32') CODEC(T64, LZ4),
    `request_id` FixedString(32) CODEC(LZ4) TTL _date + toIntervalDay(1),
    `http_referrer` String CODEC(LZ4HC(0)) TTL _date + toIntervalDay(30),
    `remote_user` LowCardinality(String),
    `host` LowCardinality(String) CODEC(ZSTD(1)),
    `http_host` LowCardinality(String),
    `http_user_agent` LowCardinality(String) CODEC(LZ4),
    `request_completion` LowCardinality(String),
    `request_method` LowCardinality(String),
    `ssl_protocol` LowCardinality(String),
    `ssl_cipher` LowCardinality(String) DEFAULT '',
    `ssl_server_name` LowCardinality(String) DEFAULT '',
    `statsd_path` LowCardinality(String),
    `remote_addr` IPv4 CODEC(ZSTD(1)),
    `request_time_ms` UInt32 MATERIALIZED CAST(round(request_time * 1000, 0), 'UInt32') CODEC(ZSTD(1)),
    `upstream_name` LowCardinality(String) DEFAULT CAST('', 'LowCardinality(String)'),
    INDEX minmax_status status TYPE minmax GRANULARITY 4,
    INDEX minmax_project_id project_id TYPE minmax GRANULARITY 4
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/clicktail/access_log', 'clickhouse-1')
PARTITION BY _date
ORDER BY (statsd_path, request_uri_path, _date, _time)
TTL _date + toIntervalDay(500)
SETTINGS index_granularity = 8192, min_bytes_for_wide_part = 1000000000;

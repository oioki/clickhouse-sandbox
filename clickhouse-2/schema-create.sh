#!/bin/bash

sed 's/clickhouse-1/clickhouse-2/' ../clickhouse-1/schema.table.sql > schema.table.sql

clickhouse-client --port 9002 < ../clickhouse-1/schema.db.sql
clickhouse-client --port 9002 < schema.table.sql

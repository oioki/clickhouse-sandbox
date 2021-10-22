#!/bin/bash

clickhouse-client --port 9001 < schema.db.sql
clickhouse-client --port 9001 < schema.table.sql

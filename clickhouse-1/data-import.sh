#!/bin/bash

clickhouse-client --port 9001 --query="INSERT INTO clicktail.access_log FORMAT Native" < data.native

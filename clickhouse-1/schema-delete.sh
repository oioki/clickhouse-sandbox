#!/bin/bash

clickhouse-client --port 9001 <<< "DROP TABLE clicktail.access_log"
clickhouse-client --port 9001 <<< "DROP DATABASE clicktail"

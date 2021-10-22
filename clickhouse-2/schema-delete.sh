#!/bin/bash

clickhouse-client --port 9002 <<< "DROP TABLE clicktail.access_log"
clickhouse-client --port 9002 <<< "DROP DATABASE clicktail"

#!/bin/sh
# Mostly just a sed example for grabbing IP addresses. This'll only work on "ffff:10.0.0.50" style addresses
cat $1 | sed -ne "s/.*\(ffff:[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/(\1)/p" | sort | uniq

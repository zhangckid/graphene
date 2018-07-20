#!/bin/bash

cd $(dirname ${BASH_SOURCE[0]})

JAVA_FLAGS="-Xmx64m -XX:ReservedCodeCacheSize=8m -XX:+UseSerialGC -XX:+DisableExplicitGC -XX:-UseCompressedClassPointers -XX:-UseCompressedOops"

set -x
exec ./java.manifest $JAVA_FLAGS "$@"

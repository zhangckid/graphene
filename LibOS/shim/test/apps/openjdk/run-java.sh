#!/bin/bash

cd $(dirname ${BASH_SOURCE[0]})

JAVA_FLAGS="-Xmx1024m -XX:ReservedCodeCacheSize=64m -XX:+UseBoundThreads -XX:+UseSerialGC -XX:+DisableExplicitGC -XX:-UseCompressedClassPointers -XX:-UseCompressedOops"

set -x
exec ./java.manifest $JAVA_FLAGS "$@"

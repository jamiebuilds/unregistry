#!/bin/sh
set -e

registries=$(cat ./registries.json)

echo "worker_processes 1;"
echo "";
echo "events {"
echo "  worker_connections 1024;"
echo "}"
echo ""
echo "http {"
echo "  sendfile on;"
echo ""
echo "  server {"
echo ""
echo "    # --- Generated from registries.json ---"
# Using `| .pattern + '%%%' + .registry` in order to avoid running jq inside the loop (much faster)
for item in $(echo $registries | jq -cr '.[] | .pattern + "%%%" + .registry'); do
  pattern=$(echo $item | awk -F "%%%" '{ print $1 }')
  registry=$(echo $item | awk -F "%%%" '{ print $2 }')
  echo ""
  echo "    location ~ $pattern {"
  echo "      proxy_pass $registry;"
  echo "    }"
done
echo ""
echo "    # ^^^ Generated from registries.json ^^^"
echo ""
echo "  }"
echo "}"

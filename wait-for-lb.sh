#!/bin/bash

# Script to wait for LoadBalancer to get an external IP
WAIT_SECONDS=0
MAX_WAIT_SECONDS=300
echo "Waiting for LoadBalancer to get external IP (timeout: ${MAX_WAIT_SECONDS}s)..."

while [ $WAIT_SECONDS -lt $MAX_WAIT_SECONDS ]; do
  EXTERNAL_IP=$(kubectl get svc webserver-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  if [ -n "$EXTERNAL_IP" ]; then
    echo "✅ Application is available at: http://$EXTERNAL_IP"
    echo "{\"loadBalancerUrl\":\"http://$EXTERNAL_IP\"}" > loadbalancer-url.json
    exit 0
  fi
  echo "⏳ Still waiting for external IP... (${WAIT_SECONDS}/${MAX_WAIT_SECONDS}s)"
  sleep 10
  WAIT_SECONDS=$((WAIT_SECONDS + 10))
done

if [ -z "$EXTERNAL_IP" ]; then
  echo "❌ Timed out waiting for LoadBalancer external IP"
  exit 1
fi
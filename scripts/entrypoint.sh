#!/bin/sh

# Load discovery payload from mounted file
if [ ! -f /config/discovery.json ]; then
    echo "Error: discovery.json not found in /config"
    exit 1
fi
DISCOVERY_PAYLOAD=$(cat /config/discovery.json)

# Required environment variables check
required_vars="DISCOVERY_TOPIC SHELL_COMMAND STATUS_TOPIC MQTT_HOST MQTT_PORT MQTT_USERNAME MQTT_PASSWORD"
for var in $required_vars; do
    if [ -z "$(eval echo \$$var)" ]; then
        echo "Error: $var environment variable is required"
        exit 1
    fi
done

# Publish discovery payload
mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -t "$DISCOVERY_TOPIC" -m "$DISCOVERY_PAYLOAD"

# Function to fetch and publish status data
publish_status_data() {
    response=$(eval "$SHELL_COMMAND") || {
        echo "Error executing shell command"
        return 1
    }
    
    mosquitto_pub -h "$MQTT_HOST" -p "$MQTT_PORT" -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -t "$STATUS_TOPIC" -m "$response" || {
        echo "Error publishing to MQTT"
        return 1
    }

    echo "Last update on $(date -R)"
}

# Main loop
while true; do
    publish_status_data
    sleep 60
done
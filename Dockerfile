# docker-compose.yml
version: '3.8'
services:
  mqtt-publisher:
    build: .
    volumes:
      - ./config:/config
    environment:
      - DISCOVERY_TOPIC=homeassistant/sensor/my_device/temperature/config
      - CURL_COMMAND=curl -s http://api.example.com
      - STATUS_TOPIC=homeassistant/sensor/my_device/temperature/state
      - MQTT_HOST=localhost
      - MQTT_PORT=1883
      - MQTT_USERNAME=user
      - MQTT_PASSWORD=pass
    restart: unless-stopped

---
# README.md
# MQTT Home Assistant Publisher

A Docker container that publishes sensor data to Home Assistant via MQTT. It supports automatic discovery and periodic status updates from an HTTP endpoint.

## Features

- Home Assistant MQTT auto-discovery
- Periodic data fetching from HTTP endpoints
- Configurable update interval
- Secure MQTT authentication
- Docker and Docker Compose support

## Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── scripts
│   └── entrypoint.sh
└── config
    └── discovery.json
```

## Configuration

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| DISCOVERY_TOPIC | MQTT topic for HA discovery | homeassistant/sensor/my_device/temperature/config |
| CURL_COMMAND | Command to fetch sensor data | curl -s http://api.example.com |
| STATUS_TOPIC | MQTT topic for status updates | homeassistant/sensor/my_device/temperature/state |
| MQTT_HOST | MQTT broker hostname | localhost |
| MQTT_PORT | MQTT broker port | 1883 |
| MQTT_USERNAME | MQTT username | user |
| MQTT_PASSWORD | MQTT password | pass |

### Discovery Configuration

Create a `config/discovery.json` file with your Home Assistant MQTT discovery configuration:

```json
{
  "name": "Temperature Sensor",
  "state_topic": "homeassistant/sensor/my_device/temperature/state",
  "unique_id": "temp_sensor_1",
  "device": {
    "identifiers": ["my_device"],
    "name": "My Device",
    "model": "Custom Sensor",
    "manufacturer": "Home Lab"
  }
}
```

## Usage

1. Clone this repository:
```bash
git clone https://github.com/yourusername/mqtt-ha-publisher.git
cd mqtt-ha-publisher
```

2. Create your discovery configuration:
```bash
mkdir -p config
# Create and edit config/discovery.json with your configuration
```

3. Edit the environment variables in `docker-compose.yml` to match your setup.

4. Start the container:
```bash
docker-compose up -d
```

## Development

To build the container manually:
```bash
docker build -t mqtt-publisher .
```

To run without Docker Compose:
```bash
docker run -d \
  -v $(pwd)/config:/config \
  -e DISCOVERY_TOPIC="homeassistant/sensor/my_device/temperature/config" \
  -e CURL_COMMAND="curl -s http://api.example.com" \
  -e STATUS_TOPIC="homeassistant/sensor/my_device/temperature/state" \
  -e MQTT_HOST="localhost" \
  -e MQTT_PORT="1883" \
  -e MQTT_USERNAME="user" \
  -e MQTT_PASSWORD="pass" \
  mqtt-publisher
```

## Troubleshooting

Common issues:

1. **Discovery payload not found**: Ensure `discovery.json` exists in the `config` directory
2. **MQTT connection failed**: Verify MQTT credentials and host/port
3. **Curl command failed**: Check if the endpoint is accessible from the container

Check container logs for detailed error messages:
```bash
docker-compose logs mqtt-publisher
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

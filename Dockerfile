FROM alpine:3.19

# Install required packages
RUN apk add --no-cache mosquitto-clients curl bash

# Copy entrypoint script
COPY scripts/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Create config directory
RUN mkdir /config

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

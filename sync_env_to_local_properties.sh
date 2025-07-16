#!/bin/bash
# Syncs GOOGLE_MAPS_API_KEY from .env to android/local.properties

ENV_FILE=".env"
LOCAL_PROPERTIES="android/local.properties"

if grep -q "^GOOGLE_MAPS_API_KEY=" "$ENV_FILE"; then
    # Remove any existing key in local.properties
    sed -i '/^GOOGLE_MAPS_API_KEY=/d' "$LOCAL_PROPERTIES"
    # Append the key from .env
    grep "^GOOGLE_MAPS_API_KEY=" "$ENV_FILE" >> "$LOCAL_PROPERTIES"
    echo "GOOGLE_MAPS_API_KEY synced to android/local.properties."
else
    echo "GOOGLE_MAPS_API_KEY not found in .env"
fi

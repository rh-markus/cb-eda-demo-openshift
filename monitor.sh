#!/bin/bash

# Your OpenShift Route
TARGET_URL="https://nginx-demo-route-eda-demo.apps.cluster-mztzr.mztzr.sandbox2747.opentlc.com"

# Hide the cursor for a cleaner look
tput civis

# Trap Ctrl+C to restore the cursor before exiting
trap 'tput cnorm; echo -e "\nExiting monitor..."; exit 0' SIGINT

while true; do
    clear
    # The Branded Header
    echo "=========================================================="
    echo "            CRIMSON BIOLOGICS SERVICE MONITOR             "
    echo "=========================================================="
    echo " Target: $TARGET_URL"
    echo "=========================================================="
    echo ""

    # Use curl to silently fetch the page content (-s for silent)
    CONTENT=$(curl -s "$TARGET_URL")

    # Check if the OpenShift HAProxy error page is returned (503)
    if [[ "$CONTENT" == *"Application is not available"* ]]; then
        # Crimson Red Status Block
        echo -e "\033[41m\033[97m                                                          \033[0m"
        echo -e "\033[41m\033[97m  [ OFFLINE ] CRITICAL ROUTE FAILURE                      \033[0m"
        echo -e "\033[41m\033[97m              Awaiting EDA Remediation...                 \033[0m"
        echo -e "\033[41m\033[97m                                                          \033[0m"
    
    # Check if it's completely empty (total network drop/timeout)
    elif [[ -z "$CONTENT" ]]; then
        # Warning Yellow Status Block
        echo -e "\033[43m\033[30m                                                          \033[0m"
        echo -e "\033[43m\033[30m  [ ERROR ] CONNECTION DROPPED                            \033[0m"
        echo -e "\033[43m\033[30m            Target server is completely unreachable.      \033[0m"
        echo -e "\033[43m\033[30m                                                          \033[0m"
    
    # Otherwise, Nginx is responding with your content
    else
        # Bio-Green Status Block
        echo -e "\033[42m\033[97m                                                          \033[0m"
        echo -e "\033[42m\033[97m  [ ONLINE ] SYSTEM OPERATING NORMALLY                    \033[0m"
        echo -e "\033[42m\033[97m             All services routing successfully.           \033[0m"
        echo -e "\033[42m\033[97m                                                          \033[0m"
    fi

    echo ""
    echo " Last checked: $(date +"%T")"
    echo " Polling every 2 seconds... (Press Ctrl+C to quit)"
    
    sleep 2
done

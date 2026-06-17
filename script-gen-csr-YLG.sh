#!/bin/bash

# 1. URL List
DOMAINS=(
    "www.ylggoldsaving.com"
    "www.ylggetgold.com"
    "demo.ylggoldsaving.com"
    "www.ylgonline.com"
)

# 2. Organization Information
O="Y L G BULLION INTERNATIONAL CO., LTD"
L="Sathon"
ST="Bangkok"
C="TH"

echo "=== Please Select a URL to Generate CSR ==="
for i in "${!DOMAINS[@]}"; do
    echo "$((i+1)). ${DOMAINS[$i]}"
done
echo "$(( ${#DOMAINS[@]} + 1 )). Generate for ALL URLs"
echo "----------------------------------------"
read -p "Enter your choice (1-$(( ${#DOMAINS[@]} + 1 ))): " CHOICE

# Function to generate CSR and Private Key
create_csr() {
    local domain=$1
    # Replace dots (.) with underscores (_) for filenames (e.g., www_ylgonline_com)
    local filename=$(echo "$domain" | sed 's/\./_/g')
    
    local key_file="/tmp/${filename}.key"
    local csr_file="/tmp/${filename}.csr"
    local subj="/C=$C/ST=$ST/L=$L/O=$O/CN=$domain"

    # Run OpenSSL command
    openssl req -new -newkey rsa:4096 -nodes -keyout "$key_file" -out "$csr_file" -subj "$subj" &> /dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully generated for: $domain"
        echo "   -> Key: $key_file"
        echo "   -> CSR: $csr_file"
    else
        echo "❌ Error generating CSR for: $domain"
    fi
}

# Process the user selection
if [[ "$CHOICE" -ge 1 && "$CHOICE" -le "${#DOMAINS[@]}" ]]; then
    # Generate for a specific URL
    SELECTED_DOMAIN="${DOMAINS[$((CHOICE-1))]}"
    echo "Generating CSR for $SELECTED_DOMAIN..."
    create_csr "$SELECTED_DOMAIN"
elif [[ "$CHOICE" -eq "$(( ${#DOMAINS[@]} + 1 ))" ]]; then
    # Generate for all URLs
    echo "Generating CSR for ALL URLs..."
    for domain in "${DOMAINS[@]}"; do
        create_csr "$domain"
    done
else
    echo "❌ Invalid selection. Operation cancelled."
fi

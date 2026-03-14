#!/usr/bin/env bash
set -euo pipefail

# Host Vector a resoudre (modifiable facilement)
VECTOR="vector.local"

ENV_VAR_NAME="VECTOR_IP"
BOTSDK_JSON="/data/chipper/jdocs/botSdkInfo.json"
BACKUP_JSON="${BOTSDK_JSON}.bak"
PROFILE_FILE="/etc/profile.d/vector_ip_env.sh"

is_ipv4() {
    local value="$1"
    [[ "$value" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]
}

resolve_host_ipv4() {
    local host="$1"
    local ip=""

    if command -v getent >/dev/null 2>&1; then
        ip=$(getent ahostsv4 "$host" 2>/dev/null | awk 'NR==1 {print $1}' || true)
        if is_ipv4 "$ip"; then
            echo "$ip"
            return 0
        fi
    fi

    if command -v avahi-resolve-host-name >/dev/null 2>&1; then
        ip=$(avahi-resolve-host-name "$host" 2>/dev/null | awk '{print $2}' | head -n 1 || true)
        if is_ipv4 "$ip"; then
            echo "$ip"
            return 0
        fi
    fi

    if command -v nslookup >/dev/null 2>&1; then
        ip=$(nslookup "$host" 2>/dev/null | awk '/^Address[[:space:]]*[: ]/{print $NF}' | grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$' | head -n 1 || true)
        if is_ipv4 "$ip"; then
            echo "$ip"
            return 0
        fi
    fi

    if command -v ping >/dev/null 2>&1; then
        ip=$(ping -c 1 "$host" 2>/dev/null | sed -nE 's/.*\((([0-9]{1,3}\.){3}[0-9]{1,3})\).*/\1/p' | head -n 1 || true)
        if is_ipv4 "$ip"; then
            echo "$ip"
            return 0
        fi
    fi

    return 1
}

replace_json_ip() {
    local ip="$1"
    local file="$2"
    local tmp_file="${file}.tmp"

    if ! grep -q '"ip_address"[[:space:]]*:' "$file"; then
        echo "Erreur : clé \"ip_address\" introuvable dans $file" >&2
        return 1
    fi

    sed -E "s/(\"ip_address\"[[:space:]]*:[[:space:]]*\")[^\"]*(\")/\1${ip}\2/" "$file" >"$tmp_file"
    mv "$tmp_file" "$file"
}

if ! IP=$(resolve_host_ipv4 "$VECTOR"); then
    echo "Erreur : impossible de resoudre l'IPv4 pour l'hote $VECTOR" >&2
    exit 1
fi

export "${ENV_VAR_NAME}=${IP}"

if [[ -d "$(dirname "$PROFILE_FILE")" ]]; then
    printf 'export %s="%s"\n' "$ENV_VAR_NAME" "$IP" >"$PROFILE_FILE" || true
    chmod 0644 "$PROFILE_FILE" 2>/dev/null || true
fi

if [[ ! -f "$BOTSDK_JSON" ]]; then
    echo "Erreur : fichier introuvable $BOTSDK_JSON" >&2
    exit 1
fi

cp "$BOTSDK_JSON" "$BACKUP_JSON"
replace_json_ip "$IP" "$BOTSDK_JSON"

echo "$VECTOR IPv4 address: $IP"
echo "Environment variable exported : $ENV_VAR_NAME"
echo "Backup file : $BACKUP_JSON"
echo "botSdkInfo.json updated"

exit 0

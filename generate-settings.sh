#!/usr/bin/env bash

set -euo pipefail

input_file="${1:-palworld.conf}"

settings=()

while IFS= read -r line || [[ -n "$line" ]]; do
    # 前後の空白を削除
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"

    # 空行とコメント行を無視
    [[ -z "$line" ]] && continue
    [[ "$line" == \#* ]] && continue
    [[ "$line" == \;* ]] && continue

    # KEY=VALUE 形式のみ許可
    if [[ "$line" != *=* ]]; then
        echo "Invalid configuration line: $line" >&2
        exit 1
    fi

    settings+=("$line")
done < "$input_file"

option_settings="$(IFS=,; printf '%s' "${settings[*]}")"

cat <<EOF
[/Script/Pal.PalGameWorldSettings]
OptionSettings=($option_settings)
EOF

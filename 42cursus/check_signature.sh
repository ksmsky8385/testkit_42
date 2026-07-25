#!/usr/bin/env bash

set -u

VM_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

VDI="$VM_DIR/Debian13.5.0.vdi"
SIGNATURE="$VM_DIR/signature.txt"

if [[ ! -f "$VDI" ]]; then
    echo "VDI 파일을 찾을 수 없습니다: $VDI"
    exit 1
fi

if [[ ! -f "$SIGNATURE" ]]; then
    echo "시그니처 파일을 찾을 수 없습니다: $SIGNATURE"
    exit 1
fi

submitted_hash=$(awk 'NR == 1 { print $1 }' "$SIGNATURE")
current_hash=$(sha1sum "$VDI" | awk '{ print $1 }')

echo "signature.txt : $submitted_hash"
echo "현재 VDI       : $current_hash"

if [[ "$submitted_hash" == "$current_hash" ]]; then
    echo "결과: 일치"
    exit 0
else
    echo "결과: 불일치"
    exit 1
fi

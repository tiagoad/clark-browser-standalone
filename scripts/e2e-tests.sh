#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

SCRIPT="../clark-standalone"
OUTPUT=".output"
rm -rf "$OUTPUT"
mkdir "$OUTPUT"

N_PASS=0
N_FAIL=0

header() {
    local line width=${#1} bar
    local -a lines=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        lines+=("$line")
        width=$(( ${#line} > width ? ${#line} : width ))
    done
    printf -v bar '%*s' "$width" ''
    bar="+-${bar// /-}-+"
    printf '%s\n' "$bar"
    if (( $# )); then
        printf '| %-*s |\n%s\n' "$width" "$1" "$bar"
    fi
    for line in "${lines[@]}"; do printf '| %-*s |\n' "$width" "$line"; done
    printf '%s\n' "$bar"
}

expect() {
	local what="$1"
	local args=("${@:2}")
	local cmd=("$SCRIPT" "${args[@]}")

	printf "Command: %s\nExpect: %s" "${args[*]}" "$what" |
		header "Running test"

	local exit_code=0
	"${cmd[@]}" || exit_code=$?

	local result="pass"
	if [[ 
		($what == ok && $exit_code != 0) 
		|| ($what == fail && $exit_code == 0) 
	]]
		then result="fail"
	fi

	if [[ $result == "pass" ]]
		then N_PASS=$(( N_PASS + 1))
		else N_FAIL=$(( N_FAIL + 1))
	fi

	printf "Result: %s\nExit code: %s" $exit_code $result | 
		header "Finished test"
	echo
}

expect ok   versions
expect ok versions --some-arg
expect fail versions some-arg
expect fail versions --some-arg some-arg
expect ok   download "$OUTPUT/default"
expect fail download "$OUTPUT/default" some-arg
expect ok   download --version chromium-v148.0.7778.96-stealth5 "$OUTPUT/default-fixed"
expect ok   download --platform darwin --arch arm64 "$OUTPUT/darwin-arm64"
expect ok   download --platform linux --arch x64 "$OUTPUT/linux-x64"
expect ok   download --platform windows --arch x64 "$OUTPUT/windows-arm64"

echo
printf "Successful: %s\nFailed: %s" "$N_PASS" "$N_FAIL" |
	header "Final results"

rm -rf "$OUTPUT"
if [[ $N_FAIL -gt 0 ]]
then
	exit 1
fi

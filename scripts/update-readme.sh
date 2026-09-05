#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

OUTPUT="../README.md"

main() {
	# run --help
	usage="$(../clark-standalone --help 2>&1)"
	usage=$'```\n'"$usage"$'\n```'
	
	# fetch README
	contents=$(cat "$OUTPUT")
	
	# update blocks
	contents="$(replace_block "usage" "$contents" "$usage")"
	
	# write README
	echo "$contents" > "$OUTPUT"
}

replace_block() {
	local name="$1"
	local contents="$2"
	local text="$3"

	start="<!-- start $name -->"
	end="<!-- end $name -->"

	if [[ "$contents" != *"$start"*"$end"* ]]; then
			echo "Block '$name' not found" >&2
			exit 1
	fi

	before=${contents%%"$start"*}
	after=${contents#*"$start"}
	after=${after#*"$end"}

	printf '%s%s\n%s\n%s%s' \
			"$before" "$start" "$text" "$end" "$after"
}

main

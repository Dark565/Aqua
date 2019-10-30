#!/bin/bash

# This script 'touch'es a syscall doc file with specific header

# Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

SCRIPT_DIR="$(dirname "$0")"
SCRIPT_NAME="$(basename "$0")"

LICENSE_FIRST_LINE="$(head -n1 <"$SCRIPT_DIR/../LICENSE")"

die() {
	echo "$SCRIPT_NAME: $@" >&2
	exit 1
}

[[ "$#" == 0 ]] && die "Enter at least one syscall"

while [[ -n $1 ]]; do

	CALL_NAME="$1"
	UPPER_CALL_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${CALL_NAME})"
	CALL_REFERENCE="${UPPER_CALL_NAME}(2)"
	CALL_FILENAME="${CALL_NAME}.md"

	echo \
"## ${CALL_REFERENCE}

## NAME


## SYNOPSIS


## DESCRIPTION


## NOTE


## RETURN VALUE


## EXAMPLE


### ${LICENSE_FIRST_LINE}" >"${CALL_FILENAME}"

	shift 1
done

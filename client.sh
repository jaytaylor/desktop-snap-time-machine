#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# trappend is like trap, with the addition  that if there is an existing trap
# already set, it will append the new command(s) without clobbering the
# pre-existing trap orders.
#
# n.b. Won't work for RETURN (hopefully this is somewhat obvious ;).
#
# usage: trappend cmds.. SIGNAL
trappend() {
    local sig
    local existing

    # n.b. Reverse-shift operation.
    sig="${*:$#}"
    set -- "${@:1:$(($#-1))}"

    if [ "${sig}" = 'RETURN' ] ; then
        echo 'ERROR: trappend: SIGNAL value cannot be "RETURN"' 1>&2
        return 1
    fi

    if [ -n "$(trap -p "${sig}")" ] ; then
        existing="$(trap -p "${sig}" | sed "s/^trap -- '\(.*\)' ${sig}\$/\1/");"
    fi

    # shellcheck disable=SC2064
    trap "${existing:-}$*" "${sig}"
}

die() {
    echo "ERROR: $*" 1>&2
    exit 1
}

main() {
    cfg

    case "$(uname)" in
    Darwin)
        doDarwin
        ;;
    Linux)
        echo 'ERROR: Linux is not yet supported' 1>&2
        exit 1
        ;;
    *)
        echo "ERROR: Unsupported platform: $(uname)" 1>&2
        exit 1
    esac
}

cfg() {
    if [ -z "${DESKTOP_SNAP_SSH_TARGET:-}" ] || [ -z "${DESKTOP_SNAP_RSYNC_PATH}" ] ; then
        if ! [ -r "${HOME}/.config/desktop-snap-time-machine/vars.sh" ] ; then
            die 'missing vars.sh, follow installation instructions in README.md'
        fi
        # shellcheck disable=SC1090
        source "${HOME}/.config/desktop-snap-time-machine/vars.sh"
    fi
    if [ -z "${DESKTOP_SNAP_SSH_TARGET:-}" ] || [ -z "${DESKTOP_SNAP_RSYNC_PATH}" ] ; then
        die 'missing required environment variables, follow installation instructions in README.md'
    fi
}

doDarwin() {
    local idle
    local f

    # Check idle seconds
    idle="$(/usr/sbin/ioreg -c IOHIDSystem | /usr/bin/awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')"

    if [ "${idle}" -gt "${DESKTOP_SNAP_MAX_IDLE_SECONDS:-3500}" ] ; then
        return 0
    fi

    f="$(hostname)_$(date +%Y%m%d%H%M%S%z).png"

    screencapture \
        -t png\
        -x \
        "/tmp/${f}"

    trappend EXIT
    
    rsync -ave ssh "/tmp/${f}" "${DESKTOP_SNAP_SSH_TARGET}:${DESKTOP_SNAP_RSYNC_PATH}/"
}

if [ "${BASH_SOURCE[0]}" = "${0}" ] ; then
    if [ "${1:-}" = '-v' ] ; then
        echo 'DEBUG: verbose mode enabled' 1>&2
        trappend 'set +o xtrace' EXIT
        set -o xtrace
        shift
    fi

    main "$@"
fi


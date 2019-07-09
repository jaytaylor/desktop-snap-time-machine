
# Remote SSH user@host.
export DESKTOP_SNAP_SSH_TARGET='you@example.com'

# Remote base path.
export DESKTOP_SNAP_RSYNC_PATH='/var/lib/desktop-snap-time-machine'

# Optional max idle time before snapshots stop uploading.
# n.b. this should be less than the cron job interval.
#
# default: 3500
#export DESKTOP_SNAP_MAX_IDLE_SECONDS=3500


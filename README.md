# desktop-snap-time-machine

Track how your desktop environment and habits change over time!

This is a personal archival system.

## How it works

Runs every 4 hours and if the system is in use, takes a screenshot and uploads it.

## Installation

Requires a macOS desktop machine and a *nix rsync target.

```bash
mkdir -p ~/.config/desktop-snap-time-machine
cp example-config.sh ~/.config/desktop-snap-time-machine/vars.sh
# Now edit ~/.config/desktop-snap-time-machine/vars.sh
```

Install cron job:

```bash

```

## TODO

- [ ] Finish installation instructions.
- [ ] Add setting for max # of snaps per day.
- [ ] Interface or program to review and delete "sensitive" snaps (e.g. ones with confidential info).

## Inspiration

I created this after coming across some old pictures of what my desktop looked like 11 years ago in 2008, and was amazed by how much has changed since then!

My OS, activities, programming environment, frequented websites, and habits in general have all changed significantly.

It seemed like it'd be cool to keep track of these things in an organized way.


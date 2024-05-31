#!/bin/bash -ue

# The udev rule is not terribly accurate and may trigger our service before
# the kernel has finished probing partitions. Sleep for a bit to ensure
# the kernel is done.
#
# This can be avoided by using a more precise udev rule, e.g. matching
# a specific hardware path and partition.
sleep 5

#
# Script configuration
#

# The backup partition is mounted there
MOUNTPOINT=/mnt/backup

# This is the location of the Borg repository
TARGET=$MOUNTPOINT/borg-backups/backup.borg

# Archive name schema
DATE=$(date --iso-8601)

# This is the file that will later contain UUIDs of registered backup drives
DISKS=/etc/backups/backup.disks

# Find whether the connected block device is a backup drive
for uuid in $(lsblk --noheadings --list --output uuid)
do
        if grep --quiet --fixed-strings $uuid $DISKS; then
                break
        fi
        uuid=
done

if [ ! $uuid ]; then
        echo "No backup disk found, exiting"
        exit 0
fi

echo "Disk $uuid is a backup disk"
partition_path=/dev/disk/by-uuid/$uuid
# Mount file system if not already done. This assumes that if something is already
# mounted at $MOUNTPOINT, it is the backup drive. It won't find the drive if
# it was mounted somewhere else.
(mount | grep $MOUNTPOINT) || mount $partition_path $MOUNTPOINT
drive=$(lsblk --inverse --noheadings --list --paths --output name $partition_path | head --lines 1)
echo "Drive path: $drive"

yay -Qqe > /home/johny/Documents/Backup/pkglist.txt
tree -d /mnt/Media > /home/johny/Documents/Backup/MediaFiles.txt

#
# Create backups
#

# Options for borg create
BORG_OPTS="--stats --one-file-system --compression lz4 --checkpoint-interval 86400"

# Set BORG_PASSPHRASE or BORG_PASSCOMMAND somewhere around here, using export,
# if encryption is used.
export BORG_PASSPHRASE='ST280x79@aex_!'

# No one can answer if Borg asks these questions, it is better to just fail quickly
# instead of hanging.
export BORG_RELOCATED_REPO_ACCESS_IS_OK=no
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=no

# Log Borg version
borg --version

echo "Starting backup for $DATE"

# This is just an example, change it however you see fit
# /home is often a separate partition / file system.
# Even if it isn't (add --exclude /home above), it probably makes sense
# to have /home in a separate archive.
borg create $BORG_OPTS \
  --exclude 'sh:/home/*/.cache' \
  $TARGET::$DATE-$$-home \
  /home/johny/Pictures/ \
  /home/johny/Downloads/ \
  /home/johny/Documents/ \
  /home/johny/Books/ \
  /home/johny/Projects/ \
  /home/johny/.password-store/ \
  /home/johny/.config/ \
  --exclude '.stignore' \
  --exclude '.git' \
  --exclude '.thumbnails' \
  --exclude '.stfolder' \
  --exclude '.venv' \
  --exclude '.stfolder' \
  --exclude 'sh:home/johny/.config/qutebrowser/instances/*/cache'

echo "Completed backup for $DATE"

# Just to be completely paranoid
sync

if [ -f /etc/backups/autoeject ]; then
        umount $MOUNTPOINT
        hdparm -Y $drive
fi

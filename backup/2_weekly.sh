#!/bin/sh
# SOURCE: https://github.com/borgbackup/borg/blob/master/docs/quickstart.rst
# Weekly backup to NAS

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Settings
export BORG_REPO=/mnt/data/backup
export BORG_PASSPHRASE=$(gpg --decrypt /etc/backups/borg.gpg)
archive_name=$(date +$HOSTNAME"_v"%U"_"%Y)

# Helpers and error handling:
# Note: $XMPP_TARGET is a global variable leading to my XMPP address
info() { logger -t "backup" "$*" >&2; }
xmpp() { echo "$*" | sendxmpp --tls-ca-path="/etc/ssl/certs" -t -n $XMPP_TARGET; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Weekly backup: Starting"

# Send magic packet to wake NAS then wait for it to become online
wakeonlan MAC_ADDRESS

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                                     \
    --verbose                                   \
    --filter archive_name                       \
    --list                                      \
    --stats                                     \
    --show-rc                                   \
    --compression lz4                           \
    --exclude-caches                            \
    --exclude-from '/etc/backups/exclude-list'  \
    ::$archive_name                             \
    /etc                                        \
    /home                                       \
    /root                                       \
    /var                                        \
    /usr/local/bin                              \
    /usr/local/sbin                             \
    /srv                                        \
    /opt >> /var/log/backup/$archive_name.log 2>&1

backup_exit=$?

info "Weekly backup: Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}_*' globbing is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --glob-archives '{hostname}_*'  \
    --show-rc                       \
    --keep-weekly   4               \
    --keep-monthly  6 >> /var/log/backup/$archive_name.log 2>&1

prune_exit=$?

# use highest exit code as exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 1 ];
then
    info "Weekly backup: Finished with warnings!"
    xmpp "Weekly backup of $HOSTNAME finished with warnings"
fi

if [ ${global_exit} -gt 1 ];
then
    info "Weekly backup: Finished with errors!!"
    xmpp "Weekly backup of $HOSTNAME finished with errors"
fi

exit ${global_exit}
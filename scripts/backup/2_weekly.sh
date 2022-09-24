#!/bin/sh
# SOURCE: https://github.com/borgbackup/borg/blob/master/docs/quickstart.rst

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# SETTINGS
export BORG_REPO=ssh://username@example.com:2022/~/backup/main
export BORG_PASSPHRASE='gpg --decrypt borg.gpg'
xmpptarget=foo@bar.com
archive_name=$(date +$HOSTNAME"_v"%U"_"%Y)

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
xmpp() { echo "$*" | sendxmpp --tls-ca-path="/etc/ssl/certs" -t -n $xmpptarget}
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Weekly backup: Starting"

# Send magic WOL packet to NAS and wait until it is online
wakeonlan

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
    --exclude 'home/*/.cache/*'     \
    --exclude 'var/tmp/*'           \
                                    \
    "$archive_name"                 \
    /etc                            \
    /home                           \
    /root                           \
    /var                            \
    /usr/local/bin                  \
    /usr/local/sbin                 \
    /srv                            \
    /opt

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
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6

prune_exit=$?

# actually free repo disk space by compacting segments

info "Weekly backup: Compacting repository"

borg compact

compact_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Weekly backup: Finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Weekly backup: Finished with warnings"
    xmpp "Weekly backup of $HOSTNAME finished with warnings"
else
    info "Weekly backup: Finished with errors"
    xmpp "Weekly backup of $HOSTNAME finished with errors"
fi

exit ${global_exit}
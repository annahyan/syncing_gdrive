#!/usr/bin/bash
# NOTE: This requires GNU getopt.  On Mac OS X and FreeBSD, you have to install this
# separately; see below.
TEMP=$(getopt -o htl:r: --long help,to-gdrive,localdir:,remotedir: \
              -n 'sync_gdrive' -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi


################################################################################

usage="\nScript transfers syncs local directories with remote directories on Google Drive.\n\n

\t-h, --help\tPrint this message and exit.\n
\t-t, --to-gdrive\tIf set, then the local directories are synced to GDrive dirs.\n
\t\t\tDefault: false.\n
\t-l, --localdir\tLocal parent directory.\n
\t-r, --remotedir\tRemote parent directory in GDrive.\n
\n
usage: sync_script.sh [-t] [-l path_to_local_dir] [- path_to_remote_dir] dir1 dir2 ...\n
"

# Note the quotes around '$TEMP': they are essential!
eval set -- "$TEMP"

TOGDRIVE=false
while true; do
    case "$1" in
	-h | --help ) echo -e "$usage"
		      exit;;
	-t | --to-gdrive ) TOGDRIVE=true; shift ;;
	-l | --localdir ) localdir=$2; shift 2 ;;
	-r | --remotedir ) remotedir="$2"; shift 2 ;;
	-- ) shift; break ;;
	* ) break ;;
    esac
done

################################################################################


if TOGDRIVE; then
    echo "Syncing the files from local to GDRIVE"
else
    echo "Syncing the files from GDRIVE to local"
fi



echo "local base directory is $localdir"
echo "GDrive base directory is $remotedir"

echo "Directories to sync are - $@"

[ -z $localdir ] && echo -e "\nERROR: localdir is missing." && echo -e "$usage" && exit
[ -z $remotedir ] && echo -e "\nERROR: remotedir is missing." && echo -e "$usage" && exit

if ((${#@} == 0)); then
    echo "Please provide directories to sync. No directory was found..."
    echo -e "${usage}"
    exit
fi

################################################################################

for dir in "$@"; do
    echo "Syncing $dir"
    if $TOGDRIVE; then
	/usr/bin/rclone copy --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s ${localdir}/${dir} google-drive:${remotedir}/${dir}
    else
	/usr/bin/rclone copy --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s google-drive:${remotedir}/${dir}  ${localdir}/${dir} 
    fi
done


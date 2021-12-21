# syncing_gdrive

Syncs local directories with Google Drive with rclone.

Works for linux. 

Rclone can be set up following [this guide](https://www.howtogeek.com/451262/how-to-use-rclone-to-back-up-to-google-drive-on-linux/).

**Usage:**

	-h, --help	Print this message and exit.

	-t, --to-gdrive	If set, then the local directories are synced to GDrive dirs.

			Default: false.

	-l, --localdir	Local parent directory.

	-r, --remotedir	Remote parent directory in GDrive.



	sync_script.sh [-t] [-l path_to_local_dir] [- path_to_remote_dir] dir1 dir2 ...


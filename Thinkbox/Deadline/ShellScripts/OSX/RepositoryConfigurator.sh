#!/bin/sh

#=====================================
# Configuration
#-------------------------------------

USERNAME=deadline
USER_PASSWORD="User.login.should.be.blocked.anyway"
SMB_PASSWORD="deadline"
GRPNAME=deadline

# Find a free userid. Feel free to specify some static one, as long as you know it's available.
MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
USERID=$((MAXID+1))

# Find a free groupid. Same dealie
MAXID=$(dscl . -list /Groups PrimaryGroupID | awk '{print $2}' | sort -ug | tail -1)
GRPID=$((MAXID+1))

DEADLINE_PATH=/Applications/DeadlineRepository
SMB_PATH=/etc/smb.conf

#=====================================

# Force root credentials for this script
if [[ $UID -ne 0 ]]; then echo "Please run this script as root." && exit 1; fi

dscl . -list /Groups | grep $GRPNAME > /dev/null
if [[ $? -ne 0 ]];
then
	echo "Creating group $GRPNAME with id $GRPID"
	dscl . -create /Groups/$GRPNAME
	dscl . -append /Groups/$GRPNAME PrimaryGroupID $GRPID
else
	echo "Group $GRPNAME already exists. Skipped creation"
fi

dscl . -list /Users | grep $GRPNAME > /dev/null
if [[ $? -ne 0 ]];
then
	echo "Creating user $USERNAME with id $USERID"
	dscl . -create /Users/$USERNAME UserShell /usr/bin/false
	dscl . -append /Users/$USERNAME UniqueID $USERID PrimaryGroupID $GRPID
	dscl . -passwd /Users/$USERNAME "$USER_PASSWORD"
else
	echo "User $USERNAME already exists. Skipped creation"
fi

pdbedit -w -L | grep $USERNAME
if [[ $? -ne 0 ]];
then
	echo "Creating samba user $USERNAME and setting password"
	(echo "$PASSWORD"; echo "$SMB_PASSWORD") | smbpasswd -as $USERNAME
else
	echo "User $USERNAME is already part of the samba user list"
fi

echo "Adding user to group."
dseditgroup -o edit -a $USERNAME -t user $GRPNAME

echo "Setting ownership of deadline directory to new user and group"
chown -R $USERNAME "$DEADLINE_PATH"
chgrp -R $GRPNAME "$DEADLINE_PATH"

echo "Injecting repository rules into samba config (/etc/smb.conf)"
grep "Repository" $SMB_PATH > /dev/null
if [[ $? -ne 0 ]];
then
	echo "#=== Deadline Repository Share ==="						>> $SMB_PATH
	echo "# Note that this share will not show up in the OSX UI"	>> $SMB_PATH
	echo "[Repository]"												>> $SMB_PATH
	echo "	path=$DEADLINE_PATH"					>> $SMB_PATH
	echo "	comment=Test Repository configuration"					>> $SMB_PATH
	echo "	writeable=yes"											>> $SMB_PATH
else
	echo "Repository share already present in /etc/smb.conf."
	echo "Please delete share before running this script again"
fi


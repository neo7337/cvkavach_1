#!/bin/bash

#
# To be used only in case of SNAPSHOT or RELEASE upload to dev, test or master branches
#

set -e

if [ $# -lt 4 ];
then
    echo "Invalid Number of arguments"
    echo "Please enter the <build-version> <commit-message> <Build-Type eg: SNAPSHOT or RELEASE> <branch>"
    exit 1
fi

cd ..

# commit the build to github
git add .

# read commit message from $2
git commit -m $2

git push -u origin $4

# add tags to the git

TAG_NAME="$1-$3"
echo "TAG NAME->> $TAG_NAME"
git tag -f $TAG_NAME -m $2

git push -—tags -f
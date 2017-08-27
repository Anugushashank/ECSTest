#!/bin/bash
set -e

# latest commit
LATEST_COMMIT=$(git rev-parse HEAD)

# latest commit where path/to/folder1 was changed
FOLDER1_COMMIT=$(git log -1 --format=format:%H --full-diff .)

if [ $FOLDER1_COMMIT = $LATEST_COMMIT ];
    then
        echo "files in folder1 has changed"
        chmod +x deploy.sh
        ./deploy.sh
else
     echo "no folders of relevance has changed"
     exit 0;
fi
#!/bin/bash

echo "START - installing updated 'pre-commit' hooks on local 'pay' Git repos"

echo -n "This script will delete your existing git hooks. Do you want to continue? (y/n): ";
read -r
if [  "${REPLY}" != 'y' ]; then
  echo "Exiting"
  exit 1
fi

errorRunningScript=false

for d in pay-*/ ; do
    echo "********************"
    echo "Start - Updating: $d"
    
    echo "Changing directory into: $d"
    
    if ! cd "$d"; then
        echo "ERROR - could not change into directory: $d"
        echo "Skipping to next directory"
        errorRunningScript=true
        cd ..
        continue
    fi
    
    echo "Inside: $d"
    
    echo "Checking out 'MASTER' branch..."

    if ! git checkout master; then
        echo "INFO - could not checkout 'MASTER' branch"
        echo "Trying to checkout 'MAIN' branch..."

        if ! git checkout main; then
            echo "ERROR - could not checkout 'MAIN' branch"
            echo "Delete or stash changes for $d and run the script again"
            echo "Skipping to next directory"
            errorRunningScript=true
            cd ..
            continue
        fi
    fi

    echo "Pulling the latest changes..." 

    if ! git pull; then
        echo "ERROR - could not pull the latest changes for $d"
        echo "Please clean up $d and run the script again"
        echo "Skipping to next directory"
        errorRunningScript=true
        cd ..
        continue
    fi

    FILE=".git/hooks/pre-commit*"

    # shellcheck disable=SC2086
    if [ -f $FILE ]; then
        echo "Existing Git 'pre-commit' hooks exist"
        echo "-- Deleting existing hooks."
        rm .git/hooks/pre-commit*
        echo "-- Deleted."
    fi
        
    echo "Installing new Git hooks"
    
    if ! pre-commit install; then 
        echo "ERROR - installing 'pre-commit' hooks in $d"
        echo "Skipping to next directory"
        errorRunningScript=true
        cd ..
        continue
    fi

    cd ..

    echo "End - Updating: $d"
    echo "********************"
done

if $errorRunningScript ; then 
    echo "------------------------------------"
    echo "ERROR RUNNING THE SCRIPT" 
    echo "Look through the log and fix issues then run the script again."
    echo "------------------------------------"
    exit 1
fi

echo "------------------------------------"
echo "FINISH - Script has run successfully."
echo "------------------------------------"

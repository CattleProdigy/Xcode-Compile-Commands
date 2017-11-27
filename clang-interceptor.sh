#!/bin/bash

xcodeIsRunning=$(osascript <<'END'
set appName to "Xcode"

if application appName is running then
    return 1
else
    return 0
end if
END)
    
xcodeWS=""
if [ "$xcodeIsRunning" -eq "1" ]; then
xcodeWS=$(osascript <<'END'
    tell application "Xcode"
        try
            tell active workspace document
                return path
            end tell
        on error
            return ""
        end try
    end tell
END)
fi

clangPath=`dirname $0`
cc=`basename $0`

xcodeIsRunning=0

if [[ $xcodeIsRunning && -n $xcodeWS ]]
then
    filename=`echo $@ | perl -n -e'/-c (\S+)/ && print $1'`
    hashName=`echo $filename | shasum - | cut -d ' ' -f 1`
    wsPath=`dirname $xcodeWS`
    wsName=`basename $xcodeWS`
    databasePath="$wsPath/compile_commands"
    mkdir -p $databasePath
    `touch $wsPath/compile_commands.json`
    `exec -a $cc $clangPath/.clang -MJ $databasePath/$hashName.json $@`
    sed -e '1s/^/[\n/' -e '$s/,$/\n]/' "$databasePath/$hashName.json" >> "$wsPath/compile_commands.json"
else
    # Forward to normal clang command
    `exec -a $cc $clangPath/.clang $@`
fi


#!/bin/bash

get_channel() {

    name=$(sed -n "${1}p" clean_channel)
    echo $name

}

get_audio() {

    base="https://www.youtube.com"

    exec 10<&0
    fileName="results/${1}/clean_playlists"
    exec < $fileName
    COUNTER=1

        trap "exit" INT
        while read line; do
            url=$base$line
            mkdir ~/Programming/Bash/REntropy/results/${1}/$COUNTER
            echo "Current Channel: $1"
            youtube-dl -o "~/Programming/Bash/REntropy/results/${1}/$COUNTER/%(title)s.%(ext)s" --extract-audio --audio-format mp3 --audio-quality 0 $url
            ((COUNTER++)) 
        done

    exec 10<&-

}

download_controller() {
    
    if [ -z "$1" ]; then
        COUNTER=1
        MAX=$(wc -l clean_channel | awk '{print $1}')

        while [ $COUNTER -lt $MAX ]; do
            channel=$(get_channel $COUNTER) 
            get_audio $channel
            let COUNTER=COUNTER+1
        done
    else
        get_audio $1
    fi

}

command=$(echo $1)
download_controller $command

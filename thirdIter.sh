#!/bin/bash
########################################################################
########################################################################
####                                                                  ##
#### File Name:         thirdIter.sh                                  ##
####                                                                  ##
#### Github Repo:       https://github.com/drednaut/REntropy.git      ##
####                                                                  ##
#### Author:            Jared Knutson                                 ##
####                                                                  ##
#### Email:             jaredknutson@nevada.unr.edu                   ##
####                                                                  ##
#### Date:              5/19/2017                                     ##
####                                                                  ##
#### Dependencies:      youtube-dl avconv                             ##
####                                                                  ##
#### Version:           0.4.0                                         ##
####                                                                  ##  
#### Usage:             ./thirdIter.sh <Sub-Channel>                  ## 
####                                                                  ##
#### Notes:                                                           ## 
####                                                                  ##
########################################################################
########################################################################


# Function takes as parameter line number of current playlist url extension.
# Funtion echos a return value in the form of the channel name corresponding to the position of the current playlist url extension.
get_channel() {

    name=$(sed -n "${1}p" clean_channel)
    echo $name

}


# Function takes as parameter line number of current title of playlist and the current channel name being used.
# Funtion echos a return value in the form of the playlist name corresponding to the position of the current playlist url extension.
get_title() {

    name=$(sed -n "${1}p" ~/Programming/Bash/REntropy/results/${2}/clean_titles)
    echo $name

}


# Function takes in parameters channel name
# Function calls get_title and youtube-dl
# Function does not return a value but downloads the mp3 from the specified Youtube subchannel or if none are specified in the command line arguments it will start at the first subchannel in alphabetical order.
get_audio() {

    base="https://www.youtube.com"

    exec 10<&0
    fileName="results/${1}/clean_playlists"
    exec < $fileName
    COUNTER=1

        trap "exit" INT
        while read line; do
            url=$base$line
            playlist=$(get_title $COUNTER $1)
            mkdir ~/Programming/Bash/REntropy/results/${1}/${playlist}
            echo "Current Playlist: $playlist"
            youtube-dl -o "~/Programming/Bash/REntropy/results/${1}/$playlist/%(title)s.%(ext)s" --extract-audio --audio-format mp3 --audio-quality 0 $url
            ((COUNTER++)) 
        done

    exec 10<&-

}


# Function will possibly have the command line arguments as parameter, but will still operate to a default operation if none are specified
# Function initiates the process of getting download.
# Function does not return a value.
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


#-------BEGIN PROGRAM------------
command=$(echo $1)
download_controller $command
#---------END PROGRAM-------------

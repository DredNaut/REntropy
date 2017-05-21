#!/bin/bash
########################################################################
########################################################################
####                                                                  ##
#### File Name:         by_batch.sh                                  ##
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
#### Usage:             ./by_batch.sh <URL> <File Path>               ## 
####                                                                  ##
#### Notes:                                                           ## 
####                                                                  ##
########################################################################
########################################################################


# Function takes in parameters channel name
# Function calls get_title and youtube-dl
# Function does not return a value but downloads the mp3 from the specified Youtube subchannel or if none are specified in the command line arguments it will start at the first subchannel in alphabetical order.
get_audio() {


    exec 10<&0
    fileName="$1"
    exec < $fileName

        trap "exit" INT
        while read line; do
            url=$line
            youtube-dl -o "${2}%(title)s.%(ext)s" --extract-audio --audio-format mp3 --audio-quality 0 $url
        done

    exec 10<&-

}


get_audio $1 $2

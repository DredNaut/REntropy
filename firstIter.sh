#!/bin/bash
########################################################################
########################################################################
####                                                                  ##
#### File Name:         firstIter.sh                                  ##
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
#### Usage:             ./firstIter.sh <User Channel>                 ## 
####                                                                  ##
#### Notes:                                                           ## 
####                                                                  ##
########################################################################
########################################################################


#This function touches and then removes all the files dealt with by this script. 
#This insure that all file contents begin the program empty.
file_gen() {

    touch firstIter firstSnip firstClean data-video-ids clean-dvi clean-ytid clean_channel channel_raw temp_channel

    rm firstIter firstSnip firstClean data-video-ids clean-dvi  clean-ytid clean_channel channel_raw temp_channel


}


#This function targets the original html dump and finds patterns which corrilate to the ytid values of the channels within the current channel.
get_ytid() {

    wget -O firstIter $1

    grep 'data-ytid=' firstIter > firstSnip

    declare -a ARRAY
    exec 10<&0
    fileName="firstSnip"
    exec < $fileName

    let count=0

    while read LINE; do
        ARRAY[$count]=$LINE
        ((count++))
    done

    exec 10<&-

    regex="data-ytid=\"[A-Z a-z 0-9 _ -- ]*\""

    ELEMENTS=${#ARRAY[@]}
    firstline=0

    for((i=0;i<$ELEMENTS;i++)); do
        if [[ ${ARRAY[${i}]} =~ $regex ]]; then
            if [[ $firstLine<1 ]]; then
                echo ${BASH_REMATCH[0]} > firstClean 
                let firstLine=$firstLine+1
            else
                echo ${BASH_REMATCH[0]} >> firstClean
            fi
        fi
    done
    
    get_channel
}


# This function formats the ytid pattern match result so that it can be used in the next iteration of this program.
# The program uses awk and sed to accomplish this task.
scrape_ytid() {

    awk '!a[$0]++' firstClean > channel-ytids
    sed -i 's/\"/ /g' channel-ytids 
    awk '{print $2}' channel-ytids >> clean-ytid

}


# This function targets the main html dump and searches for patterns which correspond to the title of the channels, within the channel. 
# These patterns are output to a file called channel_raw.
get_channel() {

    declare -a ARRAY
    exec 10<&0
    fileName="firstIter"
    exec < $fileName

    let count=0

    while read LINE; do
        ARRAY[$count]=$LINE
        ((count++))
    done

    exec 10<&-
    regex="dir=\"ltr\" title=\"[A-Za-z]*"

    ELEMENTS=${#ARRAY[@]}
    firstline=0

    for((i=0;i<$ELEMENTS;i++)); do
        if [[ ${ARRAY[${i}]} =~ $regex ]]; then
            if [[ $firstLine<1 ]]; then
                echo ${BASH_REMATCH[0]} > channel_raw 
                let firstLine=$firstLine+1
            else
                echo ${BASH_REMATCH[0]} >> channel_raw
            fi
        fi
    done
    scrape_channel

}


# This function uses the file created by the get_channel function and formats the results contained in that file so that they represent the correct names of the channels, within the current channel.
#This function outputs the corrected channel titles into a file named clean_channel
scrape_channel() {

    awk '!a[$0]++' channel_raw > temp_channel
    sed -i 's/\"/$/g' temp_channel
    awk -F '$' '{print $4}' temp_channel >> clean_channel
    sed -i 's/ //g' clean_channel

}


# As it's name suggests this function removes the temporary files which are used to format the final output.
garbage_collection() {

    rm firstSnip firstClean channel-ytids channel_raw temp_channel

}

#-------BEGIN PROGRAM------------
channel=$(echo $1)
channel="https://www.youtube.com/user/${channel}/channels"
file_gen
get_ytid $channel
scrape_ytid
echo "Number of Channels found: $(wc -l clean_channel | awk '{print $1}')"
garbage_collection
#---------END PROGRAM-------------

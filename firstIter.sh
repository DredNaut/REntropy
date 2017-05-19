#!/bin/bash

touch firstIter firstSnip firstClean data-video-ids clean-dvi
rm firstIter firstSnip firstClean data-video-ids clean-dvi

#create function to modify command line arguments to determine the type of seach the query to be made for

#create function for editing strings delimited plus sign

#make http request and download page for youtube search query


file_gen() {

    touch clean-ytid clean_channel channel_raw temp_channel
    rm clean-ytid clean_channel channel_raw temp_channel

}


#------------------ARRAY TO FETCH IDS VALUES-------------
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


scrape_ytid() {

    awk '!a[$0]++' firstClean > channel-ytids
    sed -i 's/\"/ /g' channel-ytids 
    awk '{print $2}' channel-ytids >> clean-ytid

}


#------------------ARRAY TO FETCH CHANNEL TITLES-------------
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


scrape_channel() {

    awk '!a[$0]++' channel_raw > temp_channel
    sed -i 's/\"/$/g' temp_channel
    awk -F '$' '{print $4}' temp_channel >> clean_channel
    sed -i 's/ //g' clean_channel
    cat clean_channel

}


#------------Collect Garbage------------------
garbage_collection() {

    rm firstSnip firstClean channel-ytids channel_raw temp_channel

}


channel="https://www.youtube.com/user/nptelhrd/channels"
file_gen
get_ytid $channel
scrape_ytid
garbage_collection

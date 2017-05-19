#!/bin/bash
########################################################################
########################################################################
####                                                                  ##
#### File Name:         secondIter.sh                                 ##
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
#### Usage:             ./secondIter.sh                               ## 
####                                                                  ##
#### Notes:                                                           ## 
####                                                                  ##
########################################################################
########################################################################


# This function takes as parameter the name of the channel being formated such that it may use it when creating a file for the properly formatted titles.
# This function does not call any other functions.
scrape_titles() {

touch titles_raw results/${1}/clean_titles
rm titles_raw results/${1}/clean_titles
echo "Scraping Titles"
grep -A 2 'feed-item-post' secondIter >> titles_raw
sed -i 's/<\/p/<p/g' titles_raw
sed -i 's/<p>/\$/g' titles_raw
sed -i 's/-//g' titles_raw
sed -i 's/_//g' titles_raw
sed -i 's/(//g' titles_raw
sed -i 's/)//g' titles_raw
awk -F '$' '{print $2}' titles_raw >> results/${1}/clean_titles
sed -i '$!N; /^\(.*\)\n\1$/!P; D' results/${1}/clean_titles
sed -i '/^\s*$/d' results/${1}/clean_titles
sed -i 's/ //g' results/${1}/clean_titles

}


# This function takes as a parameter the name of the channel, which it uses to create a file in the path of the channel directory.
# The result of this function is a file which contains the properly formated playlist addresses. 
# This function does not call any other functions.
scrape_playlist() {

touch results/${1}/clean_playlists
rm results/${1}/clean_playlists
echo "Scraping Playlists"
grep 'yt-uix-tile-link  spf-link  yt-ui' secondIter >> playlist_raw
sed -i 's/"/\$/g' playlist_raw
awk -F '$' '{print $14}' playlist_raw >> results/${1}/clean_playlists
sed -i '/^\s*$/d' results/${1}/clean_playlists

}


# This function takes as a parameter the numeric value of the line currently being operated upon regarding the ytid value.
#The function uses this value to search and find the appropriate channel name for that ytid.
# This function echos a return value of the string name of the channel currently being used.
get_channel_name() {


    dir1=$(grep -n "${1}" clean-ytid | awk -F ':' '{print $1}' )
    name=$(sed -n "${dir1}p" clean_channel)
    echo $name


}


# Function takes no parameters
# Function is responsible for looping through all of the ytid values found in the first iteration script.
# Function results in the creation of files called clean_titles and clean_playlists, as well as the creation of directories named after the channels.
# Function calls get_channel_name, scrape_titles, and scrape_playlists.
get_title_playlist() {

    base="youtube.com/channel/"

    exec 10<&0
    fileName="clean-ytid"
    exec < $fileName

        while read line; do
            touch playlist_raw secondIter 
            rm playlist_raw secondIter
            url=$base$line
            echo ""
            echo "TID: $line"
            name=$(get_channel_name $line)
            echo "Current Channel: $name"
            wget -q -O secondIter $url
            mkdir -p results/${name}
            scrape_titles $name
            scrape_playlist $name
        done

    exec 10<&-

}


# This function does not take any parameters.
# function provides a means of reseting the content of the temporary files which are used in the formatting process of the scrape.
# This function does not return a value.
test_file() {

    touch url.bat clean_playlist clean_titles playlist_raw titles_raw
    rm url.bat clean_playlist clean_titles playlist_raw titles_raw

}


# This function does not take any parameters.
# Function provides a method of removing the temporary files after the script successfully creates the output files.
# This function does not return a value.
garbage_collection() {

    rm playlist_raw titles_raw

}


#-------BEGIN PROGRAM------------
test_file
get_title_playlist
garbage_collection
#---------END PROGRAM-------------

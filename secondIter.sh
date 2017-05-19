#!/bin/bash


scrape_titles() {

echo "Scraping Titles"
grep -A 2 'feed-item-post' secondIter >> titles_raw
sed -i 's/<\/p/<p/g' titles_raw
sed -i 's/<p>/\$/g' titles_raw
awk -F '$' '{print $2}' titles_raw >> clean_titles
sed -i '$!N; /^\(.*\)\n\1$/!P; D' clean_titles
sed -i '/^\s*$/d' clean_titles
sed -i 's/ //g' clean_titles

}


scrape_playlist() {

echo "Scraping Playlists"
grep 'yt-uix-tile-link  spf-link  yt-ui' secondIter >> playlist_raw
sed -i 's/"/\$/g' playlist_raw
awk -F '$' '{print $14}' playlist_raw >> results/${1}/clean_playlists
sed -i '/^\s*$/d' results/${1}/clean_playlists

}


get_channel_name() {


    dir1=$(grep -n "${1}" clean-ytid | awk -F ':' '{print $1}' )
    name=$(sed -n "${dir1}p" clean_channel)
    echo $name


}

get_title_playlist() {

    base="youtube.com/channel/"

    exec 10<&0
    fileName="clean-ytid"
    exec < $fileName

        while read line; do
            url=$base$line
            name=$(get_channel_name $line)
            echo "Current Channel: $name"
            wget -q -O secondIter $url
            mkdir results/${name}
            scrape_titles
            scrape_playlist $name
        done

    exec 10<&-

}


test_file() {

    touch url.bat clean_playlist clean_titles
    rm url.bat clean_playlist clean_titles 

}


garbage_collection() {

    rm playlist_raw titles_raw

}


test_file
get_title_playlist
garbage_collection

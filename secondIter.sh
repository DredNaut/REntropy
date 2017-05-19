#!/bin/bash


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


scrape_playlist() {

touch results/${1}/clean_playlists
rm results/${1}/clean_playlists
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


test_file() {

    touch url.bat clean_playlist clean_titles playlist_raw titles_raw
    rm url.bat clean_playlist clean_titles playlist_raw titles_raw

}


garbage_collection() {

    rm playlist_raw titles_raw

}


test_file
get_title_playlist
garbage_collection

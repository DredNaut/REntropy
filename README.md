# REntropy

This application is written in BASH script.

### Installation
To install dependancies on debian-based systems:
```
sudo apt-get install youtube-dl avconv
```
or for Arch users
```
sudo pacman -S youtube-dl avconv
```
```
// Clone repository to the directory of your choice
git clone https://github.com.com/drednaut/REntropy.git 
```

### Usage
```
// Grabs the ytid's and channel titles from the specified user.
./firstIter.sh <User Channel>

// Creates Directories based on the channel titles gathered in the first iteration.
// Generates playlist tid's and sorts them into the correct directories.
./secondIter.sh

// Scrapes the individual Youtube playlists using the command line tool youtube-dl.
./thirdIter.sh <Channel Within Channel Tab>
```

### ToDo
- Test on other channels besides nptelhrd.
- Make a single script to run all iterations.
- Make the single script interactive for asking for channels.

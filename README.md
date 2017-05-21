# REntropy

This application's backend is written in BASH script, frontend wrriten in Python using the module  tkinter.

### Installation
To install dependancies on debian-based systems:
```
sudo apt-get install git youtube-dl avconv
```
or for Arch users
```
sudo pacman -S youtube-dl avconv
```
Clone repository to the directory of your choice
```
git clone https://github.com.com/drednaut/REntropy.git 
```

### Usage
Run REntropy cli version:
```
./REntropy
```
Or you can use gui version (requires python3 tkinter):
```
python REntropy.py
```
### Explaination
The code is well documented so refer to code for any specific inqueries.
Grabs the ytid's and channel titles from the specified user.
```
./firstIter.sh <User Channel>
```
Creates Directories based on the channel titles gathered in the first iteration.
Generates playlist tid's and sorts them into the correct directories.
```
./secondIter.sh
```
Scrapes the individual Youtube playlists using the command line tool youtube-dl.
```
./thirdIter.sh <Channel Within Channel Tab>
```

### ToDo
- Error-handling for command line arguments issued for firstIter.sh and thirdIter.sh.
- Optimize the gui to show errors and successes
- Interactive gui: user should not be able to perform multiple searches at a single time. After searching goto a loading screen until the download finishes.

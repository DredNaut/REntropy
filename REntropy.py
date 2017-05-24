########################################################################
########################################################################
####                                                                  ##
#### File Name:         REntropy.py                                   ##
####                                                                  ##
#### Github Repo:       https://github.com/drednaut/REntropy.git      ##
####                                                                  ##
#### Author:            Jared Knutson                                 ##
####                                                                  ##
#### Email:             jaredknutson@nevada.unr.edu                   ##
####                                                                  ##
#### Date:              5/19/2017                                     ##
####                                                                  ##
#### Dependencies:      python3-tkinter                               ##
####                                                                  ##
#### Version:           0.4.0                                         ##
####                                                                  ##  
#### Usage:             python REntropy.py                            ## 
####                                                                  ##
#### Notes:                                                           ## 
####                                                                  ##
########################################################################
########################################################################

from tkinter import *
from tkinter import ttk
from tkinter import filedialog
import subprocess as sub
import os


class Application(Frame):

    def ask_directory(self):
        dirname = filedialog.askdirectory()
        if dirname:
            self.var.set(dirname)

    def first_iteration(self):
        userData = self.entry1.get()
        cmd = "./firstIter.sh "+userData
        os.system(cmd)

    def second_iteration(self):
        cmd = "./secondIter.sh"
        os.system(cmd)

    def third_iteration(self):
        userData = self.entry2.get()
        cmd = "./thirdIter.sh "+userData
        os.system(cmd)

    def by_video(self):
        url = self.entry3.get()
        filepath = self.entry4.get()
        cmd = "./by_video.sh "+url+" "+filepath
        p = sub.Popen(cmd, stdout=sub.PIPE, stderr=sub.PIPE)
        output, errors = p.communicate()
        #os.system(cmd)

    def by_playlist(self):
        url = self.playentry1.get()
        filepath = self.playentry2.get()
        cmd = "./by_playlist.sh "+url+" "+filepath
        os.system(cmd)

    def by_batch(self):
        batch = self.entry5.get()
        filepath = self.entry6.get()
        cmd = "./by_batch.sh "+batch+" "+filepath
        os.system(cmd)


    def createWidgets(self):

# ------------- NOTEBOOK ----------------
        self.note = ttk.Notebook(self)
       
    # ------------- TAB ABOUT -------------------
        self.tab0 = Frame(self.note)
        self.note.add(self.tab0, text="About")
        
        # ----------- LABEL -------------
        self.header1 = Label(self.tab0, text="About this Application").grid(row=1, columnspan=3)
        self.about1 = Label(self.tab0, text="Choose which type of download you would like to perform.").grid(row=2) 
        self.about2 = Label(self.tab0, text="Make sure to give the full file path. When specified for output path.").grid(row=3) 


    # ------------- TAB CHANNEL -------------------
        self.tab1 = Frame(self.note)
        self.note.add(self.tab1, text="By Channel")

        # ----------- LABEL -------------
        self.header1 = Label(self.tab1, text="Download by Channel")
        self.header1.grid(row=1, columnspan=3)

        # -----------BUTTONS -----------------
        self.firstI = Button(self.tab1)
        self.firstI["text"] = "First Iteration"
        self.firstI["command"] = self.first_iteration
        self.firstI.grid(row=2, column=0)

        self.secondI = Button(self.tab1)
        self.secondI["text"] = "Second Iteration"
        self.secondI["command"] = self.second_iteration
        self.secondI.grid(row=3, column=0)

        self.thirdI = Button(self.tab1)
        self.thirdI["text"] = "Third Iteration"
        self.thirdI["command"] = self.third_iteration
        self.thirdI.grid(row=4, column=0)

        self.QUIT = Button(self.tab1)
        self.QUIT["text"] = "QUIT"
        self.QUIT["fg"]   = "red"
        self.QUIT["command"] =  self.quit
        self.QUIT.grid(row=5, column=1, sticky='e')

        # -------- ENTRY --------------------
        self.entry1 = Entry(self.tab1)
        self.entry1.grid(row=2, column=1)

        self.entry2 = Entry(self.tab1)
        self.entry2.grid(row=4, column=1)


    # ------------- TAB PLAYLIST -------------------
        self.tab2 = Frame(self.note)
        self.note.add(self.tab2, text="By Playlist")

        # ------------ LABEL --------------
        self.header2 = Label(self.tab2, text="Download by Playlist")
        self.header2.grid(row=1, columnspan=3)

        self.playlist1= Label(self.tab2, text="Playlist URL")
        self.playlist1.grid(row=2, sticky='w')
        self.playlist2 = Label(self.tab2, text="Output Filepath")
        self.playlist2.grid(row=3, sticky='w')

        # -------- ENTRY --------------------
        self.var = StringVar(self)

        self.playentry1 = Entry(self.tab2)
        self.playentry1.grid(row=2, column=1)

        self.playentry2 = Entry(self.tab2, textvariable=self.var)
        self.playentry2.grid(row=3, column=1)
        
        # -----------BUTTONS -----------------
        self.downVid1 = Button(self.tab2)
        self.downVid1["text"] = "Begin Download"
        self.downVid1["command"] = self.by_playlist
        self.downVid1.grid(row=4, column=1)

        self.browse1 = Button(self.tab2)
        self.browse1["text"] = "Browse.."
        self.browse1["command"] = self.ask_directory
        self.browse1.grid(row=3, column=2)


    # ------------- TAB VIDEO -------------------
        self.tab3 = Frame(self.note)
        self.note.add(self.tab3, text="By Video")

        # ------------ LABEL --------------
        self.header3 = Label(self.tab3, text="Download by Video")
        self.header3.grid(row=1, columnspan=3)

        self.descr1= Label(self.tab3, text="Video URL")
        self.descr1.grid(row=2, sticky='w')
        self.descr2 = Label(self.tab3, text="Output Filepath")
        self.descr2.grid(row=3, sticky='w')

        # -----------BUTTONS -----------------
        self.downVid = Button(self.tab3)
        self.downVid["text"] = "Begin Download"
        self.downVid["command"] = self.by_video 
        self.downVid.grid(row=4, column=1)

        self.browse2 = Button(self.tab3)
        self.browse2["text"] = "Browse.."
        self.browse2["command"] = self.ask_directory
        self.browse2.grid(row=3, column=2)

        # -------- ENTRY --------------------
        self.entry3 = Entry(self.tab3).grid(row=2, column=1)
        self.entry4 = Entry(self.tab3, textvariable=self.var).grid(row=3, column=1)


    # ------------- TAB BATCH -------------------
        self.tab4 = Frame(self.note)
        self.note.add(self.tab4, text="By Batch")

        # ----------- LABEL -------------
        self.header4 = Label(self.tab4, text="Download Batch Job") 
        self.header4.grid(row=1, columnspan=3)

        self.descr3= Label(self.tab4, text="Batch File")
        self.descr3.grid(row=2, sticky='w')
        self.descr4= Label(self.tab4, text="Output Filepath")
        self.descr4.grid(row=3, sticky='w')

        # -----------BUTTONS -----------------
        self.downVid = Button(self.tab4)
        self.downVid["text"] = "Begin Download"
        self.downVid["command"] = self.by_batch
        self.downVid.grid(row=4, column=1)

        self.browse3 = Button(self.tab4)
        self.browse3["text"] = "Browse.."
        self.browse3["command"] = self.ask_directory
        self.browse3.grid(row=3, column=2)

        # -------- ENTRY --------------------
        self.entry5 = Entry(self.tab4)
        self.entry5.grid(row=2, column=1)

        self.entry6 = Entry(self.tab4, textvariable=self.var)
        self.entry6.grid(row=3, column=1)


        self.note.grid(row=0)


    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.pack()
        self.createWidgets()


# ------ MAIN ----------
root = Tk()
root.resizable(0,0)
root.title("REntropy - Youtube Scraper")
app = Application(master=root)
app.mainloop()
root.destroy()
# ------- End MAIN ------

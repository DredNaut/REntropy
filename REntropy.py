from tkinter import *
from tkinter import ttk
import os


class Application(Frame):
    def first_iteration(self):
        userData = self.entry1.get()
        cmd = "./firstIter.sh "+userData+"&"
        os.system(cmd)

    def second_iteration(self):
        cmd = "./secondIter.sh &"
        os.system(cmd)

    def third_iteration(self):
        userData = self.entry2.get()
        cmd = "./thirdIter.sh "+userData+"&"
        os.system(cmd)


    def createWidgets(self):

# ------------- NOTEBOOK ----------------
        self.note = ttk.Notebook(self)
       
    # ------------- TAB ABOUT -------------------
        self.tab0 = Frame(self.note)
        self.note.add(self.tab0, text="About")
        
        # ----------- LABEL -------------
        self.header1 = Label(self.tab0, text="About this Application") 
        self.header1.grid(row=1)

    # ------------- TAB CHANNEL -------------------
        self.tab1 = Frame(self.note)
        self.note.add(self.tab1, text="By Channel")

        # ----------- LABEL -------------
        self.header1 = Label(self.tab1, text="Download by Channel")
        self.header1.grid(row=1)

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
        self.header2.grid(row=1)


    # ------------- TAB VIDEO -------------------
        self.tab3 = Frame(self.note)
        self.note.add(self.tab3, text="By Video")

        # ------------ LABEL --------------
        self.header3 = Label(self.tab3, text="Download by Video")
        self.header3.grid(row=1)


        self.note.grid(row=0)


    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.pack()
        self.createWidgets()

# ------ MAIN ----------
root = Tk()
root.title("REntropy - Youtube Scraper")
root.iconbitmap('favicon.ico')
app = Application(master=root)
app.mainloop()
root.destroy()
# ------- End MAIN ------

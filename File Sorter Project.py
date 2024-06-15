import os, shutil
path = r"C:/Users/Simon/Desktop/File sorter work/" # turned path into a variable we can iterate through(?) forward slashes 

for item in os.listdir(path): # used a for loop to list the name of the files inside the folder of path.
    print(item) # this block of code is essentially helps you to see each single file inside the folder. 

folder_names = ['csv files', 'image files', 'text files'] # this block of code is saying if this does not exist then create the folder. 
for loop in range(0,3):
    if not os.path.exists(path + folder_names[loop]):  
     print(path + folder_names[loop]) 
    os.makedirs(path + folder_names[loop])

file_name = os.listdir(path)
for file in file_name:
    if ".csv" in file and not os.path.exists(path + "csv files/" + file):
        shutil.move(path + file, path + "csv files/" + file)
    elif ".jpg" in file and not os.path.exists(path + "image files/" + file):
        shutil.move(path + file, path + "image files/" + file)
    elif ".txt" in file and not os.path.exists(path + "text files/" + file):
        shutil.move(path + file, path + "text files/" + file)
    else :
        print("There are files in this path that were not moved!")




from sys import argv
import os
import shutil
for argument in argv :
    if argument != argv[0]:
        file_path = argument+"/index.html"
        if not os.path.exists(argument):
            os.makedirs(argument)
            shutil.copy('index.html',argument)
        file_name = open(file_path,'r')
        input_line = file_name.readlines()
        input_line[1] = 'title: "LeanOnTree - Posts related to the tag &#58; '+argument+'"\n'
        input_line[4] = '{% for postWithSpecificTag in site.tags.'+argument+' %}\n'
        file_name = open(file_path,'w')
        file_name.writelines( input_line )

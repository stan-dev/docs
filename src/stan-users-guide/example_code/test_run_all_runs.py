import os
import subprocess
import sys

def run_script(dir_name, script_call, file_name):
    print("processing " + dir_name)
    prev_dir = os.getcwd()
    os.chdir(dir_name)
    result = subprocess.run([script_call, file_name], check=True)
    os.chdir(prev_dir)
    print("Completed: " + dir_name + "/" + file_name)


parent_dir = os.getcwd()
try:
    if (len(sys.argv) == 1):
        print("testing all examples")
        for dir_name in os.listdir(os.getcwd()):
            if os.path.isfile(dir_name):
                continue
            run_script(dir_name,"Rscript","run.R")

    else:
        file_path = sys.argv[1]
        dir_file = os.path.split(file_path)[0]
        file_name = os.path.split(file_path)[1]
        if file_name.endswith(".R"):
            run_script(dir_file,"Rscript","run.R")
        elif file_name.endswith(".py"):
            run_script(dir_file,"python","run.py")
        raise NotImplementedError("Unknown script type: " + file_path)
except:
    print("End to end test FAIL")
finally:
    os.chdir(parent_dir)


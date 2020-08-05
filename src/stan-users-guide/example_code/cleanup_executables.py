"""End to end testing program for run.py and run.R programs in sibling
directories. See README.txt for details."""
import os
import subprocess
import sys


def clean_compile_files(path):
    if path.endswith(".stan"):
        executable_path = path[:-5]
        if (os.path.exists(executable_path)):
            print("removing executable:" + executable_path)
            os.remove(executable_path)
        o_file_path = executable_path + ".o"
        if (os.path.exists(o_file_path)):
            print("removing:" + o_file_path)
            os.remove(o_file_path)
        hpp_file_path = executable_path + ".hpp"
        if (os.path.exists(hpp_file_path)):
            print("removing:" + hpp_file_path)
            os.remove(hpp_file_path)
    elif os.path.isdir(path):
        for file_or_dir in os.listdir(path):
            clean_compile_files(os.path.join(path, file_or_dir))


current_dir = os.getcwd()
try:
    if (len(sys.argv) == 1):  # no file name given
        print("removing all executables and intermidiate files")
        clean_compile_files(current_dir)
    else:
        file_path = sys.argv[1]
        # clean_compile_files(file_path)
except Exception as e:
    print("Exception: ", e.__class__)
finally:
    os.chdir(current_dir)

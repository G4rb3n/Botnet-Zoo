import sys
import re

inputfile = sys.argv[1]

fh = open(inputfile, 'rb')

fd = fh.read()

fh.close()

minimum = 5

char = r"[\t\n\x20-\x7f]" + "{{{},}}".format(minimum)

wchar = r"(([\t\n\x20-\x7f]\x00)" + "{{{},}}".format(minimum) + r"\x00)"

allStrings = []

for s in re.findall(char, fd):

     allStrings.append(s)

for s in re.findall(wchar, fd):

     allStrings.append(s[0].replace("\x00″,"))

blacklist = []

allStr = []

for s in allStrings:

     if s[-3:] == ".go" and "main.go" in s:

          allStr.append(s)

     elif s[0:5] == "main.":

          if "statictmp" not in s:

               if ".init." not in s:

                    if ".(*" not in s:

                         allStr.append(s)

for x in list(set(allStr)):

     print(repr(x))
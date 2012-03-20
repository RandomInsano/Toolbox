# This is a starting point for a script to shift frame range numbering
# Ex: My output files start at frame 50 when they should be named to start at frame 1

# Note: This hasn't been debugged. The Regex will work though.
#    THERE'S NO GUARANTEE THIS WILL WORK! TEST AND DEBUG!
#    This algorithm assumes no item in the range is missing
#      Ex: In a range from frame 50 to 100, frame 75 can't be missing

# To fix it for missing frame ranges, you would just take the value of the last
# frame in the list, then run the for loop from startnum to that end number,
# skipping non-existant files, and solving for newnum based on the offset from
# the first number to the number 1

import re

# What's missing:
# - Find all files ending in four or more numbers
# - Sort them (assuming all are named the same save those numbers)

# This is where the file search should go

# This is where the sort should go

# This should be the first file in the list instead of a constant
filename = "sample file of goodness 0009.tga"

# Grab three groups:
# First group:  everything up to the second group
# Second group: everything that is a number (0-9 contiguous)
# Last group:   everything that isn't a number, to the end
# Note: 
#   The first capture group only works because of the '$'
#   Without it, it would fail.
m = re.search("(.*?)([0-9]*)([^0-9]*)$", filename)
filename = m.group(0)
startnum = m.group(1)
fileext  = m.group(3)

filecount = 0 # The number of files we'll be renaming

for newnum in range(1 to filecount):
	oldnum = newnum + startnum
	old = filename + oldnum + fileext
	new = filename + newnum + fileext 
	os.rename(old, new)

# Since I never remember the stupid syntax, here it be

# For loops
echo "For loopage"
for a in 1 2 3 4 5 6 7 8 9 0
do
	echo $a
done

echo
echo "Single Line"
# Single line goodness
for a in `ls`; do echo "File: $a"; done

echo
echo "Do the math while enjoying life"
a=5
while [[ a -gt 2 ]]
do
	echo $a
	a=$(($a - 1))
done

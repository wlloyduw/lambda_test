var1=$1
if [[ ! -z $var1 && $var1 -eq 1 ]]
then
  echo "var1 is present and equal to 1"
else
  echo "var1 is not present, or it may be present and not equal to 1"
fi

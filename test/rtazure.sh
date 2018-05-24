# total runs to perform
totalruns=$1

# time to sleep in seconds between runs
sleep=$2

./partest.sh 100 100 | tail -n 2

for (( i=2 ; i <= $totalruns; i++ ))
do
  #echo "Run #$i-----------------------------------------------------------------------------"
  #echo -n "sleeping for $sleep seconds - press ctrl-C to exit"
  for (( j=1 ; j <= $sleep; j++ ))
  do
    sleep 1
    #echo -n "."
  done
  #echo ""
  ./partest.sh 100 100 | tail -n 1
done


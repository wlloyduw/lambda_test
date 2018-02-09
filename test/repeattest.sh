# total runs to perform
totalruns=1

# time to sleep in seconds between runs
sleep=$1

for (( i=1 ; i <= $totalruns; i++ ))
do
  echo "Run #$i-----------------------------------------------------------------------------"
  ./partest.sh 100 100
  echo -n "sleeping for $sleep seconds - press ctrl-C to exit"
  for (( j=1 ; j <= $sleep; j++ ))
  do
    #sleep 1
    echo -n "."
  done
  echo ""
done


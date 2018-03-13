# total runs to perform
totalruns=1

# time to sleep in seconds between runs
sleep_param=$1

for (( i=1 ; i <= $totalruns; i++ ))
do
  echo "Run #$i-----------------------------------------------------------------------------"
  ./partest.sh 100 100 2 2 | tail -n 1 >> .myruns
  echo -n "sleeping for $sleep_param seconds - press ctrl-C to exit"
  sleep $sleep_param
  #for (( j=1 ; j <= $sleep_param; j++ ))
  #do
   # sleep 1
   # echo -n "."
  #done
 # echo ""
done

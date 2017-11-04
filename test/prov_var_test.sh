totalruns=10
echo "Provisioning variation test..."
date
  for (( i=1 ; i <= $totalruns; i++ ))
  do
    echo "run #$i"
    # throw me away - cold test
    echo "cold test $i"
    ./partest.sh 3000 3000 > colddump_$i
    echo "sleeping for 1 minute..."
    sleep 60    # sleep for 1 minute before warm test
    echo "warm test $i"
    ./partest.sh 3000 3000 > prov_var_$i.csv
    echo "sleeping for 45 minutes..."
    sleep 2700  # sleep for 45 minutes
  done


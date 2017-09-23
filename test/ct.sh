totalruns=10
for (( i=1 ; i <= $totalruns; i++ ))
do
  ./partest.sh 100 100
  sleep 10
done

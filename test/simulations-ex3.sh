# total runs to perform
#rm -f .myruns
totalEx3Runs=5

# API Gateway endpoint
apigateway=$1

echo "[simulations-ex3.sh] Running ex3.sh using API Gateway: " $apigateway

for (( i=1 ; i <= $totalEx3Runs; i++ ))
do
  echo "[simulations-ex3.sh] Run #$i for ex3.sh -----------------------------------------------------------------------"
  ./ex3.sh $apigateway
done


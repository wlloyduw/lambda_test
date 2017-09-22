#!/bin/bash
# 10 Colds
tencolds() {
totalruns=$2
memory=$1
for (( i=1 ; i <= $totalruns; i++ ))
do
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
aws lambda update-function-configuration --function-name test --memory-size=$memory
sleep 10
./partest.sh 100 100
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
done
}
export -f tencolds

warm() {
totalruns=$1
for (( i=1 ; i <= $totalruns; i++ ))
do
sleep 10
./partest.sh 100 100
done
}
export -f warm

echo "FIRST WILL CONDUCT ALL COLD RUNS, TESTING IMPACT OF CONTAINER CREATION WITH INCREASING MEM SIZE"
echo "Ten cold runs, 128mb-----------------------------------------------------------------------------------------"
tencolds 128 10
echo "Ten cold runs, 256mb-----------------------------------------------------------------------------------------"
tencolds 256 10
echo "Ten cold runs, 384mb-----------------------------------------------------------------------------------------"
tencolds 384 10
echo "Ten cold runs, 512mb-----------------------------------------------------------------------------------------"
tencolds 512 10
echo "Ten cold runs, 640mb-----------------------------------------------------------------------------------------"
tencolds 640 10
echo "Ten cold runs, 768mb-----------------------------------------------------------------------------------------"
tencolds 768 10
echo "Ten cold runs, 896mb-----------------------------------------------------------------------------------------"
tencolds 896 10
echo "Ten cold runs, 1024mb-----------------------------------------------------------------------------------------"
tencolds 1024 10
echo "Ten cold runs, 1152mb-----------------------------------------------------------------------------------------"
tencolds 1152 10
echo "Ten cold runs, 1280mb-----------------------------------------------------------------------------------------"
tencolds 1280 10
echo "Ten cold runs, 1408mb-----------------------------------------------------------------------------------------"
tencolds 1408 10
echo "Ten cold runs, 1536mb-----------------------------------------------------------------------------------------"
tencolds 1536 10

echo "Ten warm - warmup run 128mb"
tencolds 128 1
echo "TEN WARM - WARM RUNS 128 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 256mb"
tencolds 256 1
echo "TEN WARM - WARM RUNS 256 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 384mb"
tencolds 384 1
echo "TEN WARM - WARM RUNS 384 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 512mb"
tencolds 512 1
echo "TEN WARM - WARM RUNS 512 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 640mb"
tencolds 640 1
echo "TEN WARM - WARM RUNS 640 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 768mb"
tencolds 768 1
echo "TEN WARM - WARM RUNS 768 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 896mb"
tencolds 896 1
echo "TEN WARM - WARM RUNS 896 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 1024mb"
tencolds 1024 1
echo "TEN WARM - WARM RUNS 1024 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 1152mb"
tencolds 1152 1
echo "TEN WARM - WARM RUNS 1152 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 1280mb"
tencolds 1280 1
echo "TEN WARM - WARM RUNS 1280 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 1408mb"
tencolds 1408 1
echo "TEN WARM - WARM RUNS 1408 MB-------------------------------------------------------------------------------"
warm 10
echo "Ten warm - warmup run 1536mb"
tencolds 1536 1
echo "TEN WARM - WARM RUNS 1536 MB-------------------------------------------------------------------------------"
warm 10






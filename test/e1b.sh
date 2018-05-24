# experiment #1 test script
# requires aws cli installation
#
# steps to configure aws cli on ubuntu:
# sudo apt update
# sudo apt install python-pip
# pip install awscli --upgrade --user
# aws configure
#
# to run in background: "./e1.sh > e1.out 2> e1.err &"
# then "tail -fn 100 e1.out"
#
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
#aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 1 1 > o1.csv
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 2 2 > o2.csv
#aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 3 3 > o3.csv
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null
sleep 10
./partest.sh 4 4 > o4.csv
#aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 5 5 > o5.csv
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null
sleep 10
./partest.sh 6 6 > o6.csv
#aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 7 7 > o7.csv
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 8 8 > o8.csv
#aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 9 9 > o9.csv
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 10 10 > o10.csv
#aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
#exit
./partest.sh 20 20 > o11.csv
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 30 30 > o12.csv
#aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 40 40 > o13.csv
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 50 50 > o14.csv
#aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 60 60 > o15.csv
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 70 70 > o16.csv
#aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 80 80 > o17.csv
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 90 90 > o18.csv
#aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 100 100 > o19.csv
#aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 

tail -n 2 o1.csv
for ((i=2; i<=19; i++)); do
  tail -n 1 o$i.csv
done

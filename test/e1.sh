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
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 1 1
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 2 2
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 3 3
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null
sleep 10
./partest.sh 4 4
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 5 5
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null
sleep 10
./partest.sh 6 6
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 7 7
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 8 8
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 9 9
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 10 10
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
#exit
./partest.sh 20 20
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 30 30
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 40 40
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 50 50
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 60 60
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 70 70
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 80 80
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 
sleep 10
./partest.sh 90 90
aws lambda update-function-configuration --function-name test --timeout 300 > /dev/null
sleep 10
./partest.sh 100 100
aws lambda update-function-configuration --function-name test --timeout 240 > /dev/null 

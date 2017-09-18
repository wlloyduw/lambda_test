#!/bin/bash
makejar() {
  # change jar each time
  NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo $NEW_UUID >> tmp/com/amazonaws/services/lambda/runtime/random.txt
  cd tmp
  zip -r ../new_1.jar *
  cd ..
}
export -f makejar

#uncompress zip to allow rebuilding each time
rm -rf tmp
mkdir tmp
cd tmp
unzip ../lambda_test-1.0-SNAPSHOT.jar
cd ..

# experiment #1
aws lambda update-function-configuration --function-name test --timeout 240 
aws lambda update-function-configuration --function-name test --timeout 300
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 1 1
aws lambda update-function-configuration --function-name test --timeout 240 
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 2 2
aws lambda update-function-configuration --function-name test --timeout 300
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 3 3
aws lambda update-function-configuration --function-name test --timeout 240
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 4 4
aws lambda update-function-configuration --function-name test --timeout 300
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 5 5
aws lambda update-function-configuration --function-name test --timeout 240
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 6 6
aws lambda update-function-configuration --function-name test --timeout 300
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 7 7
aws lambda update-function-configuration --function-name test --timeout 240 
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 8 8
aws lambda update-function-configuration --function-name test --timeout 300
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 9 9
aws lambda update-function-configuration --function-name test --timeout 240 
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 10 10
exit
aws lambda update-function-configuration --function-name test --timeout 300
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 20 20
aws lambda update-function-configuration --function-name test --timeout 240 
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 30 30
aws lambda update-function-configuration --function-name test --timeout 300
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 40 40
aws lambda update-function-configuration --function-name test --timeout 240 
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 50 50
aws lambda update-function-configuration --function-name test --timeout 300
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 60 60
aws lambda update-function-configuration --function-name test --timeout 240 
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 70 70
aws lambda update-function-configuration --function-name test --timeout 300
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 80 80
aws lambda update-function-configuration --function-name test --timeout 240 
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 90 90
aws lambda update-function-configuration --function-name test --timeout 300
makejar
aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar
sleep 10
./partest.sh 100 100
#aws lambda update-function-configuration --function-name test --timeout 240 
#aws lambda update-function-code --function-name test --zip-file fileb://new_1.jar

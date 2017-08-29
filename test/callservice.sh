#!/bin/bash

json={"\"name\"":\"\/proc\/2\/stat\"",\"calcs\"":100000,\"sleep\"":0,\"loops\"":20}

#call using curl 
#curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null 

#call from aws gateway api
#aws apigateway test-invoke-method --rest-api-id ue5e0irnce --resource-id dlxjg7 --http-method POST --path-with-query-string '/test' --body $json

#call from aws lambda cli
aws lambda invoke --invocation-type RequestResponse --function-name test --region us-east-1 --log-type Tail --payload '{"calcs":100000,"sleep":0,"loops":20}' out.txt


exit


totalruns=$1
threads=$2

callservice() {
  totalruns=$1
  threadid=$2
  #host=10.0.0.124
  #port=8080
  onesecond=1000
  if [ $threadid -eq 1 ]
  then
    echo "run_id,thread_id,uuid,elapsed_time,sleep_time_ms"
  fi
  for (( i=1 ; i <= $totalruns; i++ ))
  do
    json={"\"name\"":\"Fred\"",\"calcs\"":100,\"sleep\"":10,\"loops\"":10}
    time1=( $(($(date +%s%N)/1000000)) )
    #uuid=`curl -H "Content-Type: application/json" -X POST -d "{\"name\": \"Fred\"}" https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null | cut -d':' -f 3 | cut -d'"' -f 2` 
    uuid=`curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null | cut -d':' -f 3 | cut -d'"' -f 2` 
    time2=( $(($(date +%s%N)/1000000)) )
    elapsedtime=`expr $time2 - $time1`
    sleeptime=`echo $onesecond - $elapsedtime | bc -l`
    sleeptimems=`echo $sleeptime/$onesecond | bc -l`
    echo "$i,$threadid,$uuid,$elapsedtime,$sleeptimems"
    if (( $sleeptime > 0 ))
    then
      sleep $sleeptimems
    fi
  done
}
export -f callservice

runsperthread=`echo $totalruns/$threads | bc -l`
runsperthread=${runsperthread%.*}
date
echo "Setting up test: runsperthread=$runsperthread threads=$threads totalruns=$totalruns"
for (( i=1 ; i <= $threads ; i ++))
do
  arpt+=($runsperthread)
done
parallel --no-notice -j $threads -k callservice {1} {#} ::: "${arpt[@]}"






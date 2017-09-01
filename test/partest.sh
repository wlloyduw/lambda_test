#!/bin/bash
totalruns=$1
threads=$2
containers=()
cuses=()

callservice() {
  totalruns=$1
  threadid=$2
  #host=10.0.0.124
  #port=8080
  onesecond=1000
  if [ $threadid -eq 1 ]
  then
    echo "run_id,thread_id,uuid,pid,cpuusr,cpukrn,elapsed_time,sleep_time_ms"
  fi
  for (( i=1 ; i <= $totalruns; i++ ))
  do
    #CALCS - uncomment JSON line for desired number of calcs
    #no calcs
    json={"\"name\"":\"\"",\"calcs\"":0,\"sleep\"":0,\"loops\"":0}

    #very light calcs
    #json={"\"name\"":\"\"",\"calcs\"":100,\"sleep\"":0,\"loops\"":20}

    #light calcs 
    #json={"\"name\"":\"\"",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}

    #medium calcs 
    #json={"\"name\"":\"\"",\"calcs\"":10000,\"sleep\"":0,\"loops\"":20}

    #somewhat heavy calcs 
    #json={"\"name\"":\"\"",\"calcs\"":25000,\"sleep\"":0,\"loops\"":20}

    #heavy calcs 
    #json={"\"name\"":\"\"",\"calcs\"":100000,\"sleep\"":0,\"loops\"":20}

    time1=( $(($(date +%s%N)/1000000)) )
    #uuid=`curl -H "Content-Type: application/json" -X POST -d "{\"name\": \"Fred\"}" https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null | cut -d':' -f 3 | cut -d'"' -f 2` 
    output=`curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null`
    #output=`curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null | cut -d':' -f 3 | cut -d'"' -f 2` 
    uuid=`echo $output | cut -d':' -f 3 | cut -d'"' -f 2`
    cpuusr=`echo $output | cut -d':' -f 4 | cut -d',' -f 1`
    cpukrn=`echo $output | cut -d':' -f 5 | cut -d',' -f 1`
    pid=`echo $output | cut -d':' -f 6 | cut -d',' -f 1`
    
    time2=( $(($(date +%s%N)/1000000)) )
    elapsedtime=`expr $time2 - $time1`
    sleeptime=`echo $onesecond - $elapsedtime | bc -l`
    sleeptimems=`echo $sleeptime/$onesecond | bc -l`
    echo "$i,$threadid,$uuid,$pid,$cpuusr,$cpukrn,$elapsedtime,$sleeptimems"
    echo "$uuid" >> .uniqcont
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
#exit

# determine unique number of containers used or created
filename=".uniqcont"
while read -r line
do
    uuid="$line"
    #echo "Uuid read from file - $uuid"
    # if uuid is already in array
    found=0
    for ((i=0;i < ${#containers[@]};i++)) {
        if [ "${containers[$i]}" == "${uuid}" ]; then
            (( cuses[$i]++ ))
            found=1
        fi
    }
    if [ $found != 1 ]; then
        containers+=($uuid)
        cuses+=(1)
    fi
    #if [[ " ${containers[@]} " =~ " ${uuid} " ]]; then
    #  containers+=($uuid)
    #fi
    # add element to array if not already in array
    #if [[ ! " ${containers[@]} " =~ " ${uuid} " ]]; then
    #  containers+=($uuid)
    #fi
done < "$filename"
echo "Containers=${#containers[@]}"
rm .uniqcont
echo "uuid,uses"
for ((i=0;i < ${#containers[@]};i++)) {
  echo "${containers[$i]},${cuses[$i]}"
}






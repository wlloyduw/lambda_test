#!/bin/bash
totalruns=$1
threads=$2
containers=()
cuses=()
ctimes=()

callservice() {
  totalruns=$1
  threadid=$2
  #host=10.0.0.124
  #port=8080
  onesecond=1000
  if [ $threadid -eq 1 ]
  then
    echo "run_id,thread_id,uuid,cputype,cpusteal,vmuptime,pid,cpuusr,cpukrn,elapsed_time,sleep_time_ms"
  fi
  for (( i=1 ; i <= $totalruns; i++ ))
  do
    #CALCS - uncomment JSON line for desired number of calcs
    #no calcs
    #json={"\"name\"":\"\"",\"calcs\"":0,\"sleep\"":0,\"loops\"":0}
    #json={"\"name\"":\"\/proc\/cpuinfo\"",\"calcs\"":0,\"sleep\"":0,\"loops\"":0}

    #very light calcs
    #json={"\"name\"":\"\"",\"calcs\"":100,\"sleep\"":0,\"loops\"":20}

    #light calcs 
    #json={"\"name\"":\"\"",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
    #json={"\"name\"":\"\/proc\/cpuinfo\"",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}

    #medium calcs 
    #json={"\"name\"":\"\"",\"calcs\"":10000,\"sleep\"":0,\"loops\"":20}
    #json={"\"name\"":\"\/proc\/cpuinfo\"",\"calcs\"":10000,\"sleep\"":0,\"loops\"":20}

    #somewhat heavy calcs 
    #json={"\"name\"":\"\"",\"calcs\"":25000,\"sleep\"":0,\"loops\"":20}
    #json={"\"name\"":\"\/proc\/cpuinfo\"",\"calcs\"":25000,\"sleep\"":0,\"loops\"":20}

    #heavy calcs 
    #json={"\"name\"":\"\"",\"calcs\"":100000,\"sleep\"":0,\"loops\"":20}
    #json={"\"name\"":\"\/proc\/cpuinfo\"",\"calcs\"":100000,\"sleep\"":0,\"loops\"":20}

    #many calcs no mem - results in more kernel time
    #json={"\"name\"":\"\"",\"calcs\"":20,\"sleep\"":0,\"loops\"":500000}
    #json={"\"name\"":\"\/proc\/cpuinfo\"",\"calcs\"":20,\"sleep\"":0,\"loops\"":500000}

    #many calcs low mem
    #json={"\"name\"":\"\"",\"calcs\"":100,\"sleep\"":0,\"loops\"":100000}
    json={"\"name\"":\"\/proc\/cpuinfo\"",\"calcs\"":100,\"sleep\"":0,\"loops\"":100000}
    #json={"\"name\"":\"\/proc\/stat\"",\"calcs\"":100,\"sleep\"":0,\"loops\"":100000}

    #many calcs higher mem
    #json={"\"name\"":\"\"",\"calcs\"":10000,\"sleep\"":0,\"loops\"":1000}
    #json={"\"name\"":\"\/proc\/cpuinfo\"",\"calcs\"":10000,\"sleep\"":0,\"loops\"":1000}

    time1=( $(($(date +%s%N)/1000000)) )
    #uuid=`curl -H "Content-Type: application/json" -X POST -d "{\"name\": \"Fred\"}" https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null | cut -d':' -f 3 | cut -d'"' -f 2` 
    output=`curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null`
    #output=`curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null | cut -d':' -f 3 | cut -d'"' -f 2` 

    # parsing when /proc/cpuinfo is not requested  
    #uuid=`echo $output | cut -d':' -f 3 | cut -d'"' -f 2`
    #cpuusr=`echo $output | cut -d':' -f 4 | cut -d',' -f 1`
    #cpukrn=`echo $output | cut -d':' -f 5 | cut -d',' -f 1`
    #pid=`echo $output | cut -d':' -f 6 | cut -d',' -f 1`
    #cputype="unknwn"

    # parsing when /proc/stat is requested
    #uuid=`echo $output | cut -d',' -f 2 | cut -d':' -f 2 | cut -d'"' -f 2`
    #cpuusr=`echo $output | cut -d',' -f 3 | cut -d':' -f 2`
    #cpukrn=`echo $output | cut -d',' -f 4 | cut -d':' -f 2 | cut -d'"' -f 2`
    #pid=`echo $output | cut -d',' -f 5 | cut -d':' -f 2 | cut -d'"' -f 2`
    #cpusteal=`echo $output | cut -d'"' -f 4 | cut -d' ' -f 9`
    #cputype="unknwn"
	
    # parsing when /proc/cpuinfo is requested
    uuid=`echo $output | cut -d',' -f 4 | cut -d':' -f 2 | cut -d'"' -f 2`
    cpuusr=`echo $output | cut -d',' -f 5 | cut -d':' -f 2`
    cpukrn=`echo $output | cut -d',' -f 6 | cut -d':' -f 2 | cut -d'"' -f 2`
    pid=`echo $output | cut -d',' -f 7 | cut -d':' -f 2 | cut -d'"' -f 2`
    cputype=`echo $output | cut -d',' -f 1 | cut -d':' -f 7 | cut -d'\' -f 1 | xargs`
    cpusteal=`echo $output | cut -d',' -f 15 | cut -d':' -f 2`
    vuptime=`echo $output | cut -d',' -f 16 | cut -d':' -f 2`
    
    time2=( $(($(date +%s%N)/1000000)) )
    elapsedtime=`expr $time2 - $time1`
    sleeptime=`echo $onesecond - $elapsedtime | bc -l`
    sleeptimems=`echo $sleeptime/$onesecond | bc -l`
    echo "$i,$threadid,$uuid,$cputype,$cpusteal,$vuptime,$pid,$cpuusr,$cpukrn,$elapsedtime,$sleeptimems"
    echo "$uuid,$elapsedtime" >> .uniqcont
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
    uuid=`echo $line | cut -d',' -f 1`
    time=`echo $line | cut -d',' -f 2`
    alltimes=`expr $alltimes + $time`
    #echo "Uuid read from file - $uuid"
    # if uuid is already in array
    found=0
    for ((i=0;i < ${#containers[@]};i++)) {
        if [ "${containers[$i]}" == "${uuid}" ]; then
            (( cuses[$i]++ ))
            ctimes[$i]=`expr ${ctimes[$i]} + $time`
            found=1
        fi
    }
    if [ $found != 1 ]; then
        containers+=($uuid)
        cuses+=(1)
        ctimes+=($time)
    fi
    #if [[ " ${containers[@]} " =~ " ${uuid} " ]]; then
    #  containers+=($uuid)
    #fi
    # add element to array if not already in array
    #if [[ ! " ${containers[@]} " =~ " ${uuid} " ]]; then
    #  containers+=($uuid)
    #fi
done < "$filename"
#echo "Containers=${#containers[@]}"
runspercont=`echo $totalruns / ${#containers[@]} | bc -l`
#echo "Runs per containers=$runspercont"
avgtime=`echo $alltimes / $totalruns | bc -l`
#echo "Average time=$avgtime"
rm .uniqcont
echo "uuid,uses,totaltime,avgruntime_cont,uses_minus_avguses_sq"
total=0
for ((i=0;i < ${#containers[@]};i++)) {
  avg=`echo ${ctimes[$i]} / ${cuses[$i]} | bc -l`
  stdiff=`echo ${cuses[$i]} - $runspercont | bc -l` 
  stdiffsq=`echo "$stdiff * $stdiff" | bc -l` 
  total=`echo $total + $stdiffsq | bc -l`
  #echo "$total + $stdiffsq"
  echo "${containers[$i]},${cuses[$i]},${ctimes[$i]},$avg,$stdiffsq"
  #echo "${containers[$i]},${cuses[$i]},$avg"
}
stdev=`echo $total / ${#containers[@]} | bc -l`
echo "containers,avgruntime,runs_per_container,stdev"
echo "${#containers[@]},$avgtime,$runspercont,$stdev"
#echo "Standard deviation (runs per container)=$stdev"
#echo "lower is better"






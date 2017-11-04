#!/bin/bash
# script requires gnu parallel package, and the bash calculator
#
# apt install parallel bc
#
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
    echo "run_id,thread_id,uuid,cputype,cpusteal,vmuptime,pid,cpuusr,cpukrn,elapsed_time,sleep_time_ms,new_container"
  fi
  for (( i=1 ; i <= $totalruns; i++ ))
  do
    #CALCS - uncomment JSON line for desired number of calcs
    #(0) - no calcs - 0
    json={"\"name\"":"\"\",\"calcs\"":0,\"sleep\"":0,\"loops\"":0}

    #(1) - very light calcs - 2,000
    #json={"\"name\"":"\"\",\"calcs\"":100,\"sleep\"":0,\"loops\"":20}

    #(2) - light calcs - 20,000
    #json={"\"name\"":"\"\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}

    #(3) - medium calcs 200,000 
    #json={"\"name\"":"\"\",\"calcs\"":10000,\"sleep\"":0,\"loops\"":20}

    #(4) - somewhat heavy calcs - 500,000
    #json={"\"name\"":"\"\",\"calcs\"":25000,\"sleep\"":0,\"loops\"":20}

    #(5) - heavy calcs - 2,000,000
    #json={"\"name\"":"\"\",\"calcs\"":100000,\"sleep\"":0,\"loops\"":20}

    #(6) - many calcs no memory stress - results in more kernel time - 6,000,000
    #json={"\"name\"":"\"\",\"calcs\"":20,\"sleep\"":0,\"loops\"":300000}

    #(7) - many calcs low memory stress - 10,000,000
    #json={"\"name\"":"\"\",\"calcs\"":100,\"sleep\"":0,\"loops\"":100000}

    #(8) - many calcs higher memory stress - 10,000,000
    #json={"\"name\"":"\"\",\"calcs\"":10000,\"sleep\"":0,\"loops\"":1000}

    #(9) - many calcs even higher memory stress - 10,000,000
    #json={"\"name\"":"\"\",\"calcs\"":100000,\"sleep\"":0,\"loops\"":100}

    time1=( $(($(date +%s%N)/1000000)) )
    #uuid=`curl -H "Content-Type: application/json" -X POST -d "{\"name\": \"Fred\"}" https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null | cut -d':' -f 3 | cut -d'"' -f 2` 
    ###output=`curl -H "Content-Type: application/json" -X POST -d  $json https://a9gseqxep9.execute-api.us-east-1.amazonaws.com/test2/test 2>/dev/null`
    ###output=`curl -H "Content-Type: application/json" -X POST -d  $json https://ctbiwxx3f3.execute-api.us-east-1.amazonaws.com/dev1 2>/dev/null`
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
    uuid=`echo $output | cut -d',' -f 2 | cut -d':' -f 2 | cut -d'"' -f 2`
    cpuusr=`echo $output | cut -d',' -f 3 | cut -d':' -f 2`
    cpukrn=`echo $output | cut -d',' -f 4 | cut -d':' -f 2 | cut -d'"' -f 2`
    pid=`echo $output | cut -d',' -f 5 | cut -d':' -f 2 | cut -d'"' -f 2`
    cputype="unknown"
    #cputype=`echo $output | cut -d',' -f 1 | cut -d':' -f 7 | cut -d'\' -f 1 | xargs`
    cpusteal=`echo $output | cut -d',' -f 13 | cut -d':' -f 2`
    vuptime=`echo $output | cut -d',' -f 14 | cut -d':' -f 2`
    newcont=`echo $output | cut -d',' -f 15 | cut -d':' -f 2`
    
    
    time2=( $(($(date +%s%N)/1000000)) )
    elapsedtime=`expr $time2 - $time1`
    sleeptime=`echo $onesecond - $elapsedtime | bc -l`
    sleeptimems=`echo $sleeptime/$onesecond | bc -l`
    echo "$i,$threadid,$uuid,$cputype,$cpusteal,$vuptime,$pid,$cpuusr,$cpukrn,$elapsedtime,$sleeptimems,$newcont"
    echo "$uuid,$elapsedtime,$vuptime,$newcont" >> .uniqcont
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
newconts=0

# determine unique number of containers used or created
filename=".uniqcont"
while read -r line
do
    uuid=`echo $line | cut -d',' -f 1`
    time=`echo $line | cut -d',' -f 2`
    host=`echo $line | cut -d',' -f 3`
    isnewcont=`echo $line | cut -d',' -f 4`
    alltimes=`expr $alltimes + $time`
    #echo "Uuid read from file - $uuid"
    # if uuid is already in array
    found=0
    (( newconts += isnewcont))
    for ((i=0;i < ${#containers[@]};i++)) {
        if [ "${containers[$i]}" == "${uuid}" ]; then
            (( cuses[$i]++ ))
            ctimes[$i]=`expr ${ctimes[$i]} + $time`
            found=1
        fi
    }
    if [ $found != 1 ]; then
        containers+=($uuid)
        chosts+=($host)
        cuses+=(1)
        ctimes+=($time)
    fi


    hfound=0
    for ((i=0;i < ${#hosts[@]};i++)) {
        if [ "${hosts[$i]}" == "${host}"  ]; then
            (( huses[$i]++ ))
            htimes[$i]=`expr ${htimes[$i]} + $time`
            hfound=1
        fi
    }
    if [ $hfound != 1 ]; then
        hosts+=($host)
        huses+=(1)
        htimes+=($time)
        #hcontainers+=($uuid)
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
runsperhost=`echo $totalruns / ${#hosts[@]} | bc -l`
#echo "Runs per containers=$runspercont"
avgtime=`echo $alltimes / $totalruns | bc -l`
#echo "Average time=$avgtime"
rm .uniqcont
echo "uuid,host,uses,totaltime,avgruntime_cont,uses_minus_avguses_sq"
total=0
for ((i=0;i < ${#containers[@]};i++)) {
  avg=`echo ${ctimes[$i]} / ${cuses[$i]} | bc -l`
  stdiff=`echo ${cuses[$i]} - $runspercont | bc -l` 
  stdiffsq=`echo "$stdiff * $stdiff" | bc -l` 
  total=`echo $total + $stdiffsq | bc -l`
  #echo "$total + $stdiffsq"
  echo "${containers[$i]},${chosts[$i]},${cuses[$i]},${ctimes[$i]},$avg,$stdiffsq"
  #echo "${containers[$i]},${cuses[$i]},$avg"
}
stdev=`echo $total / ${#containers[@]} | bc -l`
#echo "containers,avgruntime,runs_per_container,stdev"
#echo "${#containers[@]},$avgtime,$runspercont,$stdev"
# hosts info
currtime=$(date +%s)
echo "Current time of test=$currtime"
echo "host,host_up_time,uses,containers,totaltime,avgruntime_host,uses_minus_avguses_sq"
total=0
for ((i=0;i < ${#hosts[@]};i++)) {
  avg=`echo ${htimes[$i]} / ${huses[$i]} | bc -l`
  stdiff=`echo ${huses[$i]} - $runsperhost | bc -l` 
  stdiffsq=`echo "$stdiff * $stdiff" | bc -l` 
  total=`echo $total + $stdiffsq | bc -l`
  ccount=0
  uptime=`echo $currtime - ${hosts[$i]} | bc -l`
  for ((j=0;j < ${#containers[@]};j++)) {
      if [ ${hosts[$i]} == ${chosts[$j]} ]
      then
          (( ccount ++ ))
      fi
  } 
  echo "${hosts[$i]},$uptime,${huses[$i]},$ccount,${htimes[$i]},$avg,$stdiffsq"
}
stdevhost=`echo $total / ${#hosts[@]} | bc -l`
#echo "hosts,avgruntime,runs_per_host,stdev"
#echo "${#hosts[@]},$avgtime,$runsperhost,$stdev"
echo "containers,newcontainers,hosts,avgruntime,runs_per_container,runs_per_cont_stdev,runs_per_host,runs_per_host_stdev"
echo "${#containers[@]},$newconts,${#hosts[@]},$avgtime,$runspercont,$stdev,$runsperhost,$stdevhost"



#echo "Standard deviation (runs per container)=$stdev"
#echo "lower is better"

# determine unique number of hosts used
#filename=".uniqhost"
#while read -r line
#do
#    vm=`echo $line | cut -d',' -f 1`
#    uuid=`echo $line | cut -d',' -f 1`
#    time=`echo $line | cut -d',' -f 1`
#done < "$filename"







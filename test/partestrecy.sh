#!/bin/bash
# script requires gnu parallel package, and the bash calculator
#
# apt install parallel bc
#
totalruns=$1
threads=$2
vmreport=$3
contreport=$4
containers=()
cuses=()
ctimes=()

#########################################################################################################################################################
#  callservice method - uses separate threads to call AWS Lambda in parallel
#  each thread captures results of one service request, and outputs CSV data...
#########################################################################################################################################################
callservice() {
  totalruns=$1
  threadid=$2
  #host=10.0.0.124
  #port=8080
  onesecond=1000
  filename="parurl"
  while read -r line
  do
    parurl=$line
  done < "$filename"

  if [ $threadid -eq 1 ]
  then
    echo "run_id,thread_id,uuid,cputype,cpusteal,vmuptime,pid,cpuusr,cpukrn,elapsed_time,sleep_time_ms,new_container"
  fi
  for (( i=1 ; i <= $totalruns; i++ ))
  do
    #CALCS - uncomment JSON line for desired number of calcs
    #(0) - no calcs - 0
    #json={"\"name\"":"\"\",\"calcs\"":0,\"sleep\"":0,\"loops\"":0}

    #(1) - very light calcs - 2,000
    #json={"\"name\"":"\"\",\"calcs\"":100,\"sleep\"":0,\"loops\"":20}

    #(2) - light calcs - 20,000
    #json={"\"name\"":"\"\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}

    #(3) - medium calcs 200,000 
    #json={"\"name\"":"\"\",\"calcs\"":10000,\"sleep\"":0,\"loops\"":20}

    #(4) - somewhat heavy calcs - 500,000
    #json={"\"name\"":"\"\",\"calcs\"":25000,\"sleep\"":0,\"loops\"":20}

    #(5) - heavy calcs - 2,000,000
    json={"\"name\"":"\"\",\"calcs\"":100000,\"sleep\"":0,\"loops\"":20}

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
    ####output=`curl -H "Content-Type: application/json" -X POST -d  $json https://a9gseqxep9.execute-api.us-east-1.amazonaws.com/test2/test 2>/dev/null`
    ###output=`curl -H "Content-Type: application/json" -X POST -d  $json https://ctbiwxx3f3.execute-api.us-east-1.amazonaws.com/dev1 2>/dev/null`
    output=`curl -H "Content-Type: application/json" -X POST -d  $json $parurl 2>/dev/null`
    #output=`curl -H "Content-Type: application/json" -X POST -d  $json https://b3euo2n6s7.execute-api.us-east-1.amazonaws.com/test 2>/dev/null`
    ########################output=`curl -H "Content-Type: application/json" -X POST -d  $json https://i1dc63pzgh.execute-api.us-east-1.amazonaws.com/test5/ 2>/dev/null`
    #output=`curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null | cut -d':' -f 3 | cut -d'"' -f 2` 

    # grab time
    time2=( $(($(date +%s%N)/1000000)) )

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

#########################################################################################################################################################
#  The START of the Script
#########################################################################################################################################################
runsperthread=`echo $totalruns/$threads | bc -l`
runsperthread=${runsperthread%.*}
date
echo "Setting up test: runsperthread=$runsperthread threads=$threads totalruns=$totalruns"
for (( i=1 ; i <= $threads ; i ++))
do
  arpt+=($runsperthread)
done
#########################################################################################################################################################
# Launch threads to call AWS Lambda in parallel
#########################################################################################################################################################
parallel --no-notice -j $threads -k callservice {1} {#} ::: "${arpt[@]}"
#exit
newconts=0
recycont=0
recyvms=0

#########################################################################################################################################################
# Begin post-processing and generation of CSV output sections
#########################################################################################################################################################


#########################################################################################################################################################
# Generate CSV output - group by container
# Reports unique number of containers used or created
#########################################################################################################################################################
if [[ ! -z $contreport && $contreport -eq 1 ]]
    then
      rm -f .origcont
fi

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


    ##
    ## Process the contreport flag, to generate or compare against the .origcont file
    ##
    ## if state = 1 initialize file
     # if [[ ! -z $contreport && $contreport -eq 1 ]]
     # then
      #  echo "$uuid" >> .origcont
     # fi


    # Populate array of unique containers
    for ((i=0;i < ${#containers[@]};i++)) {
        if [ "${containers[$i]}" == "${uuid}" ]; then
            (( cuses[$i]++ ))
            ctimes[$i]=`expr ${ctimes[$i]} + $time`
            found=1
        fi
    }

    ## Add unfound container to array
    if [ $found != 1 ]; then
        containers+=($uuid)
        chosts+=($host)
        cuses+=(1)
        ctimes+=($time)
    fi

    # Populate array of unique hosts
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

##
##  Determine count of recycled containers...
##
#echo "ARRAY SIZE EQUAL ${#containers[@]} "
# Append containers to .origcont file with contreport flag set to 1...
if [[ ! -z $contreport && $contreport -eq 1 ]]
then
  for ((i=0;i < ${#containers[@]};i++)) {
    echo "${containers[$i]}" >> .origcont
  }  
fi

## if state = 2 compare against file to obtain total count of recycled containers used
if [[ ! -z $contreport && $contreport -eq 2 ]]
then
  for ((i=0;i < ${#containers[@]};i++)) 
  {
    # read the origcont file and compare current containers to old containers in .origcont
    # increment a counter every time we find a recycled container
    # to calculate newcontainer, containers - recycledcontainers
    filename=".origcont"
    while read -r line
    do
      if [ "${containers[$i]}" == "${line}" ]
      then
          (( recycont ++ ))
          break;
      fi
    done < "$filename"
  }
fi

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

#########################################################################################################################################################
# Generate CSV output - group by VM host
# hosts[] is the array of VM ids - where the VM id is the boot time in seconds since epoch (Jan 1 1970)
#########################################################################################################################################################

stdev=`echo $total / ${#containers[@]} | bc -l`
#echo "containers,avgruntime,runs_per_container,stdev"
#echo "${#containers[@]},$avgtime,$runspercont,$stdev"
# hosts info
currtime=$(date +%s)
echo "Current time of test=$currtime"
echo "host,host_up_time,uses,containers,totaltime,avgruntime_host,uses_minus_avguses_sq"
total=0
if [[ ! -z $vmreport && $vmreport -eq 1 ]]
then
  rm -f .origvm 
fi

# Loop through list of hosts - generate summary data
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

  ##  Determine count of recycled hosts...
  ## 
  ##  Generate .origvm file to support determing infrastructure recycling stats
  ##
  if [[ ! -z $vmreport && $vmreport -eq 1 ]] 
  then
    echo "${hosts[$i]}" >> .origvm 
  fi
  if [[ ! -z $vmreport && $vmreport -eq 2 ]]
  then
    ##echo "compare vms - check for recycling"
    # read the file and compare current VMs to old VMs in .origvm
    # increment a counter every time we find a recycled VM
    # to calculate newhosts, hosts - recycledhosts
    filename=".origvm"
    while read -r line
    do
      ##echo "compare '${hosts[$i]}' == '${line}'"
      if [ ${hosts[$i]} == ${line} ]
      then
          (( recyvms ++ ))
          break;
      fi
    done < "$filename"
  fi
}
stdevhost=`echo $total / ${#hosts[@]} | bc -l`

#########################################################################################################################################################
# Generate CSV output - report summary, final data
#########################################################################################################################################################
#
# 
#
echo "containers,newcontainers,recycont,hosts,recyvms,avgruntime,runs_per_container,runs_per_cont_stdev,runs_per_host,runs_per_host_stdev"
echo "${#containers[@]},$newconts,$recycont,${#hosts[@]},$recyvms,$avgtime,$runspercont,$stdev,$runsperhost,$stdevhost"








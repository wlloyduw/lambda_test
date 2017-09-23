threads=$1
memory=$2
cpu=$3

parcont() {
  memory=$2
  cpu=$3
  threadid=$1
  threads=$4 
  onesecond=1000
  #echo "in parcont... $cpu $memory"
  if [ $threadid -eq 1 ]
  then
    aa=1
    #echo "thread_id,memory,cpu,elapsed_time,sleep_time_ms,threads"
  fi
  contname="mytest$threadid"
  docker run --name $contname -m $memory --cpus=$cpu --rm lambdatest >/dev/null 2>/dev/null & #java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20 >/dev/null 2>/dev/null
  sleep 1
  time1=( $(($(date +%s%N)/1000000)) )
  docker exec $contname bash -c 'java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20' > /dev/null 2>/dev/null
  time2=( $(($(date +%s%N)/1000000)) )
  elapsedtime=`expr $time2 - $time1`
  sleeptime=`echo $onesecond - $elapsedtime | bc -l`
  sleeptimems=`echo $sleeptime/$onesecond | bc -l`
  echo "$threadid,$memory,$cpu,$elapsedtime,$sleeptimems,$threads"
  if (( $sleeptime > 0 ))
  then
    sleep $sleeptimems
  fi
  docker exec $contname bash -c 'touch /stop'
}
export -f parcont

docker build -t lambdatest -f Dockerfile . >/dev/null

#time docker run -it --rm lambdatest 
#docker run -it -m 128m --rm lambdatest java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20

for (( i=1 ; i <= $threads ; i ++))
do
  arpt+=(1)
  #arpt+=($runsperthread)
done

parallel --no-notice -j $threads -k parcont {#} $memory $cpu $threads ::: "${arpt[@]}"
#parallel --no-notice -j $threads -k parcont {#}
#sleep 10

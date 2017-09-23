threads=$1
memory=$2
cpu=$3

parcont() {
  memory=$2
  cpu=$3
  threadid=$1
  onesecond=1000
  #echo "in parcont... $cpu $memory"
  if [ $threadid -eq 1 ]
  then
    echo "thread_id,elapsed_time,sleep_time_ms"
  fi

  time1=( $(($(date +%s%N)/1000000)) )
  docker run -m $memory --cpus=$cpu --rm lambdatest java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20 >/dev/null 2>/dev/null
  #docker run -it -m $memory --cpus=$cpu lambdatest java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20 2>/dev/null
  #sleep .1
  time2=( $(($(date +%s%N)/1000000)) )
  elapsedtime=`expr $time2 - $time1`
  sleeptime=`echo $onesecond - $elapsedtime | bc -l`
  sleeptimems=`echo $sleeptime/$onesecond | bc -l`
  echo "$threadid,$elapsedtime,$sleeptimems,$newcont"
  if (( $sleeptime > 0 ))
  then
    sleep $sleeptimems
  fi
}
export -f parcont

docker build -t lambdatest . >/dev/null

#time docker run -it --rm lambdatest 
#docker run -it -m 128m --rm lambdatest java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20

for (( i=1 ; i <= $threads ; i ++))
do
  arpt+=(1)
  #arpt+=($runsperthread)
done

parallel --no-notice -j $threads -k parcont {#} $memory $cpu ::: "${arpt[@]}"
#parallel --no-notice -j $threads -k parcont {#}
#sleep 10

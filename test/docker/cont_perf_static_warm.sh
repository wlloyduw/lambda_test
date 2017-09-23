parcont() {
  memory=$1
  cpu=$2
#  for (( i=1 ; i <= $threads ; i ++))
#  do
    ./run_cont_par_warm.sh $threads $memory $cpu
    sleep 10
#  done
}
export -f parcont

threads=$1

echo "thread_id,memory,cpu,elapsed_time,sleep_time_ms,threads"

parcont 128m .166
parcont 256m .333
parcont 384m .5
parcont 512m .666
parcont 640m .833
parcont 768m 1
parcont 896m 1.167
parcont 1024m 1.333
parcont 1152m 1.5
parcont 1280m 1.666
parcont 1408m 1.833
parcont 1536m 2




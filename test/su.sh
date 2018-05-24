sleep 10 ; ./partestrecyjq.sh 24 24 2 2 | tail -n 2
for i in {25..50}
do
  sleep 10 ; ./partestrecyjq.sh $i $i 2 2 | tail -n 1
done

# Can have up to 5 triggers for each event
events=$1
targets=$2

if [ -z ${events} ] || [ -z ${targets} ] 
then
  echo ""
  echo "USAGE: "
  echo "./delete_events.sh (number_of_cloudwatch_events) (number_of_targets_per_event) "
  echo ""
  echo "Deletes cloudwatch events and their associated targets for AWS Lambda functions"
  echo ""
  echo "Provide parameters without quotation marks."
  echo ""
  exit
fi

echo -n "Deleting events and associated rules for event #"
for (( i=1 ; i <= $events; i++ ))
do
  for (( j=1 ; j <= $targets; j++ ))
  do
    aws events remove-targets --rule rule$i --ids target_rule$i$j
    echo -n ""
  done
  aws events delete-rule --name $i
  echo -n "$i "
done
echo ""

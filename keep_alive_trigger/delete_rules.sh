# Can have up to 5 targets for each event
events=$1
targets=$2

if [ -z ${events} ] || [ -z ${targets} ] 
then
  echo ""
  echo "USAGE: "
  echo "./delete_events.sh (number_of_cloudwatch_event_rules) (number_of_targets_per_rule) "
  echo ""
  echo "Deletes cloudwatch event rules and their associated targets for AWS Lambda functions"
  echo ""
  echo "Provide parameters without quotation marks."
  echo ""
  exit
fi

echo -n "Deleting CloudWatch event rules and associated targets for rule #"
for (( i=1 ; i <= $events; i++ ))
do
  for (( j=1 ; j <= $targets; j++ ))
  do
    aws events remove-targets --rule rule$i --ids target_rule$j
    echo -n ""
  done
  aws events delete-rule --name rule$i
  echo -n "$i "
done
echo ""

# Can have up to 5 targets for each CloudWatch event rule.
events=$1      # the number of CloudWatch Events to put
if [ -z ${events} ] 
then
  echo ""
  echo "USAGE:"
  echo "./create_events.sh (number_of_events)"
  echo ""
  echo "Puts arbitrary CloudWatch events to CloudWatch"
  echo ""
  echo "Provide parameters without quotation marks."
  echo ""
  exit
fi

echo -n "Putting $events CloudWatch events." 
echo ""
for (( i=1 ; i <= $events; i++ ))
do
  aws events put-events --entries file://putevents.json
done
echo ""
echo "Completed."

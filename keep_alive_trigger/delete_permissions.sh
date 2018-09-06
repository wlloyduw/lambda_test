# Can have up to 5 triggers for each event
lambdaname=$1
events=$2

if [ -z ${lambdaname} ] || [ -z ${events} ] 
then
  echo ""
  echo "USAGE: "
  echo "./delete_permissions.sh (lambda_function_name) (number_of_cloudwatch_events) "
  echo ""
  echo "Deletes cloudwatch event execute permissions for AWS Lambda functions"
  echo ""
  echo "Provide parameters without quotation marks."
  echo ""
  exit
fi

echo -n "Deleting permission #"
for (( i=1 ; i <= $events; i++ ))
do
  aws lambda remove-permission --function-name $lambdaname --statement-id rulepermission$i
  echo -n "$i "
done
echo ""

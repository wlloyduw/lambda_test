# Can have up to 5 triggers for each event
lambdaname=$1

if [ -z ${lambdaname} ] 
then
  echo ""
  echo "USAGE: "
  echo "./delete_permission.sh (lambda_function_name) "
  echo ""
  echo "Deletes cloudwatch event execute permissions for specified AWS Lambda function"
  echo ""
  echo "Provide parameters without quotation marks."
  echo ""
  exit
fi

echo -n "Deleting cloudwatch event permission to lambda function: $lambdaname"
aws lambda remove-permission --function-name $lambdaname --statement-id cloud_watch_event_permission
echo ""

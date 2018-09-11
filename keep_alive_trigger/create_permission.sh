# Can have up to 5 triggers for each event
lambdaname=$1
account_id=$2
#json="{'name':'','calcs':0,'sleep':7000,'loops':0}"
json="{"\"name\"":"\"\",\"calcs\"":0,\"sleep\"":7000,\"loops\"":0}"
#json='{"name":"","calcs":0,"sleep":7000,"loops":0}'
if [ -z ${lambdaname} ]  ||  [ -z ${account_id} ] 
then
  echo ""
  echo "USAGE:"
  echo "./create_permission.sh (lambda_function_name) (account_id)"
  echo ""
  echo "Assigns InvokeFunction permission for all cloudwatch events from the specified account to the specified AWS Lambda function."
  echo ""
  echo "Provide parameters without quotation marks."
  echo ""
  exit
fi
# get ARN of lambda function
ARN=($(aws lambda get-function --function-name $lambdaname | grep Arn | cut -d"\"" -f 4))

echo -n "Setting permission for function: $ARN." 
echo ""
# Grants permission for all event rules under the account to the lambda function
aws lambda add-permission --function-name $lambdaname --statement-id cloud_watch_event_permission --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn "arn:aws:events:us-east-1:$account_id:rule/*"
echo ""
echo "Completed."

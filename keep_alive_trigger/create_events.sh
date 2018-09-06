# Can have up to 5 triggers for each event
lambdaname=$1
events=$2
targets=$3
#json="{'name':'','calcs':0,'sleep':7000,'loops':0}"
json="{"\"name\"":"\"\",\"calcs\"":0,\"sleep\"":7000,\"loops\"":0}"
#json='{"name":"","calcs":0,"sleep":7000,"loops":0}'
if [ -z ${lambdaname} ]  ||  [ -z ${events} ] || [ -z ${targets} ]
then
  echo ""
  echo "USAGE:"
  echo "./create_events.sh (lambda_function_name) (number_of_events) (number_of_targets_per_event)"
  echo ""
  echo "Creates multiple cloud watch events and associated targets to keep alive an AWS Lambda function."
  echo ""
  echo "Provide parameters without quotation marks."
  echo ""
  exit
fi
# get ARN of lambda function
ARN=($(aws lambda get-function --function-name $lambdaname | grep Arn | cut -d"\"" -f 4))

echo -n "Creating $events events for $ARN." 
echo ""
for (( i=1 ; i <= $events; i++ ))
do
  echo -n "$i "
  #aws events put-targets --rule $rule --targets "Id"="Target$i","Arn"="$ARN"
  #aws events put-targets --rule $rule --targets "Id"="Target$i","Arn"="$ARN","Input"="$json"
  #aws events put-targets --rule $rule --targets "Id"="Target$i","Arn"="$ARN","Input"="$json"
  #aws events put-targets --rule $rule --targets "{\"Id\":\"Target$i\",\"Arn\":\"$ARN\",\"Input\":\"{\\\"name\\\":\\\"\\\",\\\"calcs\\\":0,\\\"sleep\\\":500,\\\"loops\\\":0}\"}"
  rulearnraw=($(aws events put-rule --name "rule$i" --schedule-expression "cron(0/5 * * * ? *)" --state "ENABLED" --description "rule$i description."))
  rulearn=($(echo ${rulearnraw[2]} | cut -d "\"" -f 2))
  echo "New rule=$rulearn" 
  aws lambda add-permission --function-name $lambdaname --statement-id rulepermission$i --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn $rulearn
  ./put_triggers.sh $lambdaname $targets rule$i
done
echo ""
echo "Completed."

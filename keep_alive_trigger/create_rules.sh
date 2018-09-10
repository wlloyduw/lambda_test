# Can have up to 5 targets for each CloudWatch event rule.
lambdaname=$1  # the AWS Lambda function to keep alive
events=$2      # the number of CloudWatch Event rules to create
targets=$3     # the number of targets for each rule
#json="{'name':'','calcs':0,'sleep':7000,'loops':0}"
json="{"\"name\"":"\"\",\"calcs\"":0,\"sleep\"":7000,\"loops\"":0}"
#json='{"name":"","calcs":0,"sleep":7000,"loops":0}'
if [ -z ${lambdaname} ]  ||  [ -z ${events} ] || [ -z ${targets} ]
then
  echo ""
  echo "USAGE:"
  echo "./create_events.sh (lambda_function_name) (number_of_rules) (number_of_targets_per_rule)"
  echo ""
  echo "Creates multiple CloudWatch event rules and associated targets to keep alive an AWS Lambda function."
  echo ""
  echo "Provide parameters without quotation marks."
  echo ""
  exit
fi
# get ARN of lambda function
ARN=($(aws lambda get-function --function-name $lambdaname | grep Arn | cut -d"\"" -f 4))

echo -n "Creating $events rules for $ARN." 
echo ""
for (( i=1 ; i <= $events; i++ ))
do
  echo -n "$i "
  #aws events put-targets --rule $rule --targets "Id"="Target$i","Arn"="$ARN"
  #aws events put-targets --rule $rule --targets "Id"="Target$i","Arn"="$ARN","Input"="$json"
  #aws events put-targets --rule $rule --targets "Id"="Target$i","Arn"="$ARN","Input"="$json"
  #aws events put-targets --rule $rule --targets "{\"Id\":\"Target$i\",\"Arn\":\"$ARN\",\"Input\":\"{\\\"name\\\":\\\"\\\",\\\"calcs\\\":0,\\\"sleep\\\":500,\\\"loops\\\":0}\"}"
  rulearnraw=($(aws events put-rule --name "rule$i" --schedule-expression "cron(0/5 * * * ? *)" --state "ENABLED" --description "r$i"))
  rulearn=($(echo ${rulearnraw[2]} | cut -d "\"" -f 2))
  echo "New rule=$rulearn" 
  #aws lambda add-permission --function-name $lambdaname --statement-id rp$i --action 'lambda:*' --principal events.amazonaws.com --source-arn $rulearn
  #aws lambda add-permission --function-name $lambdaname --statement-id rp$i --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn $rulearn
  ./put_targets.sh $lambdaname $targets rule$i
done
echo ""
echo "Completed."

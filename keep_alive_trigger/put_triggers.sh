# Can have up to 5 triggers for each event
lambdaname=$1
triggers=$2
rule=$3
#json param not presently used...
json="{"\"name\"":"\"\",\"calcs\"":0,\"sleep\"":7000,\"loops\"":0}"
if [ -z ${lambdaname} ]  ||  [ -z ${triggers} ]  || [ -z ${rule} ]
then
  echo ""
  echo "USAGE:"
  echo "./keep_alive_trigger.sh (lambda_function_name) (trigger_count) (rule_name)"
  echo ""
  echo "Provide parameters without quotation marks."
  echo ""
  exit
fi
# get ARN of lambda function
ARN=($(aws lambda get-function --function-name $lambdaname | grep Arn | cut -d"\"" -f 4))

echo -n "Putting $triggers targets for $ARN using rule \"$rule\"."
echo ""
for (( i=1 ; i <= $triggers; i++ ))
do
  echo -n "$i "
  #aws events put-targets --rule $rule --targets "Id"="Target$rule$i","Arn"="$ARN"
  aws events put-targets --rule $rule --targets "{\"Id\":\"target_$rule$i\",\"Arn\":\"$ARN\",\"Input\":\"{\\\"name\\\":\\\"\\\",\\\"calcs\\\":0,\\\"sleep\\\":3500,\\\"loops\\\":0}\"}"
done
echo ""
echo "Completed."

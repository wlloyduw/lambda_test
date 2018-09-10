# Create targets for CloudWatch event rules
# This script is called by create_events.sh and is not typically invoked directly...
# Can have up to 5 targets for each event
lambdaname=$1
targets=$2
rule=$3
#json param not presently used...
json="{"\"name\"":"\"\",\"calcs\"":0,\"sleep\"":7000,\"loops\"":0}"
if [ -z ${lambdaname} ]  ||  [ -z ${targets} ]  || [ -z ${rule} ]
then
  echo ""
  echo "USAGE:"
  echo "./put_triggers.sh (lambda_function_name) (target_count) (rule_count)"
  echo ""
  echo "Create targets for an AWS CloudWatch event rule.  A maximum of 5 targets can be created for each rule."
  echo ""
  echo "Provide parameters without quotation marks."
  echo ""
  exit
fi
# get ARN of lambda function
ARN=($(aws lambda get-function --function-name $lambdaname | grep Arn | cut -d"\"" -f 4))

echo -n "Putting $targets targets for $ARN using rule \"$rule\"."
echo ""
for (( i=1 ; i <= $targets; i++ ))
do
  echo -n "$i "
  #aws events put-targets --rule $rule --targets "Id"="Target$rule$i","Arn"="$ARN"
  aws events put-targets --rule $rule --targets "{\"Id\":\"target_$rule$i\",\"Arn\":\"$ARN\",\"Input\":\"{\\\"name\\\":\\\"\\\",\\\"calcs\\\":0,\\\"sleep\\\":6125,\\\"loops\\\":0}\"}"
  #aws events put-targets --rule $rule --targets "{\"Id\":\"target_$rule$i\",\"Arn\":\"$ARN\",\"Input\":\"{\\\"sleep\\\":10000}\"}"
done
echo ""
echo "Completed."

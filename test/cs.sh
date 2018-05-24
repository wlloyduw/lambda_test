#!/bin/bash

json={"\"name\"":"\"whoami\",\"calcs\"":20000,\"sleep\"":0,\"loops\"":20}
#echo $json

#call using curl 
curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 

exit

#curl -H "Content-Type: application/json" -X POST -d  $json https://gc1jf6rl87.execute-api.us-east-1.amazonaws.com/dev1

# Harrison Lambda@Edge
#curl -s -H "Content-Type: text/html" -X GET http://d914oi6l23cge.cloudfront.net/6stress2

#call from aws gateway api
#aws apigateway test-invoke-method --rest-api-id ue5e0irnce --resource-id dlxjg7 --http-method POST --path-with-query-string '/test' --body $json

#call from aws lambda cli
aws lambda invoke --invocation-type RequestResponse --function-name test --region us-east-1 --log-type Tail --payload '{"calcs":100000,"sleep":0,"loops":20}' out.txt

cat out.txt
#aws lambda invoke --invocation-type RequestResponse --function-name test --region us-east-1 --log-type Tail --payload $json out.txt


exit







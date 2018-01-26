#!/bin/bash


#json={"\"name\"":"\"uname\u0020-a\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"pwd\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"whoami\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"ls\u0020-l\u0020\/sbin\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
json={"\"name\"":"\"\/sbin\/ifconfig\u0020-a\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"\",\"calcs\"":10000,\"sleep\"":0,\"loops\"":20}
echo $json

#call using curl 


#curl -H "Content-Type: application/json" -X POST -d  $json https://localhost:18081/fibo/calcs 
#curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 
#curl -H "Content-Type: application/json" -X POST -d  $json https://a9gseqxep9.execute-api.us-east-1.amazonaws.com/test2
curl -H "Content-Type: application/json" -X POST -d  $json https://os3m6ub7u1.execute-api.us-east-1.amazonaws.com/exp4; echo &
echo
curl -H "Content-Type: application/json" -X POST -d  $json https://os3m6ub7u1.execute-api.us-east-1.amazonaws.com/exp4; echo  &
echo
curl -H "Content-Type: application/json" -X POST -d  $json https://os3m6ub7u1.execute-api.us-east-1.amazonaws.com/exp4; echo  &
#curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null
#curl -H "Content-Type: application/json" -X POST -d  $json https://a9gseqxep9.execute-api.us-east-1.amazonaws.com/test2 2>/dev/null
echo "done."

#call from aws gateway api
#aws apigateway test-invoke-method --rest-api-id ue5e0irnce --resource-id dlxjg7 --http-method POST --path-with-query-string '/test' --body $json

#call from aws lambda cli
#aws lambda invoke --invocation-type RequestResponse --function-name test --region us-east-1 --log-type Tail --payload '{"calcs":100000,"sleep":0,"loops":20}' out.txt
#aws lambda invoke --invocation-type RequestResponse --function-name test --region us-east-1 --log-type Tail --payload $json out.txt


exit







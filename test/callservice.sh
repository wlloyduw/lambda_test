#!/bin/bash

#aws lambda invoke --invocation-type RequestResponse --function-name test --region us-east-1 --log-type Tail --payload '{"calcs":100000,"sleep":0,"loops":20}' out.txt


#aws lambda invoke --invocation-type RequestResponse --function-name test --region us-east-1 --log-type Tail --payload '{"calcs":100000,"sleep":0,"loops":450}' out.txt
#cat out.txt
#echo
#echo
#echo
#aws lambda invoke --invocation-type RequestResponse --function-name test --region us-east-1 --log-type Tail --payload '{"calcs":100000,"sleep":0,"loops":20}' out.txt
#exit

#json={"\"name\"":"\"uname\u0020-a\",\"calcs\"":100000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"echo\u0020hello\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"whoami\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"pwd\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"\/sbin\/route\u0020-n\",\"calcs\"":10000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"ls\u0020-l\u0020\/sys\/fs\/cgroup\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"ls\u0020-l\u0020\/proc\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}

# identify the Lambda CPU
json={"\"name\"":"\"\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"cat\u0020\/proc\/cpuinfo\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}

#json={"\"name\"":"\"ls\u0020-l\u0020\/\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"ls\u0020-l\u0020\/sys\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"ls\u0020-l\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"df\u0020-h\",\"calcs\"":1000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"\/sbin\/ifconfig\u0020-a\",\"calcs\"":10000,\"sleep\"":0,\"loops\"":200}
#json={"\"name\"":"\"\/sbin\/ifconfig\u0020-a\",\"calcs\"":10000,\"sleep\"":0,\"loops\"":200}
#####json={"\"name\"":"\"\/bin\/ps\",\"calcs\"":10000,\"sleep\"":0,\"loops\"":200}
#json={"\"name\"":"\"\",\"calcs\"":10000,\"sleep\"":0,\"loops\"":20}
#json={"\"name\"":"\"\",\"calcs\"":0,\"sleep\"":1000,\"loops\"":0}
#echo $json
#json="{}"
#call using curl 


#curl -H "Content-Type: application/json" -X POST -d  $json https://localhost:18081/fibo/calcs 
curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 
#curl -H "Content-Type: application/json" -X POST -d  $json https://2ampa6hww3.execute-api.us-east-1.amazonaws.com/test8/
#curl -H "Content-Type: application/json" -X POST -d  $json https://8v257bm4qe.execute-api.us-east-1.amazonaws.com/test7/

exit
#curl -H "Content-Type: application/json" -X POST -d  $json https://a9gseqxep9.execute-api.us-east-1.amazonaws.com/test2
#curl -H "Content-Type: application/json" -X POST -d  $json https://os3m6ub7u1.execute-api.us-east-1.amazonaws.com/exp4; echo &
#curl -H "Content-Type: application/json" -X POST -d  $json https://b3euo2n6s7.execute-api.us-east-1.amazonaws.com/test/navid
#curl -H "Content-Type: application/json" -X POST -d  $json https://5dys3qzzuk.execute-api.us-east-1.amazonaws.com/test3/
#curl -H "Content-Type: application/json" -X POST -d  $json https://i1dc63pzgh.execute-api.us-east-1.amazonaws.com/test5/
echo
curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null &
#curl -H "Content-Type: application/json" -X POST -d  $json https://os3m6ub7u1.execute-api.us-east-1.amazonaws.com/exp4; echo  &
echo
#curl -H "Content-Type: application/json" -X POST -d  $json https://os3m6ub7u1.execute-api.us-east-1.amazonaws.com/exp4; echo  &
curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null &
echo
#curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null &
echo
#curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null &
echo
#curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null &
echo
#curl -H "Content-Type: application/json" -X POST -d  $json https://ue5e0irnce.execute-api.us-east-1.amazonaws.com/test/test 2>/dev/null &
echo
#curl -H "Content-Type: application/json" -X POST -d  $json https://a9gseqxep9.execute-api.us-east-1.amazonaws.com/test2 2>/dev/null
echo "done."

#call from aws gateway api
#aws apigateway test-invoke-method --rest-api-id ue5e0irnce --resource-id dlxjg7 --http-method POST --path-with-query-string '/test' --body $json

#call from aws lambda cli
#aws lambda invoke --invocation-type RequestResponse --function-name test --region us-east-1 --log-type Tail --payload '{"calcs":100000,"sleep":0,"loops":20}' out.txt
#aws lambda invoke --invocation-type RequestResponse --function-name test --region us-east-1 --log-type Tail --payload $json out.txt


exit







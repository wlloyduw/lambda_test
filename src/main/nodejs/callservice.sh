#!/bin/bash

#https://6gp82n6dt1.execute-api.us-east-1.amazonaws.com/mycpu
json={}

# edge
echo "EDGE"
edge1=$(curl -H "Content-Type: application/json" -X POST -d  $json https://u0blz1vrvg.execute-api.us-east-1.amazonaws.com/mycpu2)
echo $edge1 | jq


# regional
echo "REGIONAL"
time curl -H "Content-Type: application/json" -X POST -d  $json https://6gp82n6dt1.execute-api.us-east-1.amazonaws.com/mycpu
echo 

# edge
echo "EDGE"
time curl -H "Content-Type: application/json" -X POST -d  $json https://u0blz1vrvg.execute-api.us-east-1.amazonaws.com/mycpu2

echo
exit






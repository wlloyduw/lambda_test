docker build -t lambdatest .
#time docker run -it --rm lambdatest 
docker run --rm -m 128m --cpus=.166 lambdatest &
#java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20
#docker run -it -m 128m --rm lambdatest java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20

# to exit the container
#docker exec <container-id> bash -c 'touch /stop'
sleep 1
cont=`docker ps | grep lambdatest | cut -d' ' -f 1`
# to run a cmd
time docker exec $cont bash -c 'java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20' 

docker exec $cont bash -c 'touch /stop'

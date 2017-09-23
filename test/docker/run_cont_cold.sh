docker build -t lambdatest -f Dockerfile_nodaemon .
#time docker run -it --rm lambdatest 
docker run -it -m 128m --cpus=.166 lambdatest java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20
#docker run -it -m 128m --rm lambdatest java -cp lambda_test-1.0-SNAPSHOT.jar uwt.lambda_test 25000 0 20

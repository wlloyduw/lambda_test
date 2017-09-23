M ubuntu
RUN apt-get update
RUN apt-get install -y default-jre
COPY lambda_test-1.0-SNAPSHOT.jar /
#ENTRYPOINT ["/"]
CMD ["/usr/bin/java","-cp","lambda_test-1.0-SNAPSHOT.jar","uwt.lambda_test","10000000","0","1",""]



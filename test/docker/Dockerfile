FROM openjdk:8
RUN mkdir -p /Users/minhvu/Desktop/lambda_test
COPY lambda_test.jar /Users/minhvu/Desktop/lambda_test
WORKDIR /Users/minhvu/Desktop/lambda_test
ENTRYPOINT ["java", "-jar", "lambda_test.jar"]
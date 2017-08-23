/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uwt;

import com.amazonaws.services.lambda.runtime.Context; 
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
/**
 *
 * @author wlloyd
 */
public class lambda_test implements RequestHandler<Request, Response>
{

    public Response handleRequest(Request request, Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log("Received=" + request.getName());
        return new Response("Hello " + request.getName());
    }

}

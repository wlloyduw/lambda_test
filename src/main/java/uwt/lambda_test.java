/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uwt;

import com.amazonaws.services.lambda.runtime.Context; 
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.UUID;
/**
 *
 * @author wlloyd
 */
public class lambda_test implements RequestHandler<Request, Response>
{
    static String CONTAINER_ID = "/tmp/container-id";
    static Charset CHARSET = Charset.forName("US-ASCII");
    
    public Response handleRequest(Request request, Context context) {
        String uuid = "unset";
        LambdaLogger logger = context.getLogger();
        logger.log("Received=" + request.getName());
        File f = new File("/tmp/container-id");
        Path p = Paths.get("/tmp/container-id");
        if (f.exists())
        {
            try (BufferedReader br = Files.newBufferedReader(p))
            {
                uuid = br.readLine();
                br.close();
            }
            catch (IOException ioe)
            {
                return new Response("Error reading existing UUID",uuid);
            }
        }
        else
        {
            try (BufferedWriter bw = Files.newBufferedWriter(p, StandardCharsets.US_ASCII, StandardOpenOption.CREATE_NEW))
            {
                uuid = UUID.randomUUID().toString();
                bw.write(uuid);
                bw.close();
            }
            catch (IOException ioe)
            {
                return new Response("Error writing new UUID",uuid);
            }
            
        }
            
        
        return new Response("Success=" + request.getName(), uuid);
    }

}

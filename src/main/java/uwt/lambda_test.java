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
import java.util.Random;
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
            
        for (int i=0;i<request.getLoops();i++)
        {
            randomMath(request.getCalcs());
            try
            {
                Thread.sleep(request.getSleep());
            }
            catch (InterruptedException ie)
            {
                System.out.println("Sleep was interrupted...");
            }
        }
        return new Response("Success=" + request.getName(), uuid);
    }
    
    
    private void randomMath(int calcs)
    {
        Random rand = new Random();
        // By not reusing the same variables in the calc, this should prevent
        // compiler optimization... Also each math operation should operate
        // on between operands in different memory locations.
        long[] operand_a = new long[calcs];
        long[] operand_b = new long[calcs];
        long[] operand_c = new long[calcs];
        long mult;
        double div1;
        
        for (int i=0;i<calcs;i++)
        {
            // By not using sequential locations in the array, we should 
            // reduce memory lookup efficiency
            int j = rand.nextInt(calcs);
            operand_a[j] = rand.nextInt(99999);
            operand_b[j] = rand.nextInt(99999);
            operand_c[j] = rand.nextInt(99999);
            mult = operand_a[j] * operand_b[j];
            div1 = (double) mult / (double) operand_c[j];
        }
    }

}

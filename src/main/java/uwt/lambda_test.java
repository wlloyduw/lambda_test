/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uwt;

import com.amazonaws.services.lambda.runtime.ClientContext;
import com.amazonaws.services.lambda.runtime.CognitoIdentity;
import com.amazonaws.services.lambda.runtime.Context; 
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
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
        CpuTime c1 = getCpuUtilization();
        VmCpuStat v1 = getVmCpuStat();
        String uuid = "unset";
        LambdaLogger logger = context.getLogger();
        logger.log("Request for file=" + request.getName());
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
        CpuTime c2 = getCpuUtilization();
        VmCpuStat v2 = getVmCpuStat();
        CpuTime cused = getCpuTimeDiff(c1, c2);
        VmCpuStat vused = getVmCpuStatDiff(v1, v2);
        long vuptime = getUpTime(v2);
        String fileout = ((request.getName() != null) && (request.getName().length() > 0)) ? getFileAsString(request.getName()): "";
        //Response r = new Response(fileout, uuid, cused.utime, cused.stime, cused.cutime, cused.cstime);
        Response r = new Response(fileout, uuid, cused.utime, cused.stime, cused.cutime, cused.cstime, vused.cpuusr,
                                  vused.cpunice, vused.cpukrn, vused.cpuidle, vused.cpuiowait, vused.cpuirq, 
                                  vused.cpusirq, vused.cpusteal, vuptime);
        r.setPid(getPID());
        return r;
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
    
    public String getFileAsString(String filename)
    {
        File f = new File(filename);
        Path p = Paths.get(filename);
        String text = "";
        StringBuffer sb = new StringBuffer();
        if (f.exists()) 
        {
            try (BufferedReader br = Files.newBufferedReader(p))
            {
                while((text = br.readLine()) != null)
                {
                    sb.append(text);
                }
            }
            catch (IOException ioe)
            {
                sb.append("Error reading file=" + filename);
            }
        }
        return sb.toString();
    }

    class CpuTime
    {
        long utime;
        long stime;
        long cutime;
        long cstime;
        CpuTime(long utime, long stime, long cutime, long cstime)
        {
            this.utime = utime;
            this.stime = stime;
            this.cutime = cutime;
            this.cstime = cstime;
        }
        CpuTime()
        {            
        }
        
        @Override
        public String toString()
        {
            return "utime=" + utime + " stime=" + stime + " cutime=" + cutime + " cstime=" + cstime + " ";
        }
    }
    public CpuTime getCpuUtilization()
    {
        String filename = "/proc/1/stat";
        File f = new File(filename);
        Path p = Paths.get(filename);
        String text = "";
        StringBuffer sb = new StringBuffer();
        if (f.exists()) 
        {
            try (BufferedReader br = Files.newBufferedReader(p))
            {
                text = br.readLine();
                br.close();
            }
            catch (IOException ioe)
            {
                sb.append("Error reading file=" + filename);
            }
            String params[] = text.split(" ");
            return new CpuTime(Long.parseLong(params[13]),
                               Long.parseLong(params[14]),
                               Long.parseLong(params[15]),
                               Long.parseLong(params[16]));
        }
        else
            return new CpuTime();
    }
    
    class VmCpuStat
    {
        long cpuusr;
        long cpunice;
        long cpukrn;
        long cpuidle;
        long cpuiowait;
        long cpuirq;
        long cpusirq;
        long cpusteal;
        long btime;
        VmCpuStat(long cpuusr, long cpunice, long cpukrn, long cpuidle, 
                  long cpuiowait, long cpuirq, long cpusirq, long cpusteal)
        {
            this.cpuusr = cpuusr;
            this.cpunice = cpunice;
            this.cpukrn = cpukrn;
            this.cpuidle = cpuidle;
            this.cpuiowait = cpuiowait;
            this.cpuirq = cpuirq;
            this.cpusirq = cpusirq;
            this.cpusteal = cpusteal;
        }
        VmCpuStat() { }
    }
    public VmCpuStat getVmCpuStat()
    {
        String filename = "/proc/stat";
        File f = new File(filename);
        Path p = Paths.get(filename);
        String text = "";
        StringBuffer sb = new StringBuffer();
        if (f.exists()) 
        {
            try (BufferedReader br = Files.newBufferedReader(p))
            {
                text = br.readLine();
                String params[] = text.split(" ");
                VmCpuStat vcs = new VmCpuStat(Long.parseLong(params[2]),
                                              Long.parseLong(params[3]),
                                              Long.parseLong(params[4]),
                                              Long.parseLong(params[5]),
                                              Long.parseLong(params[6]),
                                              Long.parseLong(params[7]),
                                              Long.parseLong(params[8]),
                                              Long.parseLong(params[9]));
                while ((text = br.readLine()) != null && text.length() != 0) {
                    // get boot time in ms since epoch
                    if (text.contains("btime"))
                    {
                        String prms[] = text.split(" ");
                        vcs.btime = Long.parseLong(prms[1]);
                    }
                }
                br.close();
                return vcs;
            }
            catch (IOException ioe)
            {
                sb.append("Error reading file=" + filename);
                return new VmCpuStat();
            }
        }
        else
            return new VmCpuStat();
    }
    
    public long getUpTime(VmCpuStat vmcpustat)
    {
//        double time = vmcpustat.cpuidle +
//                      vmcpustat.cpuiowait +
//                      vmcpustat.cpuirq +
//                      vmcpustat.cpukrn +
//                      vmcpustat.cpunice +
//                      vmcpustat.cpusirq +
//                      vmcpustat.cpusteal +
//                      vmcpustat.cpuusr;
//        time = time / 100;
//        time = time / 2;
        return vmcpustat.btime;
        //return time;
    }
    
    public VmCpuStat getVmCpuStatDiff(VmCpuStat v1, VmCpuStat v2)
    {
        return new VmCpuStat(v2.cpuusr - v1.cpuusr, v2.cpunice - v1.cpunice, v2.cpukrn - v1.cpukrn,
                             v2.cpuidle - v1.cpuidle, v2.cpuiowait - v1.cpuiowait, v2.cpuirq - v1.cpuirq,
                             v2.cpusirq - v1.cpusirq, v2.cpusteal - v1.cpusteal);
    }
    
    public CpuTime getCpuTimeDiff(CpuTime c1, CpuTime c2)
    {
        return new CpuTime(c2.utime - c1.utime, c2.stime-c1.stime, c2.cutime - c1.cutime, c2.cstime - c1.cstime);
    }
    
    public static void main (String[] args)
    {
        Context c = new Context() {
            @Override
            public String getAwsRequestId() {
                return "";
            }

            @Override
            public String getLogGroupName() {
                return "";
            }

            @Override
            public String getLogStreamName() {
                return "";
            }

            @Override
            public String getFunctionName() {
                return "";
            }

            @Override
            public String getFunctionVersion() {
                return "";
            }

            @Override
            public String getInvokedFunctionArn() {
                return "";
            }

            @Override
            public CognitoIdentity getIdentity() {
                return null;
            }

            @Override
            public ClientContext getClientContext() {
                return null;
            }

            @Override
            public int getRemainingTimeInMillis() {
                return 0;
            }

            @Override
            public int getMemoryLimitInMB() {
                return 0;
            }

            @Override
            public LambdaLogger getLogger() {
                return new LambdaLogger() {
                    @Override
                    public void log(String string) {
                        System.out.println("LOG:" + string);
                    }
                };
            }
        };
        lambda_test lt = new lambda_test();
        
        Request req = new Request("hello fred");
        
        int calcs = (args.length > 0 ? Integer.parseInt(args[0]) : 0);
        int sleep = (args.length > 1 ? Integer.parseInt(args[1]) : 0);
        int loops = (args.length > 2 ? Integer.parseInt(args[2]) : 0);
        String name = (args.length > 3 ? args[3] : "");
        
        req.setCalcs(calcs);
        req.setSleep(sleep);
        req.setLoops(loops);
        req.setName(name);
        System.out.println("calcs=" + req.getCalcs() + " sleep=" + req.getSleep() + " loops=" + req.getLoops() + " getfile=" + req.getName());
        Response resp = lt.handleRequest(req, c);
        System.out.println(resp.toString());
    }

    public int getPID() 
    {
        try
        {
            java.lang.management.RuntimeMXBean runtime = java.lang.management.ManagementFactory.getRuntimeMXBean();
            java.lang.reflect.Field jvm = runtime.getClass().getDeclaredField("jvm");
            jvm.setAccessible(true);
            sun.management.VMManagement mgmt = (sun.management.VMManagement) jvm.get(runtime);
            java.lang.reflect.Method pid_method = mgmt.getClass().getDeclaredMethod("getProcessId");
            pid_method.setAccessible(true);

            return ((Integer) pid_method.invoke(mgmt)).intValue();
        }
        catch (Exception e)
        {
            return 0;
        }
    }    

    private class test1 { }
    private class test2 { }
    private class test3 { }
    
}

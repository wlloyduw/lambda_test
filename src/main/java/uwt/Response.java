/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uwt;

/**
 *
 * @author wlloyd
 */
public class Response {
    String value;
    String uuid;
    String error;
    long cpuUsr;
    long cpuKrn;
    long cutime;
    long cstime;
    
    public String getValue()
    {
        return value;
    }
    public void setValue(String value)
    {
        this.value = value;
    }
    public String getUuid()
    {
        return uuid;
    }
    public void setUuid(String uuid)
    {
        this.uuid = uuid;
    }
    public long getCpuUsr()
    {
        return cpuUsr;
    }
    public void setCpuUsr(long cpuusr)
    {
        this.cpuUsr = cpuusr;
    }
    public long getCpuKrn()
    {
        return cpuKrn;
    }
    public void setCpuKrn(long cpukrn)
    {
        this.cpuKrn = cpukrn;
    }
    public long getCuTime()
    {
        return cutime;
    }
    public void setCuTime(long cutime)
    {
        this.cutime = cutime;
    }
    public long getCsTime()
    {
        return cstime;
    }
    public void setCsTime(long cstime)
    {
        this.cstime = cstime;
    }
    public String getError()
    {
        return error;
    }
    public void setError(String err)
    {
        this.error = err;
    }
    public Response(String value, String uuid)
    {
        this.value = value;
        this.uuid = uuid;
    }
    public Response(String value, String uuid, long cpuusr, long cpukrn)
    {
        this.value = value;
        this.uuid = uuid;
        this.cpuUsr = cpuusr;
        this.cpuKrn = cpukrn;
    }
    public Response(String value, String uuid, long cpuusr, long cpukrn, long cutime, long cstime)
    {
        this.value = value;
        this.uuid = uuid;
        this.cpuUsr = cpuusr;
        this.cpuKrn = cpukrn;
        this.cutime = cutime;
        this.cstime = cstime;
    }
    
    public Response()
    {
        
    }
    
    @Override
    public String toString()
    {
        return "value=" + this.getValue() + " uuid=" + this.getUuid() + " cpuusr=" + this.getCpuUsr() + " cpukrn=" + this.getCpuKrn()
                + " cutime=" + this.getCuTime() + " cstime=" + this.getCsTime() + "\nfile=\n" + this.getValue();
    }
}

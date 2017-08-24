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
    public Response(String value, String uuid)
    {
        this.value = value;
        this.uuid = uuid;
    }
    public Response()
    {
        
    }
}

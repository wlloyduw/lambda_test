package uwt;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;

public class TCPServer {
    private ServerSocket server;
    private String localAddr = "";

    public TCPServer(String inetAddr) throws Exception {
        this.localAddr = inetAddr;
        this.server = new ServerSocket(8888);
    }

    public void listen() throws Exception {

        String data = "";
        Socket client = this.server.accept();
        System.out.println("I am listening: " + this.localAddr);
        String clientAddress = client.getInetAddress().getHostAddress();

        BufferedReader in = new BufferedReader(
                new InputStreamReader((client.getInputStream())));
        while ((data = in.readLine()) != null) {
            System.out.println("\r\nMessage from " + clientAddress + ": " + data);
        }
    }

}

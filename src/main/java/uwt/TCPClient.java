package uwt;

import java.net.InetAddress;
import java.net.Socket;

public class TCPClient {

    private Socket socket;

    private TCPClient(InetAddress serverAddress, int serverPort) throws Exception {
        this.socket = new Socket(serverAddress, serverPort);
    }
}

package uwt;

import java.io.IOException;
import java.net.*;
import java.util.Enumeration;

public class UDPClient {

    public String myIP = "";
    public void run() {
        try {
            DatagramSocket c = new DatagramSocket();
            c.setBroadcast(true);

            byte[] sendData = "DISCOVER_FUIFSERVER_REQUEST".getBytes();

            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();

            // This should only focus on
            while (interfaces.hasMoreElements()) {
                NetworkInterface networkInterface = interfaces.nextElement();
                if (networkInterface.isLoopback() || !networkInterface.isUp() || !networkInterface.getDisplayName().contains("vinternal")) {
                    continue;
                }
                Enumeration<InetAddress> a = networkInterface.getInetAddresses();
                for (; a.hasMoreElements();)
                {
                    InetAddress addr = a.nextElement();
                    System.out.println("Stuck over there");
                    String mysubnet = addr.getHostAddress().substring(0, addr.getHostAddress().lastIndexOf(".")+1)+"0";
                    System.out.println(mysubnet);
                    System.out.println(" This is ip address " + addr.getHostAddress());

                    try {
                        DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, InetAddress.getByName(mysubnet), 8888);
                        c.send(sendPacket);
                    } catch (Exception e) {
                        System.out.println("There are some problems: " + e);
                    }
                    System.out.println(getClass().getName() + ">>> Request packet sent to: " + mysubnet + "; Interface: " + networkInterface.getDisplayName());
                    break;
                }
            }


            System.out.println(getClass().getName() + ">>> Done looping over all network interfaces. Now waiting for a reply!");

            //Wait for a response
            byte[] recvBuf = new byte[15000];
            DatagramPacket receivePacket = new DatagramPacket(recvBuf, recvBuf.length);
            c.receive(receivePacket);

            //We have a response
            System.out.println(getClass().getName() + ">>> Broadcast response from server: " + receivePacket.getAddress().getHostAddress());

            //Check if the message is correct
            String message = new String(receivePacket.getData()).trim();
            if (message.equals("DISCOVER_FUIFSERVER_RESPONSE")) {
                //DO SOMETHING WITH THE SERVER'S IP (for example, store it in your controller)
                System.out.println("Server response");
            }

            //Close the port!
            c.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

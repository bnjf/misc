import java.net.*;

class Lookup {
  public static void main(String args[]) {
    InetAddress ia[];
    try {
      ia  = InetAddress.getAllByName(args[0]);
      for (InetAddress i: ia) {
        System.out.println(args[0] + " " + i);
      }
      System.exit(0);
    }
    catch (UnknownHostException e) {
      System.err.println("lookup for " + args[0] + " failed.");
      System.exit(1);
    }
  }
}


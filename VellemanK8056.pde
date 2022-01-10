/* Drive a Velleman K8056 - 8 relays card through serial port
 * Doc : http://www.velleman.eu/downloads/0/illustrated/illustrated_assembly_manual_k8056.pdf
 *
 * Fabien Grisard
 */


import processing.serial.*;

class VellemanK8056 {
  private Serial serial;
  private byte address;
  
  public VellemanK8056(PApplet parent, String port) {
    serial = new Serial(parent, port, 2400, 'N', 8, 1);
    // default card address
    address = 0x01;
    forceAddressToOne();
  }
  
  public void showAddress() {
    println("show address");
    sendCommand(byte('D'), byte(0x00));
  }
  
  public void changeAddress(int newAddress) {
    if(newAddress > 0 && newAddress <= 255) {
      println("change address to "+newAddress);
      byte baddress = byte(newAddress);
      sendCommand(byte('A'), baddress);
      address = baddress;
      delay(400);
      clearAll();
    }
  }
  
  public void forceAddressToOne() {
    println("force address");
    sendCommand(byte('F'), byte(0x00));
    address = byte(0x01);
    delay(400);
    clearAll();
  }
  
  public void emergencyStop() {
    println("emergency stop");
    sendCommand(byte('E'), byte(0x00));
  }
  
  public void toogleRelay(int relay) {
    if(relay > 0 && relay < 9) {
      println("toogle relay "+relay);
      byte relayAscii = byte(relay + '0');
      sendCommand(byte('T'), relayAscii);
    }
  }
  
  public void setRelay(int relay) {
    if(relay > 0 && relay < 9) {
      println("set relay "+relay);
      byte relayAscii = byte(relay + '0');
      sendCommand(byte('S'), relayAscii);
    }
  } 
    
  public void setAll() {
    println("set all relays");
    sendCommand(byte('S'), byte('9'));
  }
  
  public void clearRelay(int relay) {
    if(relay > 0 && relay < 9) {
      println("clear relay "+relay);
      byte relayAscii = byte(relay + '0');
      sendCommand(byte('C'), relayAscii);
    }
  }
  
  public void clearAll() {
    println("clear all relays");
    sendCommand(byte('C'), byte('9'));
  }
  
  public void changeAll(boolean[] values) {
    if(values.length == 8) {
      print("send byte : ");
      for(boolean b : values) print(b + " ");
      println();
      byte val = 0x00;
      for(int i=0; i<8; i++) {
        if(values[i]) {
          val += pow(2, 7-i);
        }
      }
      sendCommand(byte('B'), val);
    }
  }
  
  private void sendCommand(byte instruction, byte addressOrRelay) {
    byte[] instructionSequence = new byte[5];
    instructionSequence[0] = 13;
    instructionSequence[1] = (instruction == 'S' || instruction == 'C' || instruction == 'T' || instruction == 'B' || instruction == 'A')? address : byte(0x00);
    instructionSequence[2] = instruction;
    instructionSequence[3] = addressOrRelay;
    
    byte sum = 0;
    for(int i=0; i<4; i++) {
      sum += instructionSequence[i];
    }
    byte checksum = (byte)((sum ^ byte(0xFF)) + byte(1));
    instructionSequence[4] = checksum;
    // send it twice to ensure transmission
    for(int i=0; i<2; i++) {
      serial.write(instructionSequence);
      delay(50);
    }
  }
  
}

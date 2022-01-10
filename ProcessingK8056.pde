VellemanK8056 relayCard;

void setup() {
  size(200, 200);
  String portName = Serial.list()[0];
  println("connection to serial port "+portName);
  relayCard = new VellemanK8056(this, portName);
}

void draw() {
  background(0);
}

void keyPressed() {
  switch(key) {
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
      relayCard.toogleRelay(key - '0');
      break;
    case '9':
      relayCard.setAll();
      break;
    case '0':
      relayCard.clearAll();
      break;
    case 'a':
      relayCard.changeAddress(floor(random(1, 256)));
      break;
    case 'f':
      relayCard.forceAddressToOne();
      break;
    case 'd':
      relayCard.showAddress();
      break;
    case 'v':
      boolean[] states = {true, false, true, false, true, false, true, false};
      relayCard.changeAll(states);
      break;
    default:
      relayCard.emergencyStop();
      break;
  }
}

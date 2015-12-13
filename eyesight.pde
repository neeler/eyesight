import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.effects.*;
import processing.serial.*;
import java.util.Random;
import java.lang.Math;
import java.awt.Color;
import oscP5.*;
import netP5.*;

// Connection information.
final String localHost = "127.0.0.1";

Random rand;
OPC opc;
ColorWheel wheel;
Eye eye;

// audio crap
BPMDetector bpm;
Minim minim;
AudioPlayer sound;
AudioInput in;
int bufferSize = 1024;
int sampleRate = 44100;

//Panel IDs
final int R0 = 0;
final int R1 = 1;
final int R2 = 2;
final int R3 = 3;
final int R4 = 4;
final int RT = 5;
final int C0 = 6;
final int C1 = 7;
final int OT = 8;
final int OR = 9;
final int OBR = 10;
final int OBL = 11;
final int OL = 12;

boolean mouseRotate = false;
boolean drawFFT = false;
boolean mouseBoolean = true;

// Global variables for remote control.
int globalBrightness = 255;
int globalDelay = 0;
float fadeFactor = 0.9;
int chance = 500;
boolean modeSwitching = false;
int modeChance = 320;
float gainFactor = 1.0;  
int pixelOffset = 2;
int panelOffset = 10;
int loopOffset = 10;
int beatOffset = 0;
int shiftChance = 8;
boolean panelFFT = false;

int nColors = 1500;
int maxDelay = 120;
int maxOffset = nColors/8;
int maxPixelOffset = maxOffset/8;

// Open sound control business
OscFix oscFix;
NetAddress myRemoteLocation;
NetAddressList myNetAddressList = new NetAddressList();
int myListeningPort = 5001;
int myBroadcastPort = 12000;

public void settings() {
  size(1500, 1500, P3D);
}

public void setup() {
  background(0);
  rand = new Random();
  opc = new OPC(localHost, 7890);
  wheel = new ColorWheel(nColors);
  eye = new Eye();
  
  minim = new Minim(this);
  //Line in
  in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  //in = new AudioIn(this, 1);
  bpm = new BPMDetector(in);
  bpm.setup();
  
  oscFix = new OscFix(this, myListeningPort);
  // set the remote location to be the localhost on port 5001
  myRemoteLocation = new NetAddress("10.0.0.6", myListeningPort);
}

public void draw() {
  background(0);
  eye.randomize();
  if(eye.modes[eye.mode].justEntered) {
    oscModeSync();
  }
  eye.update();
  
  translate(width/2,height/2,0);
  if (mouseRotate) {
    rotateY(map(mouseX, 0, width, -PI/2, PI/2));
    rotateX(map(mouseY, 0, height, -PI/2, PI/2));
  }
  eye.draw();
  
  //eye.send();
}

public void keyPressed() {
  if (key == 'r') {
    mouseRotate = !mouseRotate;
  } else if (key == ' ') {
    wheel.newScheme();
  } else if (key == 'm') {
    eye.setMode((eye.mode + 1) % eye.nModes);
  } else if (key == 'f') {
    drawFFT = !drawFFT;
  }
}

public void mouseClicked() {
  mouseBoolean = !mouseBoolean;
}

void oscEvent(OscMessage theOscMessage) 
{ 
  oscConnect(theOscMessage.netAddress().address());
  
  String addPatt = theOscMessage.addrPattern();
  int patLen = addPatt.length();
  float x, y;
  int a0, a1;
  
  if (addPatt.length() < 3) {
    //println("Page change");
  } else if (patLen == 9 && addPatt.substring(0, 5).equals("/mode")) {
    if (theOscMessage.get(0).floatValue() == 1.0) {
      a0 = 5 - Integer.parseInt(addPatt.substring(6, 7));
      a1 = Integer.parseInt(addPatt.substring(8, 9)) - 1;
      eye.setMode((5 * a0 + a1) % eye.nModes);
    }
  } else if (patLen == 10 && addPatt.substring(0, 8).equals("/offsets")) {
    int iOffset = Integer.parseInt(addPatt.substring(9,10));
    float faderVal = theOscMessage.get(0).floatValue();
    switch(iOffset) {
      case 1: // PIXEL
        pixelOffset = round(map(faderVal, 0.0, 1.0, 0.0, maxPixelOffset));
        break;
      case 2: // PANEL
        panelOffset = round(map(faderVal, 0.0, 1.0, 0.0, maxOffset));
        break;
      case 3: // LOOP
        loopOffset = round(map(faderVal, 0.0, 1.0, 0.0, maxOffset));
        break;
      case 4: // BEAT
        beatOffset = round(map(faderVal, 0.0, 1.0, 0.0, maxOffset));
        break;
    }
  } else if (patLen == 9 && addPatt.substring(0,5).equals("/vibe")) {
    println("address pattern: " + theOscMessage.addrPattern());
    println("type tag: " + theOscMessage.typetag());
    if (theOscMessage.get(0).floatValue() == 1.0) {
      a0 = 2 - Integer.parseInt(addPatt.substring(6, 7));
      a1 = Integer.parseInt(addPatt.substring(8, 9)) - 1;
      int func = 2 * a0 + a1;
      switch(func) {
        case 0: // ALL
          eye.setVibe(wheel.ALL);
          break;
        case 1: // generate a new scheme within the current vibe
          eye.newScheme();
          break;
        case 2: // WARM
          eye.setVibe(wheel.WARM);
          break;
        case 3: // COOL
          eye.setVibe(wheel.COOL);
          break;
      }
    }
  } else if (addPatt.equals("/delay")) {
    globalDelay = round(map(theOscMessage.get(0).floatValue(), 0, 1, 0, maxDelay));
  } else if (addPatt.equals("/brightness")) {
    globalBrightness = round(theOscMessage.get(0).floatValue());
  } else if (addPatt.equals("/fadeFactor")) {
    fadeFactor = theOscMessage.get(0).floatValue();
  } else if (addPatt.equals("/modeSwitching")) {
    modeSwitching = round(theOscMessage.get(0).floatValue()) != 0;
  } else if (addPatt.equals("/modeChance")) {
    modeChance = round(theOscMessage.get(0).floatValue());
  } else if (addPatt.equals("/panelFFT")) {
    panelFFT = round(theOscMessage.get(0).floatValue()) != 0;
  } else {
    print("Unexpected OSC Message Recieved: ");
    println("address pattern: " + theOscMessage.addrPattern());
    println("type tag: " + theOscMessage.typetag());
  }
  
  oscSync();
}

void oscSync()
{
  OscMessage message;
  
  message = new OscMessage("/mode/" + str(5 - eye.mode / 5) + "/" + str(eye.mode % 5 + 1));
  message.add(1.0);
  oscFix.send(message, myNetAddressList);
  
  message = new OscMessage("/offsets/1");
  message.add(map(pixelOffset, 0.0, maxPixelOffset, 0.0, 1.0));
  oscFix.send(message, myNetAddressList);
  
  message = new OscMessage("/offsets/2");
  message.add(map(panelOffset, 0.0, maxOffset, 0.0, 1.0));
  oscFix.send(message, myNetAddressList);
  
  message = new OscMessage("/offsets/3");
  message.add(map(loopOffset, 0.0, maxOffset, 0.0, 1.0));
  oscFix.send(message, myNetAddressList);
  
  message = new OscMessage("/offsets/4");
  message.add(map(beatOffset, 0.0, maxOffset, 0.0, 1.0));
  oscFix.send(message, myNetAddressList);
  
  message = new OscMessage("/delay");
  message.add(map(globalDelay, 0, maxDelay, 0, 1));
  oscFix.send(message, myNetAddressList);
  
  message = new OscMessage("/brightness");
  message.add(globalBrightness);
  oscFix.send(message, myNetAddressList);
  
  message = new OscMessage("/fadeFactor");
  message.add(fadeFactor);
  oscFix.send(message, myNetAddressList);
  
  message = new OscMessage("/modeChance");
  message.add(modeChance);
  oscFix.send(message, myNetAddressList);
  
  message = new OscMessage("/modeSwitching");
  message.add(modeSwitching ? 1 : 0);
  oscFix.send(message, myNetAddressList);
  
  message = new OscMessage("/panelFFT");
  message.add(panelFFT ? 1 : 0);
  oscFix.send(message, myNetAddressList);
  
}

void oscModeSync()
{
  OscMessage message;
  
  message = new OscMessage("/mode/" + str(5 - eye.mode / 5) + "/" + str(eye.mode % 5 + 1));
  message.add(1.0);
  oscFix.send(message, myNetAddressList);
}

private void oscConnect(String theIPaddress) {
  if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
    myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
    //println("### adding " + theIPaddress + " to the list.");
    //oscSync();
  } else {
    //println("### " + theIPaddress + " is already connected.");
  }
  //println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
}

public boolean maybe(int chance) {
  return (rand.nextInt(chance) == 0);
}
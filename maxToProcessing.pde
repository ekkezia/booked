import oscP5.*;
import netP5.*;
PImage img;

//OSC receive
OscP5 oscP5;
NetAddress myRemoteLocation;
int noOfMidi = 10;
int h = 400;
int sizeOfMidiBar = floor(h/10);
float mappedPitch = 0.;
int[] yPos = new int[noOfMidi];

//int[] yPos = {0, sizeOfMidiBar * 1, sizeOfMidiBar * 2, sizeOfMidiBar * 3, sizeOfMidiBar * 4, sizeOfMidiBar * 5, sizeOfMidiBar * 6, sizeOfMidiBar * 7, sizeOfMidiBar * 8, sizeOfMidiBar * 9, sizeOfMidiBar * 10};
// y array: 0, 60, 120, 180, 240, ...
String[] musicScale = {"C", "C#","D","D#","E","F","F#","G","G#","A","A#","B","C"};

// This value is set by the OSC event handler
float amplitude = 0;
// Declare a scaling factor
float scale=6;
// Declare a smooth factor
float smooth_factor=0.1;
// Used for smoothing
float sum;
int scaledMidiNum = 1;
int pitchY = 0;
int bin;
int mappedColor;
int canvasSize = 600;

void setup() {
    //fullScreen();
    size(600,600);
    
    // set the yPos
    for(int i = 0; i < noOfMidi; i++) {
      yPos[i] = sizeOfMidiBar * i;
    }
     print('y', yPos);
    // Initialize an instance listening to port 12000
    oscP5 = new OscP5(this,12001);
    myRemoteLocation = new NetAddress("127.0.0.1", 12001);
    img = loadImage("img.jpg");
    img.resize(canvasSize, canvasSize);
    sorted = createImage(img.width, img.height, RGB);

    // lines
    //for(int i = 0; i < noOfMidi; i++) {
    //  fill(0);
    //  rect(0, i * sizeOfMidiBar, width, 0.5);
    //}
}

void draw() {
  //background(255);
    // smooth the amplitude data by the smoothing factor
    sum += (amplitude - sum) * smooth_factor;
    // scaled to height/2 and then multiplied by a scale factor
    float amp_scaled=sum*(height/2)*scale;
    //float mappedColor = map(amplitude * scale, 0, 1, 0, 255);
    
    //image(img, frameCount % width, pitchY, 100, sizeOfMidiBar);
    
    //fill(mappedColor);
    //rect(frameCount % width, pitchY, 10, sizeOfMidiBar);
  
    img();
   
}

void oscEvent(OscMessage theOscMessage) {
    float value = theOscMessage.get(0).floatValue();
    
    if (theOscMessage.checkAddrPattern("/amp")) {
      mappedColor = floor(map(value, 0, 1, 255, 0));
    }
    
        if (theOscMessage.checkAddrPattern("/pitch")) {
          mappedPitch = map(value, 0, 127, 0, height);
          bin = floor(mappedPitch / height * noOfMidi); // which bin will we put the mapped pitch? 
          pitchY = yPos[bin];
          //print("value", mappedPitch);
    }
}

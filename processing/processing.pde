import oscP5.*;
import netP5.*;
import java.io.*;

//OSC receive
OscP5 oscP5;
NetAddress myRemoteLocation;

int startFrom = 1600; // latest rec file no 'rec-###.jpg'
int minMidi = 48;
int maxMidi = 72;
int range = maxMidi - minMidi;

int noOfMidi = range / 2; // default no of midi is 24, but it is too many for us
int canvasWidth = 800;
int canvasHeight = canvasWidth;
int sizeOfMidiBar = floor(canvasHeight/noOfMidi);
float mappedPitch = 0.;
int[] yPos = new int[noOfMidi];

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
int mappedAmp;
int speed = 20; // the bigger the number, the slower it will be

void setup() {
    size(800, 800);
    background(0);
    startFrom += width;
    // set the yPos
    for(int i = 0; i < noOfMidi; i++) {
      yPos[i] = sizeOfMidiBar * i;
    }

    // Initialize an instance listening to port 12000
    oscP5 = new OscP5(this,12001);
    myRemoteLocation = new NetAddress("127.0.0.1", 12001);
    
    // preload the images
    preloadImgs();
    frameRate(30);
}
int offsetFrameNo = 0;
boolean recording = false;
int whichFrame;
int savedFrame = 0; 

void draw() {
    //background(255);
    // image speed
    //if (speed > 2) {
    //   speed -= frameCount/100; // as time progresses, speed factor increases, thereby making the frames change faster
    //} else {
    //  speed += frameCount / 100;
    //}
    if (mappedAmp == 0) {
      mappedAmp = 1;
    }
    if (whichFrame >= numberOfImgs) {
      whichFrame = numberOfImgs - 1;
    }
    else {
      whichFrame = (offsetFrameNo * rangeOfFrames) + (ceil(frameCount/1) % rangeOfFrames);
    }
    image(imgs[whichFrame], (frameCount) % width, pitchY, 100, sizeOfMidiBar);

    if (frameCount % (width) == 0) {
      savedFrame += 1;
      saveFrame("recs/rec2/rec-##.jpg"); // saves frame on the last frame in the width (800)
    }
    if (frameCount % (width + 1) == 0) {
      fill(0);
      rect(0, 0, width, height); // reset the canvas on first frame in frameCount
    } 

    // lines for MIDI bg
    stroke(100);
    for(int i = 1; i < noOfMidi; i++) {
      rect(0, i * sizeOfMidiBar, width, 0.5);
    }
    for(int i = 0; i < 4; i++) {
      rect(i * width/4, 0, 0.5, height);
      
      fill(255);
      textSize(16);
      text(startFrom + (width/4 * i) + (savedFrame * width), (width/4 * i),  height/2); // graphic score marker
    }
}

void oscEvent(OscMessage theOscMessage) {
    float value = theOscMessage.get(0).floatValue();
    
    if (theOscMessage.checkAddrPattern("/amp")) {
      mappedAmp = floor(map(value, 0, 1, 20, 1));
    }
    
    if (theOscMessage.checkAddrPattern("/pitch")) {
      mappedPitch = map(value, minMidi, maxMidi, 1, height); // only on average range
      
      bin = floor(mappedPitch / height * noOfMidi); // which bin will we put the mapped pitch? 
      pitchY = yPos[bin];

      offsetFrameNo = bin;
    }
}

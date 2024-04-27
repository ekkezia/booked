import processing.video.*;
import oscP5.*;
import netP5.*;

Capture video;

// OSC receive
OscP5 oscP5;
NetAddress myRemoteLocation;

int startFrom = 0; // latest rec file no 'rec-###.jpg'
int savedFrames = 0;
int index = 0;

int minMidi = 48;
int maxMidi = 72;
int range = maxMidi - minMidi;
int noOfMidi = range / 2; // default no of midi is 24, but it is too many for us
String[] musicScale = {"C", "C#","D","D#","E","F","F#","G","G#","A","A#","B","C"};

int canvasHeight = 600;
int canvasWidth = canvasHeight * 3/2;
int rowHeight = floor(canvasHeight/noOfMidi);
int colWidth = floor(canvasWidth/4);
int shotHeight = rowHeight;
int shotWidth = shotHeight * 3/2;
int numOfColumns = 4;
int numOfRows;

// This value is set by the OSC event handler
float amplitude = 0;
// Declare a scaling factor
float scale=6;
// Declare a smooth factor
float smooth_factor=0.1;
// Used for smoothing
float sum;
int scaledMidiNum = 1;
int[] yPos = new int[noOfMidi];
int pitchY = 0;
int bin;
float mappedPitch = 0.;
int mappedAmp;

void setup() {
  size(900, 600);
  
  // Initialize an instance listening to port 12000
  oscP5 = new OscP5(this,12001);
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);

  video = new Capture(this, 600, 400);
  video.start();
  
  numOfColumns = width / colWidth;
  numOfRows = height / rowHeight;
  
  // set the yPos
  for(int i = 0; i < noOfMidi; i++) {
    yPos[i] = rowHeight * i;
  }
  
  // MIDI Background
  drawMIDIBackground();
}

void getImage() {
  video.read();
  index++;
}

void drawMIDIBackground() {
  background(0); // todo: change with environment bg
  
  // columns
  for (int i = 0; i < numOfColumns; i++) {
    stroke(255);
    line(i * colWidth, 0, i * colWidth, height);
    
    // Measure Label
    fill(255);
    textSize(16);
    text(startFrom + (i + (savedFrames * numOfColumns)), (colWidth * i),  height/2); // graphic score marker
  }
  // rows
  for (int j = 0; j < numOfRows; j++) {
    stroke(255);
    line(0, j * rowHeight, width, j * rowHeight);
    
    // Pitch Label
    fill(255);
    textSize(16);
    text(musicScale[j], 0, (rowHeight * j) + (rowHeight/2)); // graphic score marker
  }
}
  

void draw() {
  frameRate(2); // todo: follow dj bpm
  getImage();

  // Show images
  int x = (index * shotWidth) % width;
  if (index > 1) {
     // Alter image if it is loud enough, to indicate the "accented beat"
    //if (mappedAmp < 90) {
      //fill(0);
      //rect(x, pitchY, shotWidth, shotHeight);
      //filter(BLUR, 6);
    //}
    image(video, x, pitchY, shotWidth, shotHeight);
  }
  
  // Clean up canvas when reaching the end of width
  int shotsPerFrame = width / shotWidth;
  if (frameCount % shotsPerFrame  == 0) {
    // Save Frame
    //saveFrame("recs/rec-######.png");
    savedFrames += 1;
    // Redraw background
    drawMIDIBackground();
  }
      

}

void oscEvent(OscMessage theOscMessage) {
    float value = theOscMessage.get(0).floatValue();
    
    if (theOscMessage.checkAddrPattern("/amp")) {
      mappedAmp = floor(map(value, 0, 1, 0, 100));
    }
    
    if (theOscMessage.checkAddrPattern("/pitch")) {
      mappedPitch = map(value, minMidi, maxMidi, 1, height); // only on average range
      
      bin = floor(mappedPitch / height * noOfMidi); // which bin will we put the mapped pitch? 
      pitchY = yPos[bin];
    }
}
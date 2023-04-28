int numberOfImgs = 200;
int numberOfFolders = 1; // number of folders to be played. default: 1 because it already requires a lot of memory
int rangeOfFrames = numberOfImgs * numberOfFolders / noOfMidi;

PImage imgs[] = new PImage[numberOfImgs * numberOfFolders];
PImage defaultImg;

void preloadImgs() {
    defaultImg = loadImage("img.png");
    for (int n = 1; n <= numberOfFolders; n++) {
      for (int i = 0; i < numberOfImgs; i++) {
      imgs[i*n] = loadImage("frames-2/"+i+".jpg");
      imgs[i*n].resize(80,60);
    }
  }
}

void img(int whichFrame) {
  image(imgs[whichFrame], 0, 0);
}

void sortedImg() {
  loadPixels();
  // Since we are going to access the image's pixels too
  imgs[0].loadPixels();
    for (int i = 0; i < imgs[0].pixels.length; i++) {
        color pix = imgs[0].pixels[i];
        float br = brightness(pix);
      
        if (br > 40) {
          if (i + 1 < imgs[0].pixels.length) {
            float r = red(imgs[0].pixels[i+1]);
            float g = green(imgs[0].pixels[i+1]);
            float b = blue(imgs[0].pixels[i+1]);
            pixels[i] = color(r,g,b);
           }
          }
    }
  updatePixels();
}

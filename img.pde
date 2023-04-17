void img() {
  loadPixels();
  // Since we are going to access the image's pixels too
  img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
        color pix = img.pixels[i];
        float br = brightness(pix);
      
        if (br > frameCount) {
          if (i + 1 < img.pixels.length) {
            float r = red(img.pixels[i+1]);
            float g = green(img.pixels[i+1]);
            float b = blue(img.pixels[i+1]);
            pixels[i] = color(r,g,b);
           }
          }
    }
  updatePixels();
}

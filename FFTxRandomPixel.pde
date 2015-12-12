class FFTxRandomPixel extends Mode {
  
  int loopCounter = 2300;
  int[] pixelBands;
  int freqThresh = 200;
  int ampFactor = 20;
  
  FFTxRandomPixel(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    delayable = false;
    pixelBands = new int[nPixels];
  }
  
  public void update() {
    for (int i = 0; i < nPixels; i++) {
     int iAmp = constrain((int)bpm.getDetailBand(pixelBands[i]) * ampFactor, 0, 255);
     if (iAmp < freqThresh) {
       fadeOne(i, fadeFactor);
     } else {
       updateOne(i, wheel.getColor(i * pixelOffset, iAmp));
     }
    }
    if (maybe(shiftChance)) {
      shiftSomething();
    }
  }
  
  public void justEntered() {
    assignBands();
  }
  
  public void randomize() {
    if (maybe(4)) {
      assignOneBand(rand.nextInt(nPixels));
    }
    if (maybe(128)) {
      ampFactor = 10 + rand.nextInt(20);
    }
  }
  
  private void assignBands() {
    for (int i = 0; i < nPixels; i++) {
      pixelBands[i] = rand.nextInt(30);
    }
  }
  
  private void assignOneBand(int index) {
    pixelBands[index] = rand.nextInt(30);
  }
  
}
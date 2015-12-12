class Swirl extends Mode {
  
  int addChance = 4;
  int[] circleBands = new int[2];
  int freqThresh = 200;
  int ampFactor = 20;
  
  Swirl(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    delayable = true;
  }
  
  public void justEntered() {
    assignBands();
  }
  
  public void update() {
    rotateSomething();
    if (maybe(shiftChance)) {
      addSomething(false);
    } else {
      addSomething(true);
    }
    updateCircleFFT();
  }
  
  public void onBeat() {
    addSomething(false);
  }
  
  public void randomize() {
    if (maybe(32)) {
      assignOneBand(rand.nextInt(circleBands.length));
    }
    if (maybe(shiftChance)) {
      shiftSomething();
    }
  }
  
  private void updateCircleFFT() {
    Panel[] circles = new Panel[] {eye.panels[C0], eye.panels[C1]};
    for (int p = 0; p < circleBands.length; p++) {
      Panel panel = circles[p];
      int iAmp = constrain(bpm.getBand(circleBands[p]) * ampFactor, 0, 255);
      if (iAmp < freqThresh) {
        panel.fadeAll(fadeFactor);
      } else { 
        panel.updateAll(panelOffset * p, pixelOffset, iAmp);
      }
    }
  }
  
  private void assignBands() {
    for (int i = 0; i < circleBands.length; i++) {
      circleBands[i] = rand.nextInt(10);
    }
  }
  
  private void assignOneBand(int index) {
    circleBands[index] = rand.nextInt(10);
  }
  
}
class Swirl extends Mode {
  
  int addChance = 4;
  int[] circleBands = new int[2];
  boolean[] sideDir = new boolean[] {false, false};
  int freqThresh = 200;
  int ampFactor = 20;
  int maxAdd = 100;
  
  Swirl(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    autoFFT = false;
  }
  
  public void justEntered() {
    assignBands();
  }
  
  public void update() {
    rotateSomething();
    for (int i = 0; i < 20; i++) {
      if (maybe(shiftChance)) {
        addSomething(false);
      } else {
        addSomething(true);
      }
    }
    addSomeToSides();
    rotateSides();
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
    if (maybe(chance)) {
      switch(rand.nextInt(3)) {
        case 0:
          sideDir[0] = !sideDir[0];
          sideDir[1] = !sideDir[1];
          break;
        case 1:
          sideDir[0] = !sideDir[0];
          break;
        case 2:
          sideDir[1] = !sideDir[1];
          break;
      }
    }
  }
  
  private void addSomeToSides() {
    int nRight = rand.nextInt(maxAdd);
    int nLeft = rand.nextInt(maxAdd);
    for (int i = 0; i < nRight; i++) {
      int pixel = rand.nextInt(eye.panels[OR].nPixels);
      eye.panels[OR].updateOne(pixel, i * pixelOffset);
    }
    for (int i = 0; i < nLeft; i++) {
      int pixel = rand.nextInt(eye.panels[OL].nPixels);
      eye.panels[OL].updateOne(pixel, i * pixelOffset);
    }
  }
  
  private void rotateSides() {
    eye.panels[OR].rotate(sideDir[0]);
    eye.panels[OL].rotate(sideDir[1]);
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
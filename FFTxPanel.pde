class FFTxPanel extends Mode {
  
  int[] panelBands = new int[nPanels];
  int freqThresh = 200;
  int ampFactor = 20;
  
  FFTxPanel(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    delayable = false;
  }
  
  public void update() {
    for (int p = 0; p < eye.nPanels; p++) {
      Panel panel = eye.panels[p];
      int iAmp = constrain(bpm.getBand(panelBands[p]) * ampFactor, 0, 255);
      if (iAmp < freqThresh) {
        panel.fadeAll(fadeFactor);
      } else { 
        panel.updateAll(panelOffset * p, pixelOffset, iAmp);
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
    if (maybe(32)) {
      assignOneBand(rand.nextInt(nPanels));
    }
    if (maybe(128)) {
      ampFactor = 10 + rand.nextInt(20);
    }
  }
  
  private void assignBands() {
    for (int i = 0; i < nPanels; i++) {
      panelBands[i] = rand.nextInt(10);
    }
  }
  
  private void assignOneBand(int index) {
    panelBands[index] = rand.nextInt(10);
  }
  
}
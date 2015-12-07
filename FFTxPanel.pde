class FFTxPanel extends Mode {
  
  int loopCounter = 2300;
  int[] panelBands = new int[nPanels];
  int freqThresh = 200;
  int ampFactor = 20;
  
  int[] panelIndex = new int[nPanels];
  
  FFTxPanel() {
    super(true);
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
    wheel.turn(loopOffset);
  }
  
  public void justEntered() {
    assignBands();
  }
  
  public void randomize() {
    if (rand.nextInt(32) == 0) {
      assignOneBand(rand.nextInt(nPanels));
    }
    if (rand.nextInt(128) == 0) {
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
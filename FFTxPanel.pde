class FFTxPanel extends Mode {
  
  FFTxPanel(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    delayable = false;
    autoFFT = false;
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
    
  }
  
  public void randomize() {
    
  }
  
}
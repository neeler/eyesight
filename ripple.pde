class Ripple extends Mode {
  
  int ringOffset = 100;
  
  Ripple(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    delayable = true;
  }
  public void update() {
    for (int r = 0; r < nRings; r++) {
      updateRing(r, ringOffset * r, panelOffset, pixelOffset);
    }
  }
  
}
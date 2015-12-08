class Ripple extends Mode {
  
  Ripple(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    delayable = true;
  }
  public void update() {
    for (int p = 0; p < nRings; p++) {
      updateRing(p, panelOffset, pixelOffset);
    }
  }
  
}
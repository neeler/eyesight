class Ripple extends Mode {
  
  int ringOffset = 100;
  boolean inward = false;
  
  Ripple(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    delayable = true;
  }
  public void update() {
    for (int r = 0; r < nRings; r++) {
      if (inward)
        updateRing(r, ringOffset * r, panelOffset, pixelOffset);
      else
        updateRing(r, ringOffset * (nRings - 1 - r), panelOffset, pixelOffset);
    }
  }
  
  public void randomize() {
    if (rand.nextInt(chance) == 0) {
      inward = !inward;
    }
  }
  
}
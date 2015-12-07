class Trace extends Mode {
  
  boolean clockwise = true;
  int speed = 2;
  
  int[] panelIndex = new int[nPanels];
  
  Trace(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    delayable = true;
  }
  
  public void update() {
    for (int p = 0; p < eye.nPanels; p++) {
      Panel panel = eye.panels[p];
      updateOne(p, panelIndex[p], wheel.getColor(panelOffset * p));
      if (clockwise) panelIndex[p] = (panelIndex[p] + speed) % panel.nPixels;
      else panelIndex[p] = (panelIndex[p] - speed + panel.nPixels) % panel.nPixels;
    }
  }
  
  public void justEntered() {
    resetPIs();
    clockwise = (rand.nextInt(2) == 0);
  }
  
  public void resetPIs() {
    for (int i = 0; i < nPanels; i++) {
      panelIndex[i] = rand.nextInt(eye.panels[i].nPixels);
    }
  }
  
  public void randomize() {
    if (rand.nextInt(chance) == 0) {
      clockwise = !clockwise;
    }
  }
  
}
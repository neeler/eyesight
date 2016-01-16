class Trace extends Mode {
  
  boolean clockwise = true;
  int speed = 2;
  
  int[] panelIndex = new int[nPanels];
  
  Trace(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
  }
  
  public void update() {
    for (int p = 0; p < nPanels; p++) {
      Panel panel = eye.panels[p];
      int index = panelIndex[p];
      updateOne(p, index, wheel.getColor(panelOffset * p));
      if (clockwise) panelIndex[p] = (index + speed) % panel.nPixels;
      else panelIndex[p] = (index - speed + panel.nPixels) % panel.nPixels;
    }
  }
  
  public void justEntered() {
    resetPIs();
    clockwise = randBool();
  }
  
  public void resetPIs() {
    for (int i = 0; i < nPanels; i++) {
      panelIndex[i] = rand.nextInt(eye.panels[i].nPixels);
    }
  }
  
  public void randomize() {
    if (maybe(chance)) {
      clockwise = !clockwise;
    }
  }
  
}
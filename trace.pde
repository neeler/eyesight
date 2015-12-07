class Trace extends Mode {
  
  int loopOffset = 1;
  int loopCounter = 2300;
  int panelOffset = 10;
  boolean clockwise = true;
  int speed = 2;
  
  int[] panelIndex = new int[nPanels];
  
  Trace() {
    super(true);
    delayable = true;
  }
  
  public void update() {
    for (int p = 0; p < eye.nPanels; p++) {
      Panel panel = eye.panels[p];
      updateByIndex(p, panelIndex[p], targetColor(panelIndex[p] + panelOffset, panel.nPixels));
      if (clockwise) panelIndex[p] = (panelIndex[p] + speed) % panel.nPixels;
      else panelIndex[p] = (panelIndex[p] - speed + panel.nPixels) % panel.nPixels;
    }
    loopOffset = (int) map(mouseY, height, 0, 0, wheel.nColors()/20);
    wheel.turn(loopOffset);
    loopCounter = (loopCounter + 1) % 3927;
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
  
  private int[] targetColor(int i, int nPixels) {
    float sinFactor = (1.875 * sin(0.0016 * loopCounter)) + 2.125;
    float colorSpread = wheel.nColors() * sinFactor;
    float pixelStep = colorSpread / nPixels;
    int[] c = wheel.getColor((int) (pixelStep * i));
    return c;
  }
  
}
class GradientWipe extends Mode {
  
  int loopOffset = 1;
  int loopCounter = 2300;
  int panelOffset = 10;
  
  GradientWipe() {
    super(true);
    delayable = true;
  }
  
  public void update() {
    for (int p = 0; p < eye.nPanels; p++) {
      Panel panel = eye.panels[p];
      for (int i = 0; i < panel.nPixels; i++) {
        updateByIndex(p, i, targetColor(i + panelOffset, panel.nPixels));
      }
    }
    loopOffset = (int) map(mouseY, height, 0, 0, wheel.nColors()/20);
    wheel.turn(loopOffset);
    loopCounter = (loopCounter + 1) % 3927;
  }
  
  private int[] targetColor(int i, int nPixels) {
    float sinFactor = (1.875 * sin(0.0016 * loopCounter)) + 2.125;
    float colorSpread = wheel.nColors() * sinFactor;
    float pixelStep = colorSpread / nPixels;
    int[] c = wheel.getColor((int) (pixelStep * i));
    return c;
  }
  
}
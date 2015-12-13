class GradientWipe extends Mode {
  
  int loopCounter = 2300;
  
  GradientWipe(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
  }
  
  public void update() {
    for (int p = 0; p < eye.nPanels; p++) {
      Panel panel = eye.panels[p];
      for (int i = 0; i < panel.nPixels; i++) {
        updateOne(p, i, targetColor(i + panelOffset * p));
      }
    }
    loopCounter = (loopCounter + 1) % 3927;
  }
  
  private int[] targetColor(int i) {
    float sinFactor = (2.875 * sin(0.0016 * loopCounter)) + 3.125;
    float colorSpread = wheel.nColors() * sinFactor;
    float pixelStep = colorSpread / nPixels;
    int[] c = wheel.getColor((int) (pixelStep * i));
    return c;
  }
  
}
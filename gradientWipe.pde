class GradientWipe extends Mode {
  
  int loopCounter = 2300;
  float sinFactor, colorSpread, pixelStep;
  
  GradientWipe(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
  }
  
  public void update() {
    calcSin();
    for (int p = 0; p < nPanels; p++) {
      Panel panel = eye.panels[p];
      int nPanPix = panel.nPixels;
      for (int i = 0; i < nPanPix; i++) {
        updateOne(p, i, targetColor(i + panelOffset * p));
      }
    }
    loopCounter = (loopCounter + 1) % 3927;
  }
  
  private void calcSin() {
    sinFactor = (2.875 * sin(0.0016 * loopCounter)) + 3.125;
    colorSpread = wheel.nColors() * sinFactor;
    pixelStep = colorSpread / nPixels;
  }
  
  private int[] targetColor(int i) {
    int[] c = wheel.getColor(round(pixelStep * i));
    return c;
  }
  
}
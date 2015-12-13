class Sparkle extends Mode {
  
  int nLoopAdd = 10;
  int nBeatAdd = 50;
  
  Sparkle(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    delayable = false;
  }
  
  public void update() {
    for (int i = 0; i < nLoopAdd; i++) {
      addSomething(true);
    }
  }
  
  public void onBeat() {
    for (int i = 0; i < nBeatAdd; i++) {
      addSomething(true);
    }
  }
  
}
class Pulse extends Mode {
  
  int pulseOffset = 750;
  boolean inward = true;
  
  int skipRing = 3;
  boolean skip = true;
  
  Pulse(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
  }
  public void update() {
    skip = mouseBoolean;
    if (skip) {
      shiftRings(wheel.getColor(0), inward, skipRing);
      updateRing(skipRing, 325, 100, 2);
    } else {
      shiftRings(wheel.getColor(0), inward);
    }
  }
  
  public void onBeat() {
    if (inward) {
      updateRing(nRings - 1, 0, 0);
    } else {
      updateRing(0, pulseOffset, 0, 0);
    }
  }
  
  public void randomize() {
    if (maybe(chance)) {
      inward = !inward;
    }
  }
  
}
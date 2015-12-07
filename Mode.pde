/********************************
functions to implement for modes that implement the Mode class:

public void update()
  Behavior that should happen every update.
public void onBeat()
  Behavior that should happen only on the beat.
public void randomize()
  Behavior that should randomly happen sometimes on the beat.
********************************/

class Mode {
  
  boolean justEntered = true;
  boolean delayable = false;
  boolean fadeBeforeUpdate = true;
  int prevTime;
  int nPixels, nPanels;
  
  Mode(boolean fadeBeforeUpdate, int nPixels, int nPanels) {
    this.fadeBeforeUpdate = fadeBeforeUpdate;
    this.prevTime = millis();
    this.nPixels = nPixels;
    this.nPanels = nPanels;
  }
  
  // Delay update if relevant.
  public void advance() {
    int time = millis();
    if (!delayable) {
      superUpdate();
    } else if ((time - prevTime) >= globalDelay) {
      superUpdate();
      prevTime = time;
    }
    if (drawFFT) drawFFT();
  }
  
  public void superUpdate() {
    if (fadeBeforeUpdate) {
      fadeAll(fadeFactor);
    }
    if (justEntered) {
      justEntered();
    }
    if (bpm.isBeat()) {
     superOnBeat();
     randomize();
    }
    update();
    wheel.turn(loopOffset);
    justEntered = false;
  }
  
  public void update() {
    // Behavior that should happen every update.
  }
  
  public void superOnBeat() {
    wheel.turn(beatOffset);
    onBeat();
  }
  
  public void onBeat() {
    // Behavior that should only happen on the beat.
  }
  
  public void justEntered() {
    // Called after fade before update if this mode has just been entered.
  }
  
  public void superRandomize() {
    if (rand.nextInt(chance) == 0) {
      wheel.newScheme();
    }
    randomize();
  }
  
  public void randomize() {
    // Behavior that should randomly happen sometimes on the beat.
  }
  
  
  public void toggle(int t) {
    // Trigger toggles here.
  }
  
  public void fadeAll(float factor) {
    for (Panel panel : eye.panels) {
      panel.fadeAll(factor);
    }
  }
  
  public void fadeOne(int index, float factor) {
    int p;
    for (p = 0; p < nPanels; p++) {
      if (index < eye.panels[p].nPixels) break;
      else index -= eye.panels[p].nPixels;
    }
    fadeOne(p, index, factor);
  }
  
  public void fadeOne(int panel, int index, float factor) {
    eye.panels[panel].fadeOne(index, factor);
  }
  
  public void fadePanel(int panel, float factor) {
    eye.panels[panel].fadeAll(factor);
  }
  
  public void updateOne(int index, int[] c) {
    int p;
    for (p = 0; p < nPanels; p++) {
      if (index < eye.panels[p].nPixels) break;
      else index -= eye.panels[p].nPixels;
    }
    updateOne(p, index, c);
  }
  
  public void updateOne(int panel, int index, int[] c) {
    eye.panels[panel].updateOne(index, c);
  }
  
  public void enter() {
    justEntered = true;
  }
  
  public void drawFFT() {
    float dx = width / bpm.bands;
    for (int i = 0; i < bpm.bands; i++) {
      float dy = map(bpm.getDetailBand(i), 0, 255, 0, height/4);
      stroke(eye.panelEdges);
      strokeWeight(4);
      int[] c = wheel.getColor((int) map(i, 0, bpm.bands, 0, wheel.nColors));
      fill(c[0], c[1], c[2]);
      rect(i * dx, height - dy, dx/2, dy);
      float ltY = bpm.totalLong[i];
      float stY = bpm.totalShort[i];
      ltY = map(ltY, 0, 255, 0, height/4);
      c = wheel.getColor((int) map(i, 0, bpm.bands, 0, wheel.nColors) + wheel.nColors/2);
      fill(c[0], c[1], c[2]);
      rect(i * dx + dx/2, height - ltY, dx/2, ltY);
    }
  }
  
}
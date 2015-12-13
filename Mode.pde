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
  boolean autoFFT = true;
  boolean fadeBeforeUpdate = true;
  int prevTime;
  int nPixels, nPanels;
  
  int nRings = 6;
  int[][] rings = new int[][] { {C0},
                                {RT},
                                {R0, R1, R2, R3, R4},
                                {C1},
                                {OT, OR, OL},
                                {OBR, OBL} };
                                
  int[] panelBands;
  int freqThresh = 200;
  int ampFactor = 20;
  
  Mode(boolean fadeBeforeUpdate, int nPixels, int nPanels) {
    this.fadeBeforeUpdate = fadeBeforeUpdate;
    this.prevTime = millis();
    this.nPixels = nPixels;
    this.nPanels = nPanels;
    panelBands = new int[nPanels];
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
      assignPanelBands();
      justEntered();
    }
    if (bpm.isBeat()) {
     superOnBeat();
     randomize();
    }
    update();
    if (autoFFT & panelFFT) {
      applyPanelsFFT();
    }
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
    if (maybe(32)) {
      assignOnePanelBand(rand.nextInt(nPanels));
    }
    if (maybe(128)) {
      ampFactor = 10 + rand.nextInt(20);
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
  
  public void updateRing(int index, int[] c) {
    for(int i = 0; i < rings[index].length; i++){
      Panel panel = eye.panels[rings[index][i]];
      panel.updateAll(c);
    }
  }
  
  public void updateRing(int index, int panelOffset, int pixelOffset) {
    for(int i = 0; i < rings[index].length; i++){
      Panel panel = eye.panels[rings[index][i]];
      panel.updateAll(panelOffset * i, pixelOffset);
    }
  }
  
  public void updateRing(int index, int wheelPos, int panelOffset, int pixelOffset) {
    for(int i = 0; i < rings[index].length; i++){
      Panel panel = eye.panels[rings[index][i]];
      panel.updateAll(wheelPos + panelOffset * i, pixelOffset);
    }
  }
  
  public void shiftRings(int[] c, boolean inward) {
    if (inward) {
      for (int i = 0; i < nRings - 1; i++) {
        updateRing(i, averageRing(i + 1));
      }
      updateRing(nRings - 1, c);
    } else {
      for (int i = nRings - 1; i > 0; i--) {
        updateRing(i, averageRing(i - 1));
      }
      updateRing(0, c);
    }
  }
  
  public void shiftRings(int[] c, boolean inward, int startR, int endR) {
    startR = constrain(startR, 0, nRings - 1);
    endR = constrain(endR, 0, nRings - 1);
    if (startR >= endR) return;
    if (inward) {
      for (int i = startR; i < endR; i++) {
        updateRing(i, averageRing(i + 1));
      }
      updateRing(endR, c);
    } else {
      for (int i = endR; i > startR; i--) {
        updateRing(i, averageRing(i - 1));
      }
      updateRing(startR, c);
    }
  }
  
  // shift all but skipRing
  public void shiftRings(int[] c, boolean inward, int skipRing) {
    if (skipRing == 0) {
      shiftRings(c, inward, 1, nRings - 1);
      return;
    } else if (skipRing == nRings - 1) {
      shiftRings(c, inward, 0, nRings - 2);
      return;
    }
    if (inward) {
      for (int i = 0; i < nRings - 1; i++) {
        if (i == skipRing - 1) {
          i++;
          updateRing(i - 1, averageRing(i + 1));
        } else {
          updateRing(i, averageRing(i + 1));
        }
      }
      updateRing(nRings - 1, c);
    } else {
      for (int i = nRings - 1; i > 0; i--) {
        if (i == skipRing + 1) {
          i--;
          updateRing(i + 1, averageRing(i - 1));
        } else {
          updateRing(i, averageRing(i - 1));
        }
      }
      updateRing(0, c);
    }
  }
  
  public int[] averageRing(int index) {
    int[] c = new int[] {0, 0, 0};
    int nPan = rings[index].length;
    for (int i = 0; i < nPan; i++) {
      int[] panelAverage = eye.panels[rings[index][i]].getAverage();
      c[0] += panelAverage[0];
      c[1] += panelAverage[1];
      c[2] += panelAverage[2];
    }
    c[0] = round(c[0]/nPan);
    c[1] = round(c[1]/nPan);
    c[2] = round(c[2]/nPan);
    return c;
  }
  
  public void rotateRingPanels(int index, boolean clockwise) {
    int nPan = rings[index].length;
    for (int i = 0; i < nPan; i++) {
      eye.panels[rings[index][i]].rotate(clockwise);
    }
  }
  
  public void rotateRing(int index, boolean clockwise) {
    int nPan = rings[index].length;
    if (clockwise) {
      int[] lastC = eye.panels[rings[index][nPan - 1]].getAverage();
      for (int i = nPan - 1; i > 0; i--) {
        int[] panelAve = eye.panels[rings[index][i - 1]].getAverage();
        eye.panels[rings[index][i]].updateAll(panelAve);
      }
      eye.panels[rings[index][0]].updateAll(lastC);
    } else {
      int[] firstC = eye.panels[rings[index][0]].getAverage();
      for (int i = 0; i < nPan - 1; i++) {
        int[] panelAve = eye.panels[rings[index][i + 1]].getAverage();
        eye.panels[rings[index][i]].updateAll(panelAve);
      }
      eye.panels[rings[index][nPan - 1]].updateAll(firstC);
    }
  }
  
  public void shiftSomething() {
    int nShifts = 5;
    int choice = rand.nextInt(nShifts);
    boolean dir = randBool();
    int skipRing, panel, ring;
    switch(choice) {
      case 0:
        shiftRings(wheel.getColor(0), dir);
        break;
      case 1:
        skipRing = rand.nextInt(nRings);
        shiftRings(wheel.getColor(0), dir, skipRing);
        break;
      case 2:
        panel = rand.nextInt(nPanels);
        eye.panels[panel].rotate(dir);
        break;
      case 3:
        ring = rand.nextInt(nRings);
        rotateRingPanels(ring, dir);
        break;
      case 4:
        ring = rand.nextInt(nRings);
        rotateRing(ring, dir);
        break;
    }
  }
  
   public void rotateSomething() {
    int nRot = 2;
    int choice = rand.nextInt(nRot);
    boolean dir = randBool();
    int panel, ring;
    switch(choice) {
      case 0:
        panel = rand.nextInt(nPanels);
        eye.panels[panel].rotate(dir);
        break;
      case 1:
        ring = rand.nextInt(nRings);
        rotateRingPanels(ring, dir);
        break;
    }
  }
  
  public void addSomething(boolean justOne) {
    int nAdds = justOne ? 1 : 3;
    int choice = rand.nextInt(nAdds);
    int pixel, panel, ring;
    switch(choice) {
      case 0:
        panel = rand.nextInt(nPanels);
        pixel = rand.nextInt(eye.panels[panel].nPixels);
        eye.panels[panel].updateOne(pixel, 0);
        break;
      case 1:
        panel = rand.nextInt(nPanels);
        eye.panels[panel].updateAll(pixelOffset);
        break;
      case 2:
        ring = rand.nextInt(nRings);
        updateRing(ring, panelOffset, pixelOffset);
        break;
    }
  }
  
  public void setCogs(int p, int start, int nCogs) {
    Panel panel = eye.panels[p];
    float space = 1.0 * panel.nPixels / nCogs;
    int count = 0;
    for (int j = start; j < panel.nPixels + start; j++) {
      int i = j % panel.nPixels;
      if (round(count * space) - (j - start) == 0) {
        panel.updateOne(i, p * panelOffset + i * pixelOffset);
        count++;
      } else {
        panel.updateOne(i, new int[] {0, 0, 0});
      }
    }
  }
  
  public void enter() {
    justEntered = true;
  }
  
  public void applyPanelsFFT() {
    for (int i = 0; i < nPanels; i++) {
      int iAmp = constrain(bpm.getBand(panelBands[i]) * ampFactor, 0, 255);
      if (iAmp < freqThresh) {
        //
      } else { 
        //
      }
      eye.panels[i].applyBrightnessAll(iAmp);
    }
  }
  
  private void assignPanelBands() {
    for (int i = 0; i < nPanels; i++) {
      panelBands[i] = rand.nextInt(10);
    }
  }
  
  private void assignOnePanelBand(int index) {
    panelBands[index] = rand.nextInt(10);
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
  
  public boolean randBool() {
    return (maybe(2));
  }
  
}
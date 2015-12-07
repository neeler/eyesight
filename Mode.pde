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
  
  Mode(boolean fadeBeforeUpdate) {
    this.fadeBeforeUpdate = fadeBeforeUpdate;
    this.prevTime = millis();
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
  }
  
  public void superUpdate() {
    if (fadeBeforeUpdate) {
      fadeAll(fadeFactor);
    }
    if (justEntered) {
      justEntered();
    }
    //if (bpm.isBeat()) {
    //  onBeat();
    //  randomize();
    //}
    update();
    justEntered = false;
  }
  
  public void update() {
    // Behavior that should happen every update.
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
    eye.fadeAll(factor);
  }
  
  public void fadeOne(int panel, int index, float factor) {
    eye.panels[panel].fadeOne(index, factor);
  }
  
  public void fadePanel(int panel, float factor) {
    eye.panels[panel].fadeAll(factor);
  }
  
  public void updateByIndex(int panel, int index, int[] c) {
    eye.panels[panel].updateOne(index, c);
  }
  
  public void enter() {
    justEntered = true;
  }
  
}
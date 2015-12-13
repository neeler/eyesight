class Gears extends Mode {
  
  int[] gearIndex;
  int nGears;
  Panel[] gears;
  int[] gearPos;
  boolean[] gearDir;
  int[] nCogs;
  int[] gearSpeed;
  int minSpeed = 20;
  int maxSpeed = 100;
  int freqThresh = 200;
  int ampFactor = 20;
  int maxAdd = 100;
  int minCogRatio = 20;
  int maxCogRatio = 5;
  
  Gears(int nPixels, int nPanels) {
    super(true, nPixels, nPanels);
    delayable = true;
    // gearIndex = new int[] {C0, C1};
    gearIndex = new int[nPanels];
    nGears = gearIndex.length;
    gears = new Panel[nGears];
    gearPos = new int[nGears];
    gearDir = new boolean[nGears];
    nCogs = new int[nGears];
    gearSpeed = new int[nGears];
    for (int i = 0; i < nGears; i++) {
      gearIndex[i] = i;
    }
  }
  
  public void justEntered() {
    for (int i = 0; i < nGears; i++) {
      gears[i] = eye.panels[gearIndex[i]];
      gearPos[i] = rand.nextInt(gears[i].nPixels);
      gearDir[i] = randBool();
      int maxCogs = ceil(gears[i].nPixels / maxCogRatio);
      int minCogs = ceil(gears[i].nPixels / minCogRatio);
      nCogs[i] = rand.nextInt(maxCogs - minCogs) + minCogs;
      gearSpeed[i] = rand.nextInt(maxSpeed - minSpeed) + minSpeed;
    }
  }
  
  public void update() {
    for (int i = 0; i < nGears; i++) {
      setCogs(gearIndex[i], gearPos[i], nCogs[i]);
    }
    rotateGearPos();
  }
  
  public void onBeat() {
  }
  
  public void randomize() {
    if (maybe(chance)) {
      int i = rand.nextInt(nGears);
      gearDir[i] = !gearDir[i];
    }
    if (maybe(chance)) {
      int i = rand.nextInt(nGears);
      int maxCogs = ceil(gears[i].nPixels / maxCogRatio);
      int minCogs = ceil(gears[i].nPixels / minCogRatio);
      nCogs[i] = rand.nextInt(maxCogs - minCogs) + minCogs;
    }
    if (maybe(chance)) {
      int i = rand.nextInt(nGears);
      gearSpeed[i] = rand.nextInt(maxSpeed - minSpeed) + minSpeed;
    }
  }
  
  private void rotateGearPos() {
    for (int i = 0; i < nGears; i++) {
      gearPos[i] = (gearPos[i] +
                    gears[i].nPixels +
                    (gearDir[i] ? 1 : -1)) % gears[i].nPixels;
    }
  }
  
}
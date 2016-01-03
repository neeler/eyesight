class Eye {
  
  // Pixel data
  int[][] colors;
  int nPixels;
  
  // Panel data
  Panel[] panels;
  int nPanels = 13;
  
  // Mode data
  Mode[] modes;
  int mode = 8;
  int nModes = 9;
  
  // Shapes
  PShape back, first, second, third;
  PShape[] shields = new PShape[5];
  PShape lights;
  int deltaZ = 25;
  color panelEdges = color(30,30,30);
  float centerBrightness = 0;
  
  // Strips
  int[][] strips = {{R4, R0, R1, R2, R3, RT},
                    {OR, OL},
                    {OBR, OBL},
                    {C0},
                    {C1},
                    {OT}};
  
  Eye() {
    lights = loadShape("lights.svg");
    float scale = 1.0 * screenSize / 1500;
    lights.scale(scale);
    panels = new Panel[nPanels];
    PShape R = lights.getChild("R");
    panels[RT] = new Panel(R.getChild("RT"), RT, 2);
    panels[R0] = new Panel(R.getChild("R0"), R0, 2);
    panels[R1] = new Panel(R.getChild("R1"), R1, 2);
    panels[R2] = new Panel(R.getChild("R2"), R2, 2);
    panels[R3] = new Panel(R.getChild("R3"), R3, 2);
    panels[R4] = new Panel(R.getChild("R4"), R4, 2);
    panels[C0] = new Panel(lights.getChild("C0"), C0, 0);
    panels[C1] = new Panel(lights.getChild("C1"), C1, 0);
    panels[OT] = new Panel(lights.getChild("OT"), OT, 0);
    panels[OR] = new Panel(lights.getChild("OR"), OR, 1);
    panels[OBR] = new Panel(lights.getChild("OBR"), OBR, 0);
    panels[OBL] = new Panel(lights.getChild("OBL"), OBL, 0);
    panels[OL] = new Panel(lights.getChild("OL"), OL, 1);
    
    nPixels = 0;
    for (int i = 0; i < nPanels; i++) nPixels += panels[i].nPixels;
    
    shields[0] = loadShape("back.svg");
    shields[1] = loadShape("first.svg");
    shields[2] = loadShape("second.svg");
    shields[3] = loadShape("third.svg");
    shields[4] = loadShape("fourth.svg");
    for (PShape shield : shields) {
      shield.scale(scale);
      shield.setStroke(panelEdges);
    }
    
    modes = new Mode[nModes];
    modes[0] = new GradientWipe(nPixels, nPanels);
    modes[1] = new Trace(nPixels, nPanels);
    modes[2] = new FFTxPanel(nPixels, nPanels);
    modes[3] = new FFTxRandomPixel(nPixels, nPanels);
    modes[4] = new Ripple(nPixels, nPanels);
    modes[5] = new Pulse(nPixels, nPanels);
    modes[6] = new Swirl(nPixels, nPanels);
    modes[7] = new Gears(nPixels, nPanels);
    modes[8] = new Sparkle(nPixels, nPanels);
  }
  
  public void draw() {
    translate(0, 0);
    pushMatrix();
    translate(-width/2, -height/2);
    for (Panel panel : panels) {
      panel.draw();
    }
    popMatrix();
    drawShields();
  }
  
  public void send() {
    //for (int i = 0; i < nPanels; i++) {
    //  panels[i].send();
    //}
    for (int s = 0; s < strips.length; s++) {
      int pixSoFar = 0;
      for (int p = 0; p < strips[s].length; p++) {
        Panel panel = panels[strips[s][p]];  
        for (int i = 0; i < panel.nPixels; i++) {
          int[] c = panel.colors[i];
          opc.setPixel(i + s * pixelsPerStrip + pixSoFar, c[0] << 16 | c[1] << 8 | c[2]);
        }
        pixSoFar += panel.nPixels;
      }
    }
    opc.writePixels();
  }
  
  public void reset() {
    for (Panel panel : panels) {
      panel.reset();
    }
  }
  
  // Step forward whichever mode is active.
  public void update() {
    modes[mode].advance();
  }
  
  // Randomization.
  public void randomize() {
    if (modeSwitching && maybe(modeChance)) {
      int newMode = rand.nextInt(nModes);
      setMode(newMode);
    }
  }
  
  // Set the current mode.
  public void setMode(int m) {
    mode = m % nModes;
    modes[mode].enter();
  }
  
  public void newScheme() {
    wheel.newScheme();
  }
  
  public void setVibe(int v) {
    wheel.setVibe(v);
    wheel.newScheme();
  }
  
  public void drawShields() {
    translate(-width/2, -height/2);
    flashCenter(drawFFT);
    for (int i = 0; i < shields.length; i++) {
      shape(shields[i]);
      translate(0,0,deltaZ);
    }
  }
  
  public void flashCenter(boolean flash) {
    int[] c;
    if (flash) {
      if (bpm.isBeat) {
        centerBrightness = 255;
        c = wheel.getColor(0, (int) centerBrightness);
      } else {
        centerBrightness = centerBrightness * fadeFactor;
        c = wheel.getColor(0, (int) centerBrightness);
      }
    } else {
      centerBrightness = 0;
      c = new int[] {0, 0, 0};
    }
    shields[4].getChild(0).getChild("CENTER").setFill(color(c[0], c[1], c[2]));
  }
  
}
class Eye {
  
  // Pixel data
  int[][] colors;
  int nPixels;
  
  // Panel data
  Panel[] panels;
  int nPanels = 13;
  
  // Mode data
  Mode[] modes;
  int mode = 0;
  int nModes = 1;
  
  // Shapes
  PShape back, first, second, third;
  PShape[] shields = new PShape[5];
  PShape lights;
  int deltaZ = 25;
  
  Eye() {
    lights = loadShape("lights.svg");
    panels = new Panel[nPanels];
    PShape R = lights.getChild("R");
    panels[RT] = new Panel(R.getChild("RT"),2);
    panels[R0] = new Panel(R.getChild("R0"),2);
    panels[R1] = new Panel(R.getChild("R1"),2);
    panels[R2] = new Panel(R.getChild("R2"),2);
    panels[R3] = new Panel(R.getChild("R3"),2);
    panels[R4] = new Panel(R.getChild("R4"),2);
    panels[C0] = new Panel(lights.getChild("C0"),0);
    panels[C1] = new Panel(lights.getChild("C1"),0);
    panels[OT] = new Panel(lights.getChild("OT"),0);
    panels[OR] = new Panel(lights.getChild("OR"),1);
    panels[OBR] = new Panel(lights.getChild("OBR"),0);
    panels[OBL] = new Panel(lights.getChild("OBL"),0);
    panels[OL] = new Panel(lights.getChild("OL"),1);
    
    shields[0] = loadShape("back.svg");
    shields[1] = loadShape("first.svg");
    shields[2] = loadShape("second.svg");
    shields[3] = loadShape("third.svg");
    shields[4] = loadShape("fourth.svg");
    color panelEdges = color(100,100,100);
    for (PShape shield : shields) {
      shield.setStroke(panelEdges);
    }
    
    modes = new Mode[nModes];
    modes[0] = new GradientWipe();
  }
  
  public void draw() {
    translate(0, 0);
    background(0);
    pushMatrix();
    translate(-width/2, -height/2);
    for (Panel panel : panels) {
      panel.draw();
    }
    popMatrix();
    drawShields();
  }
  
  public void send() {
    for (Panel panel : panels) {
      panel.send();
    }
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
    if (modeSwitching && rand.nextInt(modeChance) == 0) {
      int newMode = rand.nextInt(nModes);
      setMode(newMode);
    }
  }
  
  // Set the current mode.
  public void setMode(int m) {
    mode = m % nModes;
    modes[mode].enter();
  }
  
  public void fadeAll(float factor) {
    for (Panel panel : panels) {
      panel.fadeAll(factor);
    }
  }
  
  public void drawShields() {
    translate(-width/2, -height/2);
    for (int i = 0; i < shields.length; i++) {
      shape(shields[i]);
      translate(0,0,deltaZ);
    }
  }
  
}
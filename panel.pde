class Panel {
  
  // Pixel data
  int[][] colors;
  int nPixels;
  int z;
  
  
  PShape shape;
  int alpha = 200;
  int iOffset;
  
  Panel(PShape shape, int z) {
    this.shape = shape;
    shape.setStroke(false);
    this.nPixels = shape.getChildCount();
    colors = new int[nPixels][3];
    this.z = z;
    reset();
  }
  
  public void draw() {
    pushMatrix();
    translate(0,0,5 + z * 25);
    for (int iO = iOffset; iO < iOffset + nPixels; iO++) {
      int i = iO % nPixels;
      PShape pixel = shape.getChild(i);
      pixel.setFill(color(colors[i][0], colors[i][1], colors[i][2], alpha));
      shape(pixel);
    }
    popMatrix();
    //iOffset = (iOffset + 1) % nPixels;
  }
  
  // For sending the pixel data to the fadecandy via OPC.
  public void send() {
    for (int i = 0; i < nPixels; i++) {
      opc.setPixel(i, colors[i][0] << 16 | colors[i][1] << 8 | colors[i][2]);
    }
    opc.writePixels();
  }
  
  // Reset all pixel data to black (off).
  public void reset() {
    for (int i = 0; i < nPixels; i++) {
      for (int j = 0; j < 3; j++) {
        colors[i][j] = 0;
      }
    }
  }
  
  public void fadeAll(float factor) {
    for (int i = 0; i < nPixels; i++) {
      fadeOne(i, factor);
    }
  }
  
  public void fadeOne(int index, float factor) {
    colors[index][0] = int(colors[index][0] * factor);
    colors[index][1] = int(colors[index][1] * factor);
    colors[index][2] = int(colors[index][2] * factor);
  }
  
  public void updateOne(int index, int[] c) {
    colors[index] = c;
    iOffset = (index + 1) % nPixels;
  }
  
  public void updateOne(int index, int offset) {
    colors[index] = wheel.getColor(offset);
    iOffset = (index + 1) % nPixels;
  }
  
  public void updateAll(int[] c) {
    for (int i = 0; i < nPixels; i++) {
      colors[i][0] = c[0];
      colors[i][1] = c[1];
      colors[i][2] = c[2];
    }
  }
  
  public void updateAll(int offset) {
    updateAll(0, offset);
  }
  
  public void updateAll(int wheelPos, int offset) {
    updateAll(wheelPos, offset, 255);
  }
  
  public void updateAll(int wheelPos, int offset, int brightness) {
    for (int i = 0; i < nPixels; i++) {
      int[] c = wheel.getColor(wheelPos + offset * i, brightness);
      colors[i] = c;
    }
  }
  
  public int[] getAverage() {
    int r, g, b;
    r = g = b = 0;
    for (int i = 0; i < nPixels; i++) {
      r += colors[i][0];
      g += colors[i][1];
      b += colors[i][2];
    }
    r = round(r/nPixels);
    g = round(g/nPixels);
    b = round(b/nPixels);
    return new int[] {r, g, b};
  }
}
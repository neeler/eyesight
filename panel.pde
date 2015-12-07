class Panel {
  
  // Pixel data
  int[][] colors;
  int nPixels;
  int z;
  
  
  PShape shape;
  int alpha = 150;
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
  }
  
  public void updateOne(int index, int offset) {
    colors[index] = wheel.getColor(offset);
  }
  
}
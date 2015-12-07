class ColorWheel {
  
  public int vibe = 0;
  
  private int nColors;
  private int wheelPos = 0;

  private int[][][] presets = {
    { {255, 200, 200}, {255, 255, 255}, {200, 200, 255} }, // pink white - white - blue white
    { {200, 200, 255}, {255, 0, 255}, {255, 200, 200} }, // blue white - purple - pink white
    { {200, 200, 255}, {255, 125, 255}, {255, 240, 200} }, // blue white - purple - orange white
    { {255, 0, 0}, {0, 255, 0}, {0, 0, 255} }, //rainblow
    { {255, 0, 0}, {177, 67, 226}, {0, 0, 255} }, // red purple blue
    { {218, 107, 44}, {240, 23, 0}, {147, 0, 131} }, // snowskirt
    { {0, 0, 255}, {128, 0, 255}, {128, 0, 128} }, // royal
    { {122, 0, 255}, {0, 0, 255}, {0, 88, 205} }, // cool
    { {255, 0, 196}, {196, 0, 255}, {209, 209, 209} }, // dork
    { {177, 0, 177}, {77, 17, 71}, {247, 77, 7} }, // sevens
    { {128, 0, 255}, {255, 0, 128}, {255, 128, 0} }, // orpal
    { {255, 128, 0}, {0, 0, 255}, {255, 230, 255} } // orange - blue - white
  };

  private int[][] scheme = { {255, 0, 0}, {0, 255, 0}, {0, 0, 255} };

  ColorWheel(int nColors) {
    this.nColors = nColors;
    newScheme();
  }
  
  public void turn(int step) {
    wheelPos = (wheelPos + step) % nColors;
  }
  
  public int[] getColor(int offset) {
    return getColor(offset, 255);
  }

  public int[] getColor(int offset, int brightness) {
    int schemeLength = scheme.length;
    int dist = nColors / schemeLength;
    int[] c = new int[3];
    int position = (wheelPos + offset) % nColors;
    
    for (int i = 0; i < schemeLength; i++) {
      if (position < (i + 1) * dist) {
        c = genColor(position, i, scheme, dist);
        c = applyBrightness(c, (int) map(brightness, 0, 255, 0, globalBrightness));
        return c;
      }
    }
    c = genColor(position, schemeLength - 1, scheme, dist);
    c = applyBrightness(c, (int) map(brightness, 0, 255, 0, globalBrightness));
    return c;
  }
  
  public int[] applyBrightness(int[] c, int brightness) {
    int[] newC = new int[3];
    newC[0] = int(map(brightness, 0, 255, 0, c[0]));
    newC[1] = int(map(brightness, 0, 255, 0, c[1]));
    newC[2] = int(map(brightness, 0, 255, 0, c[2]));
    return newC;
  }
  
  public int nColors() {
    return nColors;
  }
  
  public int nPresets() {
    return presets.length;
  }
  
  public void newScheme() {
    switch(vibe) {
      case(0) : // DEFAULT
        genScheme(128);
        break;
      case(1) : // WARM
        genScheme(280, 420);
        break;
      case(2) : // COOL
        genScheme(62, 284);
        break;
      case(3) : // WHITE
        genSchemeWhite();
        break;
    }
  }
  
  public void genScheme(int colorThreshold) {
    scheme[0] = getColor(0);
    int[] newColor = scheme[0];
    while (euclideanDistance(scheme[0], newColor) < colorThreshold) {
      newColor = randColor();
    }
    scheme[1] = newColor;
      
    while (euclideanDistance(scheme[0], newColor) < colorThreshold ||
           euclideanDistance(scheme[1], newColor) < colorThreshold) {
      newColor = randColor();
    }
    scheme[2] = newColor;
    
    wheelPos = 0;
  }
  
  public void genScheme(int minHue, int maxHue) {
    minHue = (minHue + 360) % 360;
    maxHue = maxHue % 360;
    scheme[0] = randColor(minHue, maxHue);
    scheme[1] = randColor(minHue, maxHue);
    scheme[2] = randColor(minHue, maxHue);
    
    wheelPos = 0;
  }
  
  public void genSchemeWhite() {
    scheme[0] = new int[] {255, 255, 255};
    scheme[1] = new int[] {255, 255, 255};
    scheme[2] = new int[] {255, 255, 255};
  }

  public void setPreset(int preset) {
    if (preset < nPresets()) {
      int schemeLength = presets[preset].length;
      scheme = new int[schemeLength][3];
      for (int i = 0; i < schemeLength; i++) {
        scheme[i] = presets[preset][i];
      }
    }
  }

  private int[] getComplement(int[] c) {
    int[] newC = new int[3];

    for (int i = 0; i < 3; i++) {
      newC[i] = 255 - c[i];
    }

    return newC;
  }

  private int[] randColor() {
    return new int[] { rand.nextInt(256), rand.nextInt(256), rand.nextInt(256) };
  }
  
  private int[] randColor(int minHue, int maxHue) {
    minHue = (minHue + 360) % 360;
    maxHue = maxHue % 360;
    int[] c = new int[] { rand.nextInt(256), rand.nextInt(256), rand.nextInt(256) };
    int hue = getHue(c);
    if (minHue > maxHue) {
      while(hue > maxHue && hue < minHue) {
        c = new int[] { rand.nextInt(256), rand.nextInt(256), rand.nextInt(256) };
        hue = getHue(c);
      }
    } else {
      while(hue < minHue || hue > maxHue) {
        c = new int[] { rand.nextInt(256), rand.nextInt(256), rand.nextInt(256) };
        hue = getHue(c);
      }
    }
    return c;
  }

  private int[] genColor(int position, int idx, int[][] colors, int dist) {
    position = position - (idx * dist);
    int schemeLength = colors.length;
    int[] result = new int[3];
    for (int i = 0; i < 3; i++) {
      result[i] = 
        colors[idx][i] + 
          (position * 
            (colors[(idx+1) % schemeLength][i] - colors[idx][i]) / 
            dist);
    }
    return result;
  }

  private double euclideanDistance(int[] c1, int[] c2) {
    double sumOfCubes = 
      Math.pow(Math.abs(c2[0] - c1[0]), 3) +
      Math.pow(Math.abs(c2[1] - c1[1]), 3) +
      Math.pow(Math.abs(c2[2] - c1[2]), 3);
    return  Math.pow(sumOfCubes, 1.0/3);
  }

  private String strColor(int[] c) {
    return "(" + c[0] + ", " + c[1] + ", " + c[2] + ")";
  }
  
  private int getHue(int[] c) {
    float[] hsb = Color.RGBtoHSB(c[0], c[1], c[2], null);
    return (int) (360 * hsb[0]);
  }

}
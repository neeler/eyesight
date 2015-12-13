public class OscFix extends OscP5 {
  
  OscFix(PApplet theParent, int theReceiveAtPort) {
    super(theParent, theReceiveAtPort);
    theParent.registerMethod("dispose", this);
  }
  
  public void dispose() {
    stop();
  }
  
  public void stop() {
    super.stop();
  }
  
}
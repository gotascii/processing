/*
  Sets camera to point at the origin.
  Then moves camera to point at the magnet.
  Results in following around the magnet.
*/
class Camera{
  Magnet magnet;
  float cameraZ;

  Camera (Magnet magnet) {
    this.magnet = magnet;
    this.cameraZ = (height/2.0) / tan(PI*60.0 / 360.0);
  }

  void exist() {
    setCamera();
  }

  void setCamera() {
    beginCamera();
    camera(0, 0, cameraZ, 0, 0, 0, 0, 1, 0);
    translate(magnet.x, magnet.y, 0);
    endCamera();
  }
}




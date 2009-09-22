/*
  Starts on the center point of the mouse plane.
  Finds current mouse point distance (offset) from the center point of the mouse plane.
  Moves itself 1/5 that distance.
*/
class Magnet {
  float x, y, z, angle;
  float xo, yo;
  float inc = .13;

  Magnet() {
    x = width/2;
    y = height/2;
    z = 0;
  }

  void exist() {
    findOffset();
    setPosition();
    angle += inc;
  }

  void findOffset() {
    xo = (mouseX - width/2) / 5.0;
    yo = (mouseY - height/2) / 5.0;
  }

  void setPosition() {
    x += xo;
    y += yo;
    z = sin(angle) * 50.0;
  }
}


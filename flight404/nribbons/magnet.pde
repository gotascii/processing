
class Magnet {
  float x;
  float y;
  float z;

  float counter;
  float aug = .13;

  Magnet(){
    x = xMid;
    y = yMid;
    z = 0;
  }
  
  void exist(){
    findOffset();
    setPosition();
    counter += aug;
  }
  
  void setPosition(){
    x += xOff;
    y += yOff;
    z = sin(counter) * 50.0;
  }

  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  float getZ(){
    return z;
  }
}

class Mouse {
  float x, y, speed;

  Mouse(float speed) {
    this.speed = speed;
  }

  float xdist() {
    return mouseX - width/2;
  }

  float ydist() {
    return mouseY - height/2;
  }

  void move() {
    x += xdist() * speed;
    y += ydist() * speed;
  } 
}

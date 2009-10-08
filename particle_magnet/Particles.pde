class Particles {
  ArrayList particles;

  Particles() {
    this.particles = new ArrayList();
  }

  int size() {
    return particles.size();
  }

  void add(Object obj) {
    particles.add(obj);
  }

  Object get(int i) {
    return particles.get(i);
  }

  Object remove(int i) {
    return particles.remove(i);
  }

  void act() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      Gravity p = (Gravity)particles.get(i);
      p.act();
    }
  }

  void display() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IDisplayable p = (IDisplayable)particles.get(i);
      p.display();
    }
  }

  void move() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      Movable p = (Movable)particles.get(i);
      p.move();
    }
  }

  void constrain() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IConstrainable p = (IConstrainable)particles.get(i);
      p.constrain();
    }
  }
}

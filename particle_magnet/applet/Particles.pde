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

  void act() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IActable actor = (IActable)particles.get(i);
      actor.act();
    }
  }

  void display() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IDisplayable displayer = (IDisplayable)particles.get(i);
      displayer.display();
    }
  }

  void move() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IMovable mover = (IMovable)particles.get(i);
      mover.move();
    }
  }

  void constrain() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IConstrainable constrainer = (IConstrainable)particles.get(i);
      constrainer.constrain();
    }
  }

  void bounce() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      IBounceable bouncer = (IBounceable)particles.get(i);
      bouncer.bounce();
    }
  }
}

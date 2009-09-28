class Emitter{
  PVector loc;
  PVector vel;
  PVector velToMouse;
  float radius;

  color myColor;

  ArrayList particles;
  ArrayList nebulae;

  Emitter() {
    loc = new PVector();
    vel = new PVector();
    velToMouse = new PVector();
    radius = 100;
    myColor = color(1, 1, 1);
    particles = new ArrayList();
    nebulae = new ArrayList();
  }

  void exist() {
    findVelocity();
    setPosition();
    iterateListExist();
    render();

    gl.glDisable(GL.GL_TEXTURE_2D);
    
    if(ALLOWTRAILS)
      iterateListRenderTrails();
  }

  void findVelocity() {
    PVector mouseLoc = new PVector(mouseX - (width/2), mouseY - (height/2), 0);
    PVector d = PVector.sub(mouseLoc, loc);
    PVector dirToMouse = PVector.mult(d, 0.15);
    vel.set(dirToMouse);
  }

  void setPosition() {
    loc.add(vel);

    if(ALLOWFLOOR) {
      if(loc.y > floorLevel) {
        loc.y = floorLevel;
        vel.y = 0;
      }
    }
  }

  void iterateListExist() {
    gl.glEnable(GL.GL_TEXTURE_2D);

    int mylength = particles.size();
    for(int i = mylength - 1; i >= 0; i--) { 
      Particle p = (Particle)particles.get(i); 
      if(p.ISSPLIT) 
        addParticles(p);

      if (!p.ISDEAD) {
        images.particle.enable();
        images.particle.bind();
        p.exist();
        images.particle.disable();
      } else {
        particles.set(i, particles.get(particles.size() - 1));
        particles.remove(particles.size() - 1); 
      }
    }

    if(ALLOWFLOOR) {
      images.reflection.enable();
      images.reflection.bind();
      for(Iterator it = particles.iterator(); it.hasNext();) {
        Particle p = (Particle)it.next();
        p.renderReflection();
      }
      images.reflection.disable();
    }

    images.corona.enable();
    images.corona.bind();
    for(Iterator it = nebulae.iterator(); it.hasNext();) {
      Nebula n = (Nebula)it.next();
      if(!n.ISDEAD) {
        n.exist();
      } else {
        it.remove();
      }
    }
    images.corona.disable();
  }

  void render() {
    images.emitter.enable();
    images.emitter.bind();
    renderImage(loc, radius, myColor, 1.0);
    images.emitter.disable();

    if(ALLOWNEBULA) {
      nebulae.add(new Nebula(loc, 15.0, true));
      nebulae.add(new Nebula(loc, 45.0, true));
    }

    if(ALLOWFLOOR) {
      images.reflection.enable();
      images.reflection.bind();
      renderReflection();
      images.reflection.disable();
    }
  }

  void renderReflection(){
    float altitude = floorLevel - loc.y;
    float reflectMaxAltitude = 300.0;
    float yPer = 1.0 - altitude/reflectMaxAltitude;

    if(yPer > .05)
      renderImageOnFloor(new PVector(loc.x, floorLevel, loc.z), radius * 10.0, color(0.5, 1.0, yPer * .25), yPer);

    if(mousePressed)
      renderImageOnFloor(new PVector(loc.x, floorLevel, loc.z), radius + (yPer + 1.0) * radius * random(2.0, 3.5), color(1.0, 0, 0), yPer);
  }
  
  void iterateListRenderTrails() {
    for(Iterator it = particles.iterator(); it.hasNext();) {
      Particle p = (Particle)it.next();
      p.renderTrails();
    }
  }

  void addParticles(int _amt) {
    for( int i = 0; i < _amt; i++) {
      particles.add(new Particle(1, loc, vel));
    }

    if(ALLOWNEBULA) {
      nebulae.add(new Nebula(loc, 40.0, false));
      nebulae.add(new Nebula(loc, 100.0, false));
    }
  }

  void addParticles(Particle _p) {
    // play with amt if you want to control how many particles spawn when splitting
    int amt = (int)(_p.radius * .15);
    for(int i = 0; i < amt; i++){
      particles.add(new Particle(_p.gen + 1, _p.loc[0], _p.vel));
      if(ALLOWNEBULA)
        nebulae.add(new Nebula(_p.loc[0], random(5.0, 50.0), true));
    }
  }
}

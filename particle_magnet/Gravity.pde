class Gravity extends Movable implements IDisplayable, IConstrainable {
  Particles particles;
  float fcharge, bounce;

  Gravity(PeasyCam cam, float mass, PVector coords, float charge, float diameter, float fcharge, Particles particles) {
    initialize(cam, mass, coords, charge, diameter);
    this.particles = particles;
    this.fcharge = fcharge;
    this.bounce = 0;
  }

  void act() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      Movable p = (Movable)particles.get(i);
      float d = p.dist(this);
      float r = radius() + p.radius();
      if (d== r) {
        p.stop();
      } else if((d <= r) && (d > (r - 5))) {
        PVector n = PVector.sub(p.coords, coords);
        n.normalize();
        float vdotn = p.v.dot(n);
        PVector twovdotnn = PVector.mult(n, 2*vdotn);
        PVector v = PVector.sub(p.v, twovdotnn);
        v.mult(0.8);
        if (v.mag() > 0.5) {
          p.v = v;
        }
      } else if ((d > r) || (d <= (r - 5))) {
        p.accelerate(force(p));
      }
    }
  }

  PVector force(Movable from) {
    float distance = from.dist((Movable)this);
    float f = charge(from) / distance;
    PVector direction = PVector.sub(from.coords, coords);
    direction.normalize();
    return PVector.mult(direction, f);
  }

  float charge(Movable from) {
    float d = from.dist(this);
    float r = radius() + from.radius();
    if (d <= r) {
      return fcharge * -bounce;
    } 
    else {
      return fcharge;
    }
  }

  void constrain() {
    int count = particles.size();
    for(int i = 0; i < count; i++) {
      Movable p = (Movable)particles.get(i);
      float d = coords.dist(p.coords);
      float r = radius() + p.radius();
      if(d <= r) {
        PVector diff_v = PVector.sub(p.coords, coords);
        diff_v.normalize();
        float offset = r - d;
        diff_v.mult(offset);
        p.coords.add(diff_v);
      }
    }
  }

  void display() {
    noStroke();
    pushMatrix();
    translate(coords.x, coords.y, coords.z);
    face_cam();
    //    opengl();
    simple();
    popMatrix();
  }

  void simple() {
    //    fill(20, 100);
    fill(100, 10, 0, 100);
    ellipse(0, 0, diameter, diameter);
  }

  void opengl() {
    gl = pgl.beginGL();
    gl.glBlendFunc(GL.GL_ONE, GL.GL_ONE);

    tparticle.enable();
    tparticle.bind();
    gl.glColor4f(0.9, 0.2, 0.2, 1);
    gl.glScalef(diameter*2, diameter*2, diameter*2);
    for(int i = 0; i < 3; i++) {
      gl.glBegin(GL.GL_POLYGON);
      gl.glTexCoord2f(0, 0);
      gl.glVertex2f(-.5, -.5);
      gl.glTexCoord2f(1, 0);
      gl.glVertex2f( .5, -.5);
      gl.glTexCoord2f(1, 1);
      gl.glVertex2f( .5,  .5);
      gl.glTexCoord2f(0, 1);
      gl.glVertex2f(-.5,  .5);
      gl.glEnd();
    }
    tparticle.disable();
    pgl.endGL();
  }
}



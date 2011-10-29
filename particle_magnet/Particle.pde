class Particle extends Movable implements IDisplayable {
  color fill_color;

  Particle(PeasyCam cam, float mass, PVector coords, float charge, float diameter, color fill_color) {
    initialize(cam, mass, coords, charge, diameter);
    this.fill_color = fill_color;
  }

  void display() {
//    simple();
    opengl();
//    ribbon_tail();
//    line_tail();
  }

  void ribbon_tail() {
    colorMode(RGB, 1.0);
    beginShape(QUAD_STRIP);
    for(int i = 0; i < (len - 1); i++) {
      PVector ta = tail[i];
      PVector tb = tail[i + 1];

      PVector n = PVector.sub(ta, tb);
      PVector t = n.cross(new PVector(0, 1, 0));
      t.normalize();
      PVector v = n.cross(t);
      v.normalize();
      t = n.cross(v);
      t.normalize();

      float percent = 1.0 - (float)i/(float)(len - 1);

      t.mult(diameter * percent);

      PVector oa = PVector.sub(ta, t);
      PVector ob = PVector.add(ta, t); 
      fill(percent, percent*.5, 1.5 - percent, percent);
      vertex(oa.x, oa.y, oa.z);
      vertex(ob.x, ob.y, ob.z);
    }
    endShape();
    colorMode(RGB, 255.0);
  }

  void line_tail() {
    for(int i = 0; i < (len - 1); i++) {
      PVector ta = tail[i];
      PVector tb = tail[i + 1];
      float a = map(i, 0, (len - 1), 255, 0);
      float r = map(i, 0, (len - 1), 255, 0);
      float b = map(i, 0, (len - 1), 0, 255);
      float d = coords.dist(new PVector(0, 0, 0));
      float g = map(d, 0, 100, 0, 255);
      stroke(r, g, b, a);
      line(ta.x, ta.y, ta.z, tb.x, tb.y, tb.z);
    }
  }

  void simple() {
    pushMatrix();
    translate(coords.x, coords.y, coords.z);
    face_cam();
    noStroke();
    fill(fill_color);
    ellipse(0, 0, diameter, diameter);
    popMatrix();
  }

  void opengl() {
    pushMatrix();
    translate(coords.x, coords.y, coords.z);
    face_cam();
    gl = pgl.beginGL();
    gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);

    tparticle.enable();
    tparticle.bind();

    gl.glColor4f(1, 1, 1, 0.9);
    gl.glScalef(20, 20, 20);

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

    tparticle.disable();
    pgl.endGL();
    popMatrix();
  }
}

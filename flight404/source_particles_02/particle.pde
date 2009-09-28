class Particle{
  int len;            // number of elements in position array
  PVector[] loc;        // array of position vectors
  PVector startLoc;     // just used to make sure every loc[] is initialized to the same position
  PVector vel;          // velocity vector
  PVector perlin;       // perlin noise vector
  float radius;       // particle's size
  float age;          // current age of particle
  int lifeSpan;       // max allowed age of particle
  float agePer;       // range from 1.0 (birth) to 0.0 (death)
  int gen;            // number of times particle has been involved in a SPLIT
  float bounceAge;    // amount to age particle when it bounces off floor
  float bounceVel;    // speed at impact
  boolean ISDEAD;     // if age == lifeSpan, make particle die
  boolean ISBOUNCING; // if particle hits the floor...
  boolean ISSPLIT;    // if particle hits the floor with enough speed...

  PVector randomVector() {
    PVector rv = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    rv.normalize();
    return rv;
  }

  Particle(int _gen, PVector _loc, PVector _vel) {
    gen = _gen;
    radius = random(10 - gen, 50 - (gen - 1)*10);
    len = (int)(radius*.5);
    loc = new PVector[len];
    PVector rv = randomVector();
    rv.mult(random(1));
    _loc.add(rv);

    startLoc = new PVector();
    startLoc.set(_loc);

    for(int i = 0; i < len; i++) {
      loc[i] = new PVector();
      loc[i].set(startLoc);
    }

    vel = new PVector();
    vel.set(_vel);

    rv = randomVector();
    if(gen > 1) {
      rv.mult(random(7));
    } else {
      rv.mult(random(10));
    }
    vel.add(rv);

    perlin = new PVector();

    age = 0;
    bounceAge = 2;
    lifeSpan = (int)(radius);
  }

  void exist() {
    if(ALLOWPERLIN)
      findPerlin();

    findVelocity();
    setPosition();
    render();
    setAge();
  }

  void findPerlin() {
    float xyRads = getRads(loc[0].x, loc[0].z, 20.0, 50.0);
    float yRads = getRads(loc[0].x, loc[0].y, 20.0, 50.0);
    perlin.set(cos(xyRads), -sin(yRads), sin(xyRads));
    perlin.mult(0.5);
  }

  void findVelocity() {
    if(ALLOWGRAVITY)
      vel.add(gravity);

    if(ALLOWPERLIN)
      vel.add(perlin);

    if(ALLOWFLOOR) {
      if(loc[0].y + vel.y > floorLevel) {
        ISBOUNCING = true;
      } else {
        ISBOUNCING = false;
      }
    }

    // if the particle is moving fast enough, when it hits the ground it can
    // split into a bunch of smaller particles.
    if(ISBOUNCING) {
      bounceVel = vel.mag();

      vel.mult(0.7);
      vel.y *= -((radius/40.0 ) * .5);

      if(bounceVel > 15.0 && gen < 4)
        ISSPLIT  = true;

    } else {
      ISSPLIT = false;
    }
  }

  void setPosition() {
    for(int i = len-1; i > 0; i--) {
      loc[i].set(loc[i-1]);
    }

    loc[0].add(vel);
  }

  void render() {
    color c = color(agePer - .5, agePer*.25, 1.5 - agePer);
    renderImage(loc[0], radius * agePer, c, 1.0);

    // Rendering two graphics here. Makes the particles more vivid,
    // but will hinder the performance.
    c = color(1, agePer, agePer);
    renderImage(loc[0], radius * agePer * .5, c, agePer);
  }

  void renderReflection() {
    float altitude = floorLevel - loc[0].y;
    float reflectMaxAltitude = 25.0;
    float yPer = (1.0 - (altitude/reflectMaxAltitude)) * .5;

    if(yPer > .05)
      renderImageOnFloor(new PVector(loc[0].x, floorLevel, loc[0].z), radius * agePer * 8.0 * yPer, color(agePer, agePer*.25, 0), yPer + random(.2));
  }

  void renderTrails() {
    float xp, yp, zp;
    float xOff, yOff, zOff;

    gl.glBegin(GL.GL_QUAD_STRIP);

    for (int i = 0; i < len - 1; i++) {
      float per = 1.0 - (float)i/(float)(len-1);
      xp = loc[i].x;
      yp = loc[i].y;
      zp = loc[i].z;

      if (i < len - 2) {
        PVector perp0 = PVector.sub(loc[i], loc[i+1]);
        PVector perp1 = perp0.cross(new PVector(0, 1, 0));
        perp1.normalize();
        PVector perp2 = perp0.cross(perp1);
        perp2.normalize();
        perp1 = perp0.cross(perp2);
        perp1.normalize();

        xOff = perp1.x * radius * agePer * per * .05;
        yOff = perp1.y * radius * agePer * per * .05;
        zOff = perp1.z * radius * agePer * per * .05;

        gl.glColor4f(per, per*.5, 1.5 - per, per);
        gl.glVertex3f(xp - xOff, yp - yOff, zp - zOff);
        gl.glVertex3f(xp + xOff, yp + yOff, zp + zOff);
      }
    }

    gl.glEnd();
  }
  
  void setAge() {
    if(ALLOWFLOOR) {
      if(ISBOUNCING) {
        age += bounceAge;
        bounceAge++;
      } else {
        age += .025;
      }
    } else {
      age++;
    }

    if(age > lifeSpan) {
      ISDEAD = true;
    } else {
      agePer = 1.0 - age/(float)lifeSpan;
    }
  }
}

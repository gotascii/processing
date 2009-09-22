class Particle {
  int index;

  float x, y;
  float xv, yv;
  float radius;

  float damp;
  float E, R, F, P, A;
  float Q, M;

  boolean gone;

  ArrayList parent;

  Particle(int sentIndex, ArrayList parentSent, int xSent, int ySent){
    index     = sentIndex;
    parent    = parentSent;
    radius    = 5;
    M         = .5;
    Q         = 2;
    damp      = .9;

    x         = (float)xSent;
    y         = (float)ySent;
  }

  void exist(){
    repelParticles();
    move();
    render();
  }


  void repelParticles(){
    //Q -= (Q - (control.baseSize/2.0 + mySize[0]/2.0)) * .5;

    for (Iterator it=parent.iterator(); it.hasNext(); ) {
      Particle inner = (Particle) it.next();
      if (inner != this){
        R             = dist(x, y, inner.x, inner.y);
        E             = inner.Q/(R * R);
        P             = Q * inner.Q / pow(R,6);
        F             = (Q * E) + P;
        A             = (F/M) * 2.0;
        if (R > 2.0) { 
          xv += A * (x - inner.x) / R; 
          yv += A * (y - inner.y) / R; 
        }
      }
    }
    xv *= damp;
    yv *= damp;
  }

  void move(){
    x += xv;
    y += yv;
  }

  void render(){
    fill(0);
    ellipse(x,y,radius,radius);
  }
}


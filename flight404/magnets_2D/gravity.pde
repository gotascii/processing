class Gravity{
  int index;
  float x, y;
  float E, R, F, P, A;
  float Q, M;
  
  Gravity(){
    x            = xMid;
    y            = yMid;
    Q            = 0.01;
  }
  
  void exist(){
    attractParticles();
    render();
  }

  void attractParticles(){

    for (Iterator it = particles.iterator(); it.hasNext(); ) {
      Particle me = (Particle) it.next();

      R             = dist(x, y, me.x, me.y);
      
      M             = 0.05 * ((R/100.0));
      Q             = M*2.0;
     
      E             = me.Q/(R * R);
      P             = abs(Q) * abs(me.Q) / pow(R,3);
      F             = (Q * E) + P;
      A             = (F/M) * 6.0;
      
      if (R > 95) { 
        me.xv      += A * (x - me.x); 
        me.yv      += A * (y - me.y); 
      } else {
        float pen = 95 - R;
        if (pen > 1) {
          PVector g = new PVector(x, y);
          PVector p = new PVector(me.x, me.y);
          PVector n = PVector.sub(p, g);
          PVector v = new PVector(me.xv, me.yv);
          n.normalize();
          float vdotn = v.dot(n);
          PVector twovdotnn = PVector.mult(n, 2*vdotn);
          v = PVector.sub(v, twovdotnn);
          v.mult(0.7);
          me.xv = v.x;
          me.yv = v.y;
          me.xv      -= A * (x - me.x);
          me.yv      -= A * (y - me.y);
        } else if (pen <= 1) {
          me.xv = 0;
          me.yv = 0;
        }
      }
//      else if (R > 93 && R <= 95) {
//        PVector g = new PVector(x, y);
//        PVector p = new PVector(me.x, me.y);
//        PVector n = PVector.sub(p, g);
//        PVector v = new PVector(me.xv, me.yv);
//        n.normalize();
//        float vdotn = v.dot(n);
//        PVector twovdotnn = PVector.mult(n, 2*vdotn);
//        v = PVector.sub(v, twovdotnn);
//        v.mult(0.7);
//        me.xv = v.x;
//        me.yv = v.y;
//      } else {
//        me.xv      -= A * (x - me.x);
//        me.yv      -= A * (y - me.y);
//      }
    }
  }

  void render(){
    fill(0);
    ellipse(x, y, 20, 20);
    noFill();
    stroke(0);
    ellipse(x, y, 190, 190);
  }
}

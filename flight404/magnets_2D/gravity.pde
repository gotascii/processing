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
      
      if (R > 50) { 
        me.xv      += A * (x - me.x); 
        me.yv      += A * (y - me.y); 
      } else if (R > 2.0 && R < 50){
        me.xv      -= A * (x - me.x); 
        me.yv      -= A * (y - me.y); 
      }
    }
  }

  void render(){
    fill(0);
    ellipse(x, y, 20, 20);
    noFill();
    stroke(0);
    ellipse(x, y, 90, 90);
  }
}
